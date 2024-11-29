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

module pcie_7x_0_axi_basic_tx_pipeline #(
  parameter C_DATA_WIDTH = 64,           // RX/TX interface data width
  parameter C_PM_PRIORITY = "FALSE",      // Disable TX packet boundary thrtl
  // Do not override parameters below this line
  parameter REM_WIDTH  = (C_DATA_WIDTH == 128) ? 2 : 1, // trem/rrem width
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8               // KEEP width
  ) (
  // User Design I/O
  // AXI TX
  input      [C_DATA_WIDTH-1:0] s_axis_tx_tdata,     // TX data from user
  input                         s_axis_tx_tvalid,    // TX data is valid
  output                        s_axis_tx_tready,    // TX ready for data
  input        [KEEP_WIDTH-1:0] s_axis_tx_tkeep,     // TX strobe byte enables
  input                         s_axis_tx_tlast,     // TX data is last
  input                   [3:0] s_axis_tx_tuser,     // TX user signals
  // PCIe Block I/O
  // TRN TX
  output     [C_DATA_WIDTH-1:0] trn_td,              // TX data from block
  output                        trn_tsof,            // TX start of packet
  output                        trn_teof,            // TX end of packet
  output                        trn_tsrc_rdy,        // TX source ready
  input                         trn_tdst_rdy,        // TX destination ready
  output                        trn_tsrc_dsc,        // TX source discontinue
  output        [REM_WIDTH-1:0] trn_trem,            // TX remainder
  output                        trn_terrfwd,         // TX error forward
  output                        trn_tstr,            // TX streaming enable
  output                        trn_tecrc_gen,       // TX ECRC generate
  input                         trn_lnk_up,          // PCIe link up
  // System
  input                         tready_thrtl,        // TREADY from thrtl ctl
  input                         user_clk,            // user clock from block
  input                         user_rst             // user reset from block
);

// Input register stage
reg  [C_DATA_WIDTH-1:0] reg_tdata;
reg                     reg_tvalid;
reg    [KEEP_WIDTH-1:0] reg_tkeep;
reg               [3:0] reg_tuser;
reg                     reg_tlast;
reg                     reg_tready;

// Pipeline utility signals
reg                     trn_in_packet;
reg                     axi_in_packet;
reg                     flush_axi;
wire                    disable_trn;
reg                     reg_disable_trn;

wire                    axi_beat_live  = s_axis_tx_tvalid && s_axis_tx_tready;
wire                    axi_end_packet = axi_beat_live && s_axis_tx_tlast;

//----------------------------------------------------------------------------//
// Convert TRN data format to AXI data format. AXI is DWORD swapped from TRN. //
// 128-bit:                 64-bit:                  32-bit:                  //
// TRN DW0 maps to AXI DW3  TRN DW0 maps to AXI DW1  TNR DW0 maps to AXI DW0  //
// TRN DW1 maps to AXI DW2  TRN DW1 maps to AXI DW0                           //
// TRN DW2 maps to AXI DW1                                                    //
// TRN DW3 maps to AXI DW0                                                    //
//----------------------------------------------------------------------------//
assign trn_td = {reg_tdata[31:0], reg_tdata[63:32]};


//----------------------------------------------------------------------------//
// Create trn_tsof. If we're not currently in a packet and TVALID goes high,  //
// assert TSOF.                                                               //
//----------------------------------------------------------------------------//
assign trn_tsof = reg_tvalid && !trn_in_packet;

//----------------------------------------------------------------------------//
// Create trn_in_packet. This signal tracks if the TRN interface is currently //
// in the middle of a packet, which is needed to generate trn_tsof            //
//----------------------------------------------------------------------------//
always @(posedge user_clk) begin
  if(user_rst)
    trn_in_packet <= 1'b0;
  else begin
    if(trn_tsof && trn_tsrc_rdy && trn_tdst_rdy && !trn_teof)
      trn_in_packet <= 1'b1;
    else if((trn_in_packet && trn_teof && trn_tsrc_rdy) || !trn_lnk_up)
      trn_in_packet <= 1'b0;
  end
