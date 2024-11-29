// This file is licensed by the Vivado 2019.1 Webpack EULA available at
// https://download.amd.com/docnav/documents/eula/end-user-license-agreement_2019.1.pdf
//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
`timescale 1ps/1ps

module pcie_7x_0_axi_basic_rx_pipeline #(
  parameter C_DATA_WIDTH = 64,           // RX/TX interface data width
  parameter C_FAMILY     = "X7",          // Targeted FPGA family
  // Do not override parameters below this line
  parameter REM_WIDTH  = 1, // trem/rrem width
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8               // KEEP width
  ) (

  // AXI RX
  output reg [C_DATA_WIDTH-1:0] m_axis_rx_tdata,     // RX data to user
  output reg                    m_axis_rx_tvalid,    // RX data is valid
  input                         m_axis_rx_tready,    // RX ready for data
  output       [KEEP_WIDTH-1:0] m_axis_rx_tkeep,     // RX strobe byte enables
  output                        m_axis_rx_tlast,     // RX data is last
  output reg             [21:0] m_axis_rx_tuser,     // RX user signals

  // TRN RX
  input      [C_DATA_WIDTH-1:0] trn_rd,              // RX data from block
  input                         trn_rsof,            // RX start of packet
  input                         trn_reof,            // RX end of packet
  input                         trn_rsrc_rdy,        // RX source ready
  output reg                    trn_rdst_rdy,        // RX destination ready
  input                         trn_rsrc_dsc,        // RX source discontinue, assume this never happens
  input         [REM_WIDTH-1:0] trn_rrem,            // RX remainder
  input                         trn_rerrfwd,         // RX error forward
  input                   [6:0] trn_rbar_hit,        // RX BAR hit
  input                         trn_recrc_err,       // RX ECRC error

  // System
  input                         user_clk,            // user clock from block
  input                         user_rst             // user reset from block
);

// Wires and regs for creating AXI signals
wire              [4:0] is_sof;
wire              [4:0] is_sof_prev;

wire              [4:0] is_eof;
wire              [4:0] is_eof_prev;

reg    [KEEP_WIDTH-1:0] reg_tkeep;
wire   [KEEP_WIDTH-1:0] tkeep;
wire   [KEEP_WIDTH-1:0] tkeep_prev;

reg                     reg_tlast;
wire                    rsrc_rdy_filtered;

// Wires and regs for previous value buffer
wire [C_DATA_WIDTH-1:0] trn_rd_DW_swapped;
reg  [C_DATA_WIDTH-1:0] trn_rd_prev;

wire                    data_hold;
reg                     data_prev;

reg                     trn_reof_prev;
reg     [REM_WIDTH-1:0] trn_rrem_prev;
reg                     trn_rsrc_rdy_prev;
reg                     trn_rsrc_dsc_prev;
reg                     trn_rsof_prev;
reg               [6:0] trn_rbar_hit_prev;
reg                     trn_rerrfwd_prev;
reg                     trn_recrc_err_prev;

// Null packet handling signals
reg                     trn_in_packet;


// Create "filtered" version of rsrc_rdy, where discontinued SOFs are removed.
assign rsrc_rdy_filtered = trn_rsrc_rdy &&
                                 (trn_in_packet || (trn_rsof && !trn_rsrc_dsc));

//----------------------------------------------------------------------------//
// Previous value buffer                                                      //
// ---------------------                                                      //
// We are inserting a pipeline stage in between TRN and AXI, which causes     //
// some issues with handshaking signals m_axis_rx_tready/trn_rdst_rdy. The    //
// added cycle of latency in the path causes the user design to fall behind   //
// the TRN interface whenever it throttles.                                   //
//                                                                            //
// To avoid loss of data, we must keep the previous value of all trn_r*       //
// signals in case the user throttles.                                        //
//----------------------------------------------------------------------------//
always @(posedge user_clk) begin
  if(user_rst) begin
    trn_rd_prev        <= {C_DATA_WIDTH{1'b0}};
    trn_rsof_prev      <= 1'b0;
    trn_rrem_prev      <= {REM_WIDTH{1'b0}};
    trn_rsrc_rdy_prev  <= 1'b0;
    trn_rbar_hit_prev  <= 7'h00;
    trn_rerrfwd_prev   <= 1'b0;
    trn_recrc_err_prev <= 1'b0;
    trn_reof_prev      <= 1'b0;
    trn_rsrc_dsc_prev  <= 1'b0;
  end
  else begin
    // prev buffer works by checking trn_rdst_rdy. When trn_rdst_rdy is
    // asserted, a new value is present on the interface.
	if(trn_rdst_rdy) begin // this is output signal
      trn_rd_prev        <= trn_rd_DW_swapped;
      trn_rsof_prev      <= trn_rsof;
      trn_rrem_prev      <= trn_rrem;
      trn_rbar_hit_prev  <= trn_rbar_hit;
      trn_rerrfwd_prev   <= trn_rerrfwd;
      trn_recrc_err_prev <= trn_recrc_err;
      trn_rsrc_rdy_prev  <= rsrc_rdy_filtered;
      trn_reof_prev      <= trn_reof;
      trn_rsrc_dsc_prev  <= trn_rsrc_dsc;
    end
  end
end

//----------------------------------------------------------------------------//
// Create TDATA                                                               //
//----------------------------------------------------------------------------//

// Convert TRN data format to AXI data format. AXI is DWORD swapped from TRN
// 128-bit:                 64-bit:                  32-bit:
// TRN DW0 maps to AXI DW3  TRN DW0 maps to AXI DW1  TNR DW0 maps to AXI DW0
// TRN DW1 maps to AXI DW2  TRN DW1 maps to AXI DW0
// TRN DW2 maps to AXI DW1
// TRN DW3 maps to AXI DW0
assign trn_rd_DW_swapped = {trn_rd[31:0], trn_rd[63:32]};

// Create special buffer which locks in the proper value of TDATA depending
// on whether the user is throttling or not. This buffer has three states:
//
//       HOLD state: TDATA maintains its current value
//                   - the user has throttled the PCIe block
//   PREVIOUS state: the buffer provides the previous value on trn_rd
//                   - the user has finished throttling, and is a little behind
//                     the PCIe block
//    CURRENT state: the buffer passes the current value on trn_rd
//                   - the user is caught up and ready to receive the latest
//                     data from the PCIe block
always @(posedge user_clk) begin
  if(user_rst)
    m_axis_rx_tdata <= {C_DATA_WIDTH{1'b0}};
  else begin
    if(!data_hold) begin
      // PREVIOUS state
      if(data_prev)
        m_axis_rx_tdata <= trn_rd_prev;
      // CURRENT state
      else
        m_axis_rx_tdata <= trn_rd_DW_swapped;
    end
    // else HOLD state
  end
end

// Logic to instruct pipeline to hold its value
assign data_hold = (!m_axis_rx_tready && m_axis_rx_tvalid);

// Logic to instruct pipeline to use previous bus values. Always use previous
// value after holding a value.
always @(posedge user_clk) begin
  if(user_rst)
    data_prev <= 1'b0;
  else
    data_prev <= data_hold;
end

//----------------------------------------------------------------------------//
// Create TVALID, TLAST, tkeep, TUSER                                         //
// -----------------------------------                                        //
// Use the same strategy for these signals as for TDATA, except here we need  //
// an extra provision for null packets.                                       //
//----------------------------------------------------------------------------//
always @(posedge user_clk) begin
  if(user_rst) begin
    m_axis_rx_tvalid <= 1'b0;
    reg_tlast        <= 1'b0;
    reg_tkeep        <= {KEEP_WIDTH{1'b1}};
    m_axis_rx_tuser  <= 22'h0;
  end
  else begin
    if(!data_hold) begin
      // PREVIOUS state
      if(data_prev) begin
        m_axis_rx_tvalid <= (trn_rsrc_rdy_prev);
        reg_tlast        <= trn_reof_prev;
        reg_tkeep        <= tkeep_prev;
        m_axis_rx_tuser  <= {is_eof_prev,          // TUSER bits [21:17]
                                  2'b00,                // TUSER bits [16:15]
                                  is_sof_prev,          // TUSER bits [14:10]
                                  1'b0,                 // TUSER bit  [9]
                                  trn_rbar_hit_prev,    // TUSER bits [8:2]
                                  trn_rerrfwd_prev,     // TUSER bit  [1]
                                  trn_recrc_err_prev};  // TUSER bit  [0]
      end

      // CURRENT state
      else begin
        m_axis_rx_tvalid <= (rsrc_rdy_filtered);
        reg_tlast        <= trn_reof;
        reg_tkeep        <= tkeep;
        m_axis_rx_tuser  <= {is_eof,               // TUSER bits [21:17]
                                  2'b00,                // TUSER bits [16:15]
                                  is_sof,               // TUSER bits [14:10]
                                  1'b0,                 // TUSER bit  [9]
                                  trn_rbar_hit,         // TUSER bits [8:2]
                                  trn_rerrfwd,          // TUSER bit  [1]
                                  trn_recrc_err};       // TUSER bit  [0]
      end
    end
    // else HOLD state
  end
end

// Hook up TLAST and tkeep depending on interface width
assign m_axis_rx_tlast = reg_tlast;
assign m_axis_rx_tkeep = reg_tkeep;

//----------------------------------------------------------------------------//
// Create tkeep                                                               //
// ------------                                                               //
// Convert RREM to STRB. Here, we are converting the encoding method for the  //
// location of the EOF from TRN flavor (rrem) to AXI (tkeep).                 //
//                                                                            //
// NOTE: for each configuration, we need two values of tkeep, the current and //
//       previous values. The need for these two values is described below.   //
//----------------------------------------------------------------------------//
// 64-bit interface: contains 2 DWORDs per cycle, for a total of 8 bytes
//  - tkeep has only two possible values here, 0xFF or 0x0F
assign tkeep      = trn_rrem      ? 8'hFF : 8'h0F;
assign tkeep_prev = trn_rrem_prev ? 8'hFF : 8'h0F;

//----------------------------------------------------------------------------//
// Create is_sof                                                              //
// -------------                                                              //
// is_sof is a signal to the user indicating the location of SOF in TDATA   . //
// Due to inherent 64-bit alignment of packets from the block, the only       //
// possible values are:                                                       //
//                      Value                      Valid data widths          //
//                      5'b11000 (sof @ byte 8)    128                        //
//                      5'b10000 (sof @ byte 0)    128, 64, 32                //
//                      5'b00000 (sof not present) 128, 64, 32                //
//----------------------------------------------------------------------------//
assign is_sof      = {(trn_rsof && !trn_rsrc_dsc), // bit 4:   enable
					  4'b0000};                    // bit 3-0: hardwired 0

assign is_sof_prev = {(trn_rsof_prev && !trn_rsrc_dsc_prev), // bit 4
					  4'b0000};                              // bit 3-0

//----------------------------------------------------------------------------//
// Create is_eof                                                              //
// -------------                                                              //
// is_eof is a signal to the user indicating the location of EOF in TDATA   . //
// Due to DWORD granularity of packets from the block, the only               //
// possible values are:                                                       //
//                      Value                      Valid data widths          //
//                      5'b11111 (eof @ byte 15)   128                        //
//                      5'b11011 (eof @ byte 11)   128                        //
//                      5'b10111 (eof @ byte 7)    128, 64                    //
//                      5'b10011 (eof @ byte 3)`   128, 64, 32                //
//                      5'b00011 (eof not present) 128, 64, 32                //
//----------------------------------------------------------------------------//
assign is_eof      = {trn_reof,      // bit 4:   enable
					  1'b0,          // bit 3:   hardwired 0
					  trn_rrem,      // bit 2:   encoded eof loc from block
					  2'b11};        // bit 1-0: hardwired 1

assign is_eof_prev = {trn_reof_prev, // bit 4:   enable
					  1'b0,          // bit 3:   hardwired 0
					  trn_rrem_prev, // bit 2:   encoded eof loc from block
					  2'b11};        // bit 1-0: hardwired 1

//----------------------------------------------------------------------------//
// Create trn_rdst_rdy                                                        //
//----------------------------------------------------------------------------//
always @(posedge user_clk) begin
  if(user_rst)
    trn_rdst_rdy <= 1'b0;
  else begin
    // If in a packet, pass user back-pressure directly to block
    if(m_axis_rx_tvalid)
      trn_rdst_rdy <= m_axis_rx_tready;

    // If idle, default to no back-pressure. We need to default to the
    // "ready to accept data" state to make sure we catch the first
    // clock of data of a new packet.
    else
      trn_rdst_rdy <= 1'b1;
  end
end

//----------------------------------------------------------------------------//
// Create discontinue tracking signals                                        //
//----------------------------------------------------------------------------//
// Create signal trn_in_packet, which is needed to validate trn_rsrc_dsc. We
// should ignore trn_rsrc_dsc when it's asserted out-of-packet.
always @(posedge user_clk) begin
  if(user_rst)
    trn_in_packet <= 1'b0;
  else begin
    if(trn_rsof && !trn_reof && rsrc_rdy_filtered && trn_rdst_rdy)
      trn_in_packet <= 1'b1;
    else if(trn_rsrc_dsc)
      trn_in_packet <= 1'b0;
    else if(trn_reof && !trn_rsof && trn_rsrc_rdy && trn_rdst_rdy)
      trn_in_packet <= 1'b0;
  end
end

endmodule