end


//----------------------------------------------------------------------------//
// Create axi_in_packet. This signal tracks if the AXI interface is currently //
// in the middle of a packet, which is needed in case the link goes down.     //
//----------------------------------------------------------------------------//
always @(posedge user_clk) begin
  if(user_rst)
    axi_in_packet <= 1'b0;
  else begin
    if(axi_beat_live && !s_axis_tx_tlast)
      axi_in_packet <= 1'b1;
    else if(axi_beat_live)
      axi_in_packet <= 1'b0;
  end
end


//----------------------------------------------------------------------------//
// Create disable_trn. This signal asserts when the link goes down and        //
// triggers the deassertiong of trn_tsrc_rdy. The deassertion of disable_trn  //
// depends on C_PM_PRIORITY, as described below.                              //
//----------------------------------------------------------------------------//
// In the throttle-controlled pipeline, we don't have a previous value buffer.
// The throttle control mechanism handles TREADY, so all we need to do is
// detect when the link goes down and disable the TRN interface until the link
// comes back up and the AXI interface is finished flushing any packets.
// TODO: without power management, this never happens?
always @(posedge user_clk) begin
  if(user_rst) reg_disable_trn <= 1'b0;
  else begin
	// If the link is down and AXI is in packet, disable TRN and look for
	// the end of the packet
	if(axi_in_packet && !trn_lnk_up && !axi_end_packet)
	  reg_disable_trn  <= 1'b1;
	// AXI packet is ending, so we're done flushing
	else if(axi_end_packet)
	  reg_disable_trn <= 1'b0;
  end
end

// Disable the TRN interface if link is down or we're still flushing the AXI
// interface.
assign disable_trn = reg_disable_trn || !trn_lnk_up;

//----------------------------------------------------------------------------//
// Convert STRB to RREM. Here, we are converting the encoding method for the  //
// location of the EOF from AXI (tkeep) to TRN flavor (rrem).                 //
//----------------------------------------------------------------------------//
assign trn_trem    = reg_tkeep[7];

//----------------------------------------------------------------------------//
// Create remaining TRN signals                                               //
//----------------------------------------------------------------------------//
assign trn_teof      = reg_tlast;
assign trn_tecrc_gen = reg_tuser[0];
assign trn_terrfwd   = reg_tuser[1];
assign trn_tstr      = reg_tuser[2];
assign trn_tsrc_dsc  = reg_tuser[3];


// Pipeline stage
// We need one of two approaches for the pipeline stage depending on the
// C_PM_PRIORITY parameter.
reg reg_tsrc_rdy;
always @(posedge user_clk) begin
  if(user_rst) begin
	reg_tdata        <= {C_DATA_WIDTH{1'b0}};
	reg_tvalid       <= 1'b0;
	reg_tkeep        <= {KEEP_WIDTH{1'b0}};
	reg_tlast        <= 1'b0;
	reg_tuser        <= 4'h0;
	reg_tsrc_rdy     <= 1'b0;
  end else begin
	reg_tdata        <= s_axis_tx_tdata;
	reg_tvalid       <= s_axis_tx_tvalid;
	reg_tkeep        <= s_axis_tx_tkeep;
	reg_tlast        <= s_axis_tx_tlast;
	reg_tuser        <= s_axis_tx_tuser;

	// Hold trn_tsrc_rdy low when flushing a packet.
	reg_tsrc_rdy     <= axi_beat_live && !disable_trn;
  end
end

assign trn_tsrc_rdy = reg_tsrc_rdy;

// With TX packet boundary throttling, TREADY is pipelined in
// axi_basic_tx_thrtl_ctl and wired through here.
assign s_axis_tx_tready = tready_thrtl;

endmodule
