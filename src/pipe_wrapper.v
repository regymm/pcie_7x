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
//---------- PIPE Wrapper Parameter Encoding -----------------------------------
//  PCIE_SIM_MODE                 : "FALSE" = Normal mode (default)
//                                : "TRUE"  = Simulation only
//  PCIE_SIM_TX_EIDLE_DRIVE_LEVEL : "0", "1" (default), "X" simulation TX electrical idle drive level 
//  PCIE_GT_DEVICE                : "GTX" (default)
//                                : "GTH"
//                                : "GTP"
//  PCIE_USE_MODE                 : "1.0" = GTX IES 325T or GTP IES/GES use mode.
//                                : "1.1" = GTX IES 485T use mode.
//                                : "2.0" = GTH IES 690T use mode for 1.0 silicon.
//                                : "2.1" = GTH GES 690T use mode for 1.2 and 2.0 silicon.  SW model use "2.0"
//                                : "3.0" = GTX GES 325T or 485T use mode (default).
//  PCIE_PLL_SEL                  : "CPLL" (default)
//                                : "QPLL"
//  PCIE_AUX_CDR_GEN3_EN          : "FALSE" Use Primary CDR for Gen3 only (GTH 2.0) 
//                                : "TRUE"  Use AUX CDR for Gen3 only (default) (GTH 2.0)
//  PCIE_LPM_DFE                  : "DFE" for Gen1/Gen2 only (GTX, GTH)
//                                : "LPM" for Gen1/Gen2 only (default) (GTX, GTH)
//  PCIE_LPM_DFE_GEN3             : "DFE" for Gen3 only (GTX, GTH)
//                                : "LPM" for Gen3 only (default) (GTX, GTH)
//  PCIE_EXT_CLK                  : "FALSE" = Use internal clock module(default)
//                                : "TRUE"  = Use external clock module
//  PCIE_POWER_SAVING             : "FALSE" = Disable PLL power saving
//                                : "TRUE"  = Enable PLL power saving (default)
//  PCIE_ASYNC_EN                 : "FALSE" = Synchronous  mode (default)
//                                : "TRUE"  = Asynchronous mode.
//  PCIE_TXBUF_EN                 : "FALSE" = TX buffer bypass for Gen1/Gen2 only (default)
//                                : "TRUE"  = TX buffer use    for Gen1/Gen2 only (for debug only)
//  PCIE_RXBUF_EN                 : "FALSE" = RX buffer bypass for Gen3      only (not supported)
//                                : "TRUE"  = RX buffer use    for Gen3      only (default)
//  PCIE_TXSYNC_MODE              : 0 = Manual TX sync (default) (GTX, GTH)
//                                : 1 = Auto TX sync (GTH)
//  PCIE_RXSYNC_MODE              : 0 = Manual RX sync (default) (GTX, GTH)
//                                : 1 = Auto RX sync (GTH)
//  PCIE_CHAN_BOND                : 0 = One-Hop (default)
//                                : 1 = Daisy-Chain
//                                : 2 = Binary-Tree
//  PCIE_CHAN_BOND_EN             : "FALSE" = Channel bonding disable for Gen1/Gen2 only
//                                : "TRUE"  = Channel bonding enable  for Gen1/Gen2 only
//  PCIE_LANE                     : 1 (default), 2, 4, or 8
//  PCIE_LINK_SPEED               : 1 = PCIe Gen1           Mode
//                                : 2 = PCIe Gen1/Gen2      Mode (default)
//                                : 3 = PCIe Gen1/Gen2/Gen3 Mode
//  PCIE_REFCLK_FREQ              : 0 = 100 MHz (default)
//                                : 1 = 125 MHz
//                                : 2 = 250 MHz
//  PCIE_USERCLK[1/2]_FREQ        : 0 = Disable user clock
//                                : 1 =  31.25 MHz
//                                : 2 =  62.50 MHz (default)
//                                : 3 = 125.00 MHz
//                                : 4 = 250.00 MHz
//                                : 5 = 500.00 MHz
//  PCIE_TX_EIDLE_ASSERT_DELAY    : 3'd0 to 3'd7 (default = 3'd4)
//  PCIE_RXEQ_MODE_GEN3           : 0 = Return same TX coefficients 
//                                : 1 = Return TX preset #5
//  PCIE_OOBCLK_MODE              : 0 = Reference clock
//                                : 1 =  62.50 MHz (default)
//                                : 2 =  50.00 MHz (requires 1 BUFG)
//  PCIE_JTAG_MODE                : 0 = Normal operation (default)
//                                : 1 = JTAG mode (for debug only)
//  PCIE_DEBUG_MODE               : 0 = Normal operation (default)
//                                : 1 = Debug mode (for debug only)
//------------------------------------------------------------------------------

//  Data Width : This PIPE Wrapper supports a 32-bit [TX/RX]DATA interface.  
//               In Gen1/Gen2 modes, only 16-bits [15:0] are used.
//               In Gen3 mode, all 32-bits are used.

`timescale 1ns / 1ps

module pipe_wrapper # (
    parameter PCIE_SIM_MODE                 = "TRUE",      // PCIe sim mode 
    parameter PCIE_SIM_SPEEDUP              = "TRUE",      // PCIe sim speedup
    parameter PCIE_SIM_TX_EIDLE_DRIVE_LEVEL = "1",          // PCIe sim TX electrical idle drive level 
    parameter PCIE_GT_DEVICE                = "GTP",        // PCIe GT device
    parameter PCIE_USE_MODE                 = "1.0",        // PCIe use mode
    parameter PCIE_PLL_SEL                  = "CPLL",       // PCIe PLL select for Gen1/Gen2 (GTX/GTH) only
    parameter PCIE_AUX_CDR_GEN3_EN          = "TRUE",       // PCIe AUX CDR for Gen3 (GTH 2.0) only
    parameter PCIE_LPM_DFE                  = "LPM",        // PCIe LPM or DFE mode for Gen1/Gen2 only
    parameter PCIE_LPM_DFE_GEN3             = "DFE",        // PCIe LPM or DFE mode for Gen3      only
    parameter PCIE_EXT_CLK                  = "TRUE",       // PCIe external clock
    parameter PCIE_EXT_GT_COMMON            = "FALSE",      // PCIe external GT COMMON
    parameter EXT_CH_GT_DRP                 = "FALSE",      // PCIe external CH DRP

    parameter TX_MARGIN_FULL_0              = 7'b1001111,                          // 1000 mV
    parameter TX_MARGIN_FULL_1              = 7'b1001110,                          // 950 mV
    parameter TX_MARGIN_FULL_2              = 7'b1001101,                          // 900 mV
    parameter TX_MARGIN_FULL_3              = 7'b1001100,                          // 850 mV
    parameter TX_MARGIN_FULL_4              = 7'b1000011,                          // 400 mV
    parameter TX_MARGIN_LOW_0               = 7'b1000101,                          // 500 mV
    parameter TX_MARGIN_LOW_1               = 7'b1000110 ,                          // 450 mV
    parameter TX_MARGIN_LOW_2               = 7'b1000011,                          // 400 mV
    parameter TX_MARGIN_LOW_3               = 7'b1000010 ,                          // 350 mV
    parameter TX_MARGIN_LOW_4               = 7'b1000000 ,

    parameter PCIE_POWER_SAVING             = "TRUE",       // PCIe power saving
    parameter PCIE_ASYNC_EN                 = "TRUE",      // PCIe async enable
    parameter PCIE_TXBUF_EN                 = "FALSE",      // PCIe TX buffer enable for Gen1/Gen2 only
    parameter PCIE_RXBUF_EN                 = "TRUE",       // PCIe RX buffer enable for Gen3      only
    parameter PCIE_TXSYNC_MODE              = 0,            // PCIe TX sync mode
    parameter PCIE_RXSYNC_MODE              = 0,            // PCIe RX sync mode
    parameter PCIE_CHAN_BOND                = 1,            // PCIe channel bonding mode
    parameter PCIE_CHAN_BOND_EN             = "TRUE",       // PCIe channel bonding enable for Gen1/Gen2 only
    parameter PCIE_LANE                     = 1,            // PCIe number of lanes
    parameter PCIE_LINK_SPEED               = 1,            // PCIe link speed 
    parameter PCIE_REFCLK_FREQ              = 0,            // PCIe reference clock frequency
    parameter PCIE_USERCLK1_FREQ            = 2,            // PCIe user clock 1 frequency
    parameter PCIE_USERCLK2_FREQ            = 2,            // PCIe user clock 2 frequency
    parameter PCIE_TX_EIDLE_ASSERT_DELAY    = 3'd2,         // PCIe TX electrical idle assert delay
    parameter PCIE_RXEQ_MODE_GEN3           = 1,            // PCIe RX equalization mode
    parameter PCIE_OOBCLK_MODE              = 1,            // PCIe OOB clock mode
    parameter PCIE_JTAG_MODE                = 0,            // PCIe JTAG mode
    parameter PCIE_DEBUG_MODE               = 0             // PCIe debug mode 
) (                                                           // Gen1/Gen2  | Gen3 
                                                            //--------------------------------------
    //---------- PIPE Clock & Reset Ports ------------------
    input                           PIPE_CLK,               // Reference clock that drives MMCM
    input                           PIPE_RESET_N,           // PCLK       | PCLK
   
    output                          PIPE_PCLK,              // Drives [TX/RX]USRCLK in Gen1/Gen2
                                                            // Drives TXUSRCLK in Gen3
                                                            // Drives RXUSRCLK in Gen3 async mode only
    //---------- PIPE TX Data Ports ------------------------
    input       [31:0]PIPE_TXDATA,            // PCLK       | PCLK
    input       [3:0] PIPE_TXDATAK,           // PCLK       | PCLK
    
    output      [0:0]     PIPE_TXP,               // Serial data
    output      [0:0]     PIPE_TXN,               // Serial data

    //---------- PIPE RX Data Ports ------------------------
    input       [0:0]     PIPE_RXP,               // Serial data
    input       [0:0]     PIPE_RXN,               // Serial data
    
    output      [31:0]PIPE_RXDATA,            // PCLK       | RXUSRCLK
    output      [3:0] PIPE_RXDATAK,           // PCLK       | RXUSRCLK
    
    //---------- PIPE Command Ports ------------------------
    input                           PIPE_TXDETECTRX,        // PCLK       | PCLK
    input       [0:0]     PIPE_TXELECIDLE,        // PCLK       | PCLK
    input       [0:0]     PIPE_TXCOMPLIANCE,      // PCLK       | PCLK   
    input       [0:0]     PIPE_RXPOLARITY,        // PCLK       | RXUSRCLK
    input       [1:0] PIPE_POWERDOWN,         // PCLK       | PCLK
    input       [1:0]              PIPE_RATE,              // PCLK       | PCLK
    
    //---------- PIPE Electrical Command Ports -------------   
    input       [2:0]              PIPE_TXMARGIN,          // Async      | Async 
    input                           PIPE_TXSWING,           // Async      | Async 
    input       [0:0]     PIPE_TXDEEMPH,          // Async/PCLK | Async/PCLK  
    
    //---------- PIPE Status Ports -------------------------
    output      [PCIE_LANE-1:0]     PIPE_RXVALID,           // PCLK       | RXUSRCLK
    output      [PCIE_LANE-1:0]     PIPE_PHYSTATUS,         // PCLK       | RXUSRCLK
    output      [PCIE_LANE-1:0]     PIPE_PHYSTATUS_RST,     // PCLK       | RXUSRCLK
    output      [PCIE_LANE-1:0]     PIPE_RXELECIDLE,        // Async      | Async
    output      [PCIE_LANE-1:0]     PIPE_EYESCANDATAERROR,  // Async      | Async
    output      [(PCIE_LANE*3)-1:0] PIPE_RXSTATUS,          // PCLK       | RXUSRCLK
    
    //---------- PIPE User Ports ---------------------------
    input                           PIPE_MMCM_RST_N,        // Async      | Async
    
    output                          PIPE_PCLK_LOCK,         // Async      | Async
                                                            // Equivalent to PCLK in Gen1/Gen2
                                                            // Equivalent to RXOUTCLK[0] in Gen3
    output      [PCIE_LANE-1:0]     PIPE_RXCHANISALIGNED,

    //---------- External Clock Ports ----------------------
    input                           PIPE_PCLK_IN,           // PCLK       | PCLK
    input                           PIPE_RXUSRCLK_IN,       // RXUSERCLK
                                                            // Equivalent to PCLK in Gen1/Gen2
                                                            // Equivalent to RXOUTCLK[0] in Gen3
    input                           PIPE_DCLK_IN,           // DCLK       | DCLK
    input                           PIPE_OOBCLK_IN,         // OOB        | OOB
    input                           PIPE_MMCM_LOCK_IN,      // Async      | Async
    
    output                          PIPE_TXOUTCLK_OUT,      // PCLK       | PCLK
    output                          [4:0]gt_reset_fsm
);

    //---------- PIPE Reset Module Output ------------------
    reg                             rst_cpllreset;
    wire                            rst_rxusrclk_reset;
    wire                            rst_dclk_reset;   
    reg rst_gtreset;
    reg                            rst_drp_start;
    reg                            rst_drp_x16;
    reg rst_userrdy;
    wire                            rst_txsync_start;
    wire                            rst_idle;
    
    //---------- PIPE Sync Module Output -------------------
    wire        [PCIE_LANE-1:0]     sync_txphalign;    
    wire        [PCIE_LANE-1:0]     sync_txphinit;   
    wire        [PCIE_LANE-1:0]     sync_txdlysreset;   
    wire        [PCIE_LANE-1:0]     sync_txdlyen;      
    wire        [PCIE_LANE-1:0]     sync_txsync_done;
    
    //---------- PIPE DRP Module Output --------------------
    wire        [PCIE_LANE-1:0]     drp_en;
    wire        [(PCIE_LANE*16)-1:0]drp_di;   
    wire        [PCIE_LANE-1:0]     drp_we;
    wire        [PCIE_LANE-1:0]     drp_done;
    //wire        [(PCIE_LANE*3)-1:0] drp_fsm;

    //---------- QPLL Wrapper Output -----------------------
    wire        [(PCIE_LANE-1)>>2:0]              qpll_qplloutclk;
    wire        [(PCIE_LANE-1)>>2:0]              qpll_qplloutrefclk;
    wire        [(PCIE_LANE-1)>>2:0]              qpll_qplllock;
    wire        [((((PCIE_LANE-1)>>2)+1)*16)-1:0] qpll_do;
    wire        [(PCIE_LANE-1)>>2:0]              qpll_rdy;

    //---------- GTX Wrapper Output ------------------------
    wire             gt_txresetdone;
    wire             gt_rxresetdone;
    wire        [PCIE_LANE-1:0]     gt_rxvalid;
    wire        [PCIE_LANE-1:0]     gt_phystatus;
    wire        [PCIE_LANE-1:0]     gt_txratedone;
    wire        [PCIE_LANE-1:0]     gt_rxratedone;
    wire        [(PCIE_LANE*16)-1:0]drp_do;
    wire        [PCIE_LANE-1:0]     drp_rdy;
    wire        [PCIE_LANE-1:0]     gt_txsyncout;           // GTH  
    wire        [PCIE_LANE-1:0]     gt_txsyncdone;          // GTH                                                           
    wire        [PCIE_LANE-1:0]     gt_rxsyncout;           // GTH     
    wire        [(PCIE_LANE*4)-1:0] gt_rxchariscomma;                      
    wire        [PCIE_LANE-1:0]     gt_rxbyteisaligned;                   
    wire        [PCIE_LANE-1:0]     gt_rxbyterealign; 

    localparam                          i=0;                      // Index for per-lane signals

    (* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *) reg reset_n_reg1;
    (* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *) reg reset_n_reg2;
    always @ (posedge PIPE_PCLK_IN or negedge PIPE_RESET_N) begin
        if (!PIPE_RESET_N) begin
            reset_n_reg1 <= 1'd0;
            reset_n_reg2 <= 1'd0;
        end else begin
            reset_n_reg1 <= 1'd1;
            reset_n_reg2 <= reset_n_reg1;
        end   
    end  

    assign PIPE_PCLK         = PIPE_PCLK_IN;
    assign PIPE_PCLK_LOCK    = PIPE_MMCM_LOCK_IN; 

    // the reset FSM, to "patch some silicon problem"
    localparam FSM_IDLE             = 5'h0; 
    localparam FSM_CFG_WAIT         = 5'h1;
    localparam FSM_PLLRESET         = 5'h2; 
    localparam FSM_DRP_X16_START    = 5'h3;
    localparam FSM_DRP_X16_DONE     = 5'h4;   
    localparam FSM_PLLLOCK          = 5'h5;
    localparam FSM_GTRESET          = 5'h6;
    localparam FSM_RXPMARESETDONE_1 = 5'h7; 
    localparam FSM_RXPMARESETDONE_2 = 5'h8; 
    localparam FSM_DRP_X20_START    = 5'h9;
    localparam FSM_DRP_X20_DONE     = 5'hA;                    
    localparam FSM_MMCM_LOCK        = 5'hB;  
    localparam FSM_RESETDONE        = 5'hC;  
    localparam FSM_TXSYNC_START     = 5'hD;
    localparam FSM_TXPHINITDONE     = 5'hE;
    localparam FSM_TXSYNC_DONE1     = 5'hF;
    localparam FSM_TXSYNC_DONE      = 5'h10;
    reg [4:0] fsm =  FSM_CFG_WAIT;
    assign gt_reset_fsm = fsm;
    // order common signals to check and compare with simulation when debugging GTP
	//assign gt_reset_fsm = {2'b0, PIPE_TXELECIDLE, PIPE_RXELECIDLE};
	//assign gt_reset_fsm = {PIPE_POWERDOWN, rxdet, rxdet};
    //assign gt_reset_fsm = {rxd[2:0], !gt_rxelecidle};
    reg rxdet = 0;
    //always @ (posedge PIPE_PCLK_IN) begin
        //if (PIPE_TXDETECTRX & PIPE_RXSTATUS==3'd3 & PIPE_PHYSTATUS) rxdet <= 1;
    //end
    //wire pipe_txo;
    //BUFG bufg1 (.I (PIPE_TXOUTCLK_OUT), .O (pipe_txo));
    //reg rx_was_not_idle = 0;
    //reg gt_rxelecidle = 1;
    //reg gt_rxphaligndone_r = 0;
    //reg gt_rxbyteisaligned_r = 0;
    //reg [15:0]rxd = 0;
    //always @ (posedge PIPE_PCLK_IN) begin
        //if (!PIPE_RXELECIDLE) begin
            //rx_was_not_idle <= 1;
        //end
        //gt_rxelecidle <= PIPE_RXELECIDLE;
        //gt_rxphaligndone_r <= gt_rxphaligndone;
        //gt_rxbyteisaligned_r <= gt_rxbyteisaligned[0];
        //rxd <= PIPE_RXDATA[15:0];
    //end

    wire [PCIE_LANE-1:0]     drp_done_reg2;
    wire [PCIE_LANE-1:0]     rxpmaresetdone_reg2;
    wire                     plllock_reg2;
    wire                     mmcm_lock_reg2;
    wire [PCIE_LANE-1:0]     resetdone_reg2;
    wire [PCIE_LANE-1:0]     phystatus_reg2;
        
    two_beats #(.BEATS(2), .RSTVAL(0)) drp_done_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(drp_done), .out(drp_done_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) rxpmaresetdone_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(PIPE_RXPMARESETDONE), .out(rxpmaresetdone_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) plllock_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(&qpll_qplllock), .out(plllock_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) mmcm_lock_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(PIPE_MMCM_LOCK_IN), .out(mmcm_lock_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) resetdone_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(gt_txresetdone_reg && gt_rxresetdone_reg), .out(resetdone_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) phystatus_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(gt_phystatus), .out(phystatus_reg2));

    wire PIPE_TXDLYSRESETDONE;
    wire PIPE_TXPHINITDONE;
    wire PIPE_TXPHALIGNDONE;
    wire txdlysresetdone_reg2;
    wire txphinitdone_reg2;
    wire txphaligndone_reg2;
    reg txdlysresetdone_reg3;
    reg txphinitdone_reg3;
    reg txphaligndone_reg3;
    two_beats #(.BEATS(2), .RSTVAL(0)) txdlysresetdone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(PIPE_TXDLYSRESETDONE), .out(txdlysresetdone_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) txphinitdone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(PIPE_TXPHINITDONE), .out(txphinitdone_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) txphaligndone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(PIPE_TXPHALIGNDONE), .out(txphaligndone_reg2));
    always @ (posedge PIPE_PCLK_IN) begin
        txdlysresetdone_reg3 <= txdlysresetdone_reg2;
        txphinitdone_reg3 <= txphinitdone_reg2;
        txphaligndone_reg3 <= txphaligndone_reg2;
    end

    wire pipe_rate_reg2;
    reg pipe_rate_reg3;
    wire gt_txratedone_reg3;
    wire gt_rxratedone_reg3;
    wire gt_txsyncdone_reg3;
    two_beats #(.BEATS(3), .RSTVAL(0)) rate_beats (.clk(PIPE_PCLK_IN), .rst(0), .sig(PIPE_RATE[0]), .out(pipe_rate_reg2));
    two_beats #(.BEATS(3), .RSTVAL(0)) txratedone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(gt_txratedone[0]), .out(gt_txratedone_reg3));
    two_beats #(.BEATS(3), .RSTVAL(0)) rxratedone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(gt_rxratedone[0]), .out(gt_rxratedone_reg3));
    two_beats #(.BEATS(3), .RSTVAL(0)) txsyncdone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(gt_txsyncdone[0]), .out(gt_txsyncdone_reg3));

    reg txratedone_latch = 1'b0;
    reg rxratedone_latch = 1'b0;
    reg phystatus_latch = 1'b0;
    reg [1:0]rate_txsync = 2'b0;
    reg rate_done = 1'b0;
    reg rate_idle = 1'b1;
    //localparam RATE_IDLE = 0;
    //localparam RATE_ = 0;
    always @ (posedge PIPE_PCLK_IN) begin
        pipe_rate_reg3 <= pipe_rate_reg2;
        if (pipe_rate_reg2 & !pipe_rate_reg3) begin
            txratedone_latch <= 1'b0;
            rxratedone_latch <= 1'b0;
            phystatus_latch <= 1'b0;
            rate_txsync <= 2'b0;
            rate_done <= 1'b0;
            rate_idle <= 1'b0;
        end else begin
            if (gt_txratedone_reg3) txratedone_latch <= 1'b1;
            if (gt_rxratedone_reg3) rxratedone_latch <= 1'b1;
            if (phystatus_reg2) phystatus_latch <= 1'b1;
            if (txratedone_latch & rxratedone_latch & phystatus_latch) begin
                txratedone_latch <= 1'b0;
                rxratedone_latch <= 1'b0;
                phystatus_latch <= 1'b0;
                rate_txsync <= 2'b01;
            end else if (rate_txsync == 2'b01) begin
                rate_txsync <= 2'b10;
            end else if (rate_txsync == 2'b10) begin
                if (fsm == FSM_IDLE) begin
                    rate_txsync <= 2'b11;
                end
            end else if (rate_txsync == 2'b11) begin
                rate_txsync <= 2'b00;
                rate_done <= 1'b1;
            end else if (rate_done) begin
                rate_idle <= 1'b1;
                rate_done <= 1'b0;
            end
            //if (ratedone)
        end
    end

    reg [5:0] cfg_wait_cnt =  6'd0;
    reg txdlyen = 1'd0;

    always @ (posedge PIPE_PCLK_IN) begin
        if (!reset_n_reg2) begin
            fsm      <= FSM_CFG_WAIT;
            rst_cpllreset <= 1'd0;
            rst_gtreset  <= 1'd0;
            rst_userrdy  <= 1'd0;
            cfg_wait_cnt <= 6'd0;
            txdlyen <= 1'd0;
        end else begin
            case (fsm)
            FSM_CFG_WAIT : begin
                cfg_wait_cnt <= cfg_wait_cnt + 1;
                if (cfg_wait_cnt == 6'd63) fsm <= FSM_PLLRESET;
            end 
            //---------- Hold PLL and GTP Channel in Reset ----
            FSM_PLLRESET : begin
                rst_cpllreset  <= 1'd1;
                rst_gtreset   <= 1'd1;
                if (
                    //(~plllock_reg2) && // TODO: skipped, don't manually reset GTPE2_COMMON for openXC7
                    (&(~resetdone_reg2))) fsm <= FSM_DRP_X16_START;
            end  
            //---------- Start DRP x16 -------------------------
            FSM_DRP_X16_START : begin
                //if (&(~drp_done_reg2))
                    fsm <= FSM_DRP_X16_DONE;
            end
            //---------- Wait for DRP x16 Done -----------------    
            FSM_DRP_X16_DONE : begin  
                //if (&drp_done_reg2)
                    fsm <= FSM_PLLLOCK;
            end  
            //---------- Wait for PLL Lock --------------------
            FSM_PLLLOCK : begin
                //if (plllock_reg2) // TODO: skipped, don't manually reset GTPE2_COMMON for openXC7
                    fsm <= FSM_GTRESET;
                rst_cpllreset  <= 1'd0;
            end
            //---------- Release GTRESET -----------------------
            FSM_GTRESET : begin
                fsm       <= FSM_RXPMARESETDONE_1;
                rst_gtreset   <= 1'b0;
            end
            //---------- Wait for RXPMARESETDONE Assertion -----  
            FSM_RXPMARESETDONE_1 : begin
                if (&rxpmaresetdone_reg2 || (PCIE_SIM_SPEEDUP == "TRUE")) fsm <= FSM_RXPMARESETDONE_2;
            end  
            //---------- Wait for RXPMARESETDONE De-assertion --
            FSM_RXPMARESETDONE_2 : begin
                if (&(~rxpmaresetdone_reg2) || (PCIE_SIM_SPEEDUP == "TRUE")) fsm <= FSM_DRP_X20_START;
            end  
            //---------- Start DRP x20 -------------------------
            FSM_DRP_X20_START : begin
                //if (&(~drp_done_reg2))
                    fsm <= FSM_DRP_X20_DONE;
            end
            //---------- Wait for DRP x20 Done -----------------    
            FSM_DRP_X20_DONE : begin
                //if (&drp_done_reg2)
                    fsm <= FSM_MMCM_LOCK;
            end
            //---------- Wait for MMCM and RX CDR Lock ---------
            FSM_MMCM_LOCK : begin  
                if (mmcm_lock_reg2) begin
                    fsm       <= FSM_RESETDONE;
                    rst_userrdy   <= 1'd1;
                end
            end
            //---------- Wait for [TX/RX]RESETDONE and PHYSTATUS 
            FSM_RESETDONE : begin
                if (&resetdone_reg2 && (&(~phystatus_reg2))) fsm <= FSM_TXSYNC_START;  
            end
            //---------- Start TX Sync -------------------------
            FSM_TXSYNC_START : begin
                cfg_wait_cnt <= cfg_wait_cnt + 1;
                if ( (!txdlysresetdone_reg3 && txdlysresetdone_reg2)
                        //|| cfg_wait_cnt == 6'd63 // SKIP
                        ) fsm <= FSM_TXPHINITDONE;
            end
            FSM_TXPHINITDONE: begin
                cfg_wait_cnt <= cfg_wait_cnt + 1;
                if ( (!txphinitdone_reg3 && txphinitdone_reg2)
                        //|| cfg_wait_cnt == 6'd63 // SKIP
                        ) fsm <= FSM_TXSYNC_DONE1;
            end
            FSM_TXSYNC_DONE1: begin
                cfg_wait_cnt <= cfg_wait_cnt + 1;
                if ((!txphaligndone_reg3 && txphaligndone_reg2)
                        //|| cfg_wait_cnt == 6'd63 // SKIP
                        ) fsm <=  FSM_TXSYNC_DONE;
            end
            //---------- Wait for TX Sync Done -----------------
            //       _         ________
            // _____||________|         expected TXPHALIGNONE shape, as in simulation
            FSM_TXSYNC_DONE : begin
                cfg_wait_cnt <= cfg_wait_cnt + 1;
                if (( !txphaligndone_reg3 && txphaligndone_reg2 )
                        //|| 1 // SKIP
                        //|| cfg_wait_cnt == 6'd63 // SKIP
                        ) begin
                    fsm <= FSM_IDLE;
                    txdlyen <= 1;
                end else begin
                    txdlyen <= 1;
                end
            end     
            FSM_IDLE : begin
                // we use the latter half of FSM also for rate change
                if (rate_txsync == 2'b01) begin
                    fsm <= FSM_TXSYNC_START;
                    txdlyen <= 0;
                end
            end
            endcase
        end
    end

	two_beats #(.BEATS(3), .RSTVAL(0)) dclk_rst_beats (.clk(PIPE_PCLK_IN), .rst(0), .sig(fsm == FSM_CFG_WAIT), .out(rst_dclk_reset));
	wire rxusrclk_rst_reg;
	two_beats #(.BEATS(2), .RSTVAL(0)) drxusrclk_rst_beats (.clk(PIPE_RXUSRCLK_IN), .rst(0), .sig(rst_cpllreset), .out(rst_rxusrclk_reset));
	assign rst_txsync_start = fsm == FSM_TXSYNC_START;
	assign rst_idle = fsm == FSM_IDLE || PIPE_RATE[0]; // TODO: finer judgement
	always @ (posedge PIPE_PCLK_IN) begin
		rst_drp_start <= fsm == FSM_DRP_X16_START || fsm == FSM_DRP_X20_START;
		rst_drp_x16 <= fsm == FSM_DRP_X16_START || fsm == FSM_DRP_X16_DONE;
	end
	// sync signals to GTP
    assign sync_txdlysreset[0]      = (fsm == FSM_TXSYNC_START);
    assign sync_txphinit[0]         = (fsm == FSM_TXPHINITDONE); 
    assign sync_txphalign[0]        = (fsm == FSM_TXSYNC_DONE1);
    // in case of temporary debug, disable TX sync and use cfg_wait_cnt to skip FSM
    //assign sync_txdlysreset[0] = 0;
    //assign sync_txphinit[0] = 0;
    //assign sync_txphalign[0] = 0;
	assign sync_txdlyen[0] = txdlyen;
        
	// TODO: check on real hw
	wire gt_txresetdone_reg;
	wire gt_rxresetdone_reg;
	wire rst_idle_reg;
	two_beats #(.BEATS(2), .RSTVAL(0)) gt_txresetdone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(gt_txresetdone), .out(gt_txresetdone_reg));
	two_beats #(.BEATS(2), .RSTVAL(0)) gt_rxresetdone_beats (.clk(PIPE_PCLK_IN), .rst(rst_cpllreset), .sig(gt_rxresetdone), .out(gt_rxresetdone_reg));
	two_beats #(.BEATS(2), .RSTVAL(0)) pipe_rxusrclk_in_beats (.clk(PIPE_RXUSRCLK_IN), .rst(rst_rxusrclk_reset), .sig(rst_idle), .out(rst_idle_reg));
	reg [4:0]rxvalid_cnt = 5'h0;
	always @(posedge PIPE_RXUSRCLK_IN) begin
		if (gt_rxvalid[0] && !rst_rxusrclk_reset)
			rxvalid_cnt <= rxvalid_cnt[4] ? 5'h10 : rxvalid_cnt + 4'h1;
		else
			rxvalid_cnt <= 0;
	end
	// rst_idle: 2 beats at USER_RXUSRCLK, and 0 when !user_rxusrclk_rst_n
	assign PIPE_RXVALID[0] = rst_idle_reg && rxvalid_cnt[4]; // removed & rxvalid[0]
	assign PIPE_PHYSTATUS[0] = !rst_idle_reg || (rate_idle && gt_phystatus[0]) || rate_done;
	assign PIPE_PHYSTATUS_RST[0] = !rst_idle_reg;
    
	reg user_oobclk = 0;
	always @(posedge PIPE_OOBCLK_IN) begin user_oobclk <= ~user_oobclk; end
    
	//gtp_pipe_drp gtp_pipe_drp_inst (
		//.DRP_CLK                        (PIPE_DCLK_IN),
		//.DRP_RST_N                      (!rst_dclk_reset),
		//.DRP_X16                        (rst_drp_x16),
		//.DRP_START                      (rst_drp_start),                      
		//.DRP_DO                         (drp_do[15:0]),
		//.DRP_RDY                        (drp_rdy[0]),

		////.DRP_ADDR                       (drp_addr[8:0]),
		//.DRP_EN                         (drp_en[0]),  
		//.DRP_DI                         (drp_di[15:0]),   
		//.DRP_WE                         (drp_we[0]),
		//.DRP_DONE                       (drp_done[0])
		////.DRP_FSM                        (drp_fsm[2:0])
	//);

	// CPLL powerdown and reset
    //(* equivalent_register_removal="no" *) 
    //reg [95:0] cpllpd_wait = 96'hFFFFFFFFFFFFFFFFFFFFFFFF;             
    //(* equivalent_register_removal="no" *) 
    //reg [127:0] cpllreset_wait = 128'h000000000000000000000000000000FF;
	//Reference Clock for CPLLPD Fix
    //wire gt_cpllpdrefclk;
    //BUFG cpllpd_refclk_inst (.I (PIPE_CLK), .O (gt_cpllpdrefclk));
	//always @(posedge PIPE_CLK) begin
    //TODO: drive this with other clock to be compatible with nextpnr
    //reg [11:0]cpllreset_wait_cnt = 384;
    //reg [11:0]cpllpd_wait_cnt = 512;
    //wire cpllreset = cpllreset_wait_cnt != 0;
    //wire cpllpd = cpllpd_wait_cnt <= 8;
	//always @(posedge PIPE_PCLK_IN) begin
        //if (cpllreset_wait_cnt != 0) cpllreset_wait_cnt <= cpllreset_wait_cnt - 1;
        //if (cpllpd_wait_cnt != 0) cpllpd_wait_cnt <= cpllpd_wait_cnt - 1;
        //cpllpd_wait <= {cpllpd_wait[94:0], 1'b0};
        //cpllreset_wait <= {cpllreset_wait[126:0], 1'b0};
    //end
    // about GTPE2 COMMON/CHANNEL parameters: default parameter may be
    // different in Vivado and OpenXC7, so specifying every possible one in
    // the design instead. 
    GTPE2_COMMON # (
        //Simulation Attributes
        .SIM_PLL0REFCLK_SEL             (3'b001),
        .SIM_PLL1REFCLK_SEL             (3'b001),
        .SIM_RESET_SPEEDUP              (PCIE_SIM_MODE),
        .SIM_VERSION                    (PCIE_USE_MODE),
        //Clock Attributes 
        .PLL0_CFG                       (27'h01F024C),
        .PLL1_CFG                       (27'h01F024C),
        .PLL_CLKOUT_CFG                 (8'd0),
        .PLL0_DMON_CFG                  (1'b0),
        .PLL1_DMON_CFG                  (1'b0),
        .PLL0_FBDIV                     (3'd5), // 100 MHz refclk
        .PLL1_FBDIV                     (3'd5),
        .PLL0_FBDIV_45                  (5),
        .PLL1_FBDIV_45                  (5),
        .PLL0_INIT_CFG                  (24'h00001E),
        .PLL1_INIT_CFG                  (24'h00001E),
        .PLL0_LOCK_CFG                  ( 9'h1E8),
        .PLL1_LOCK_CFG                  ( 9'h1E8),
        .PLL0_REFCLK_DIV                (1),
        .PLL1_REFCLK_DIV                (1),
        //MISC 
        .BIAS_CFG                       (64'h0000000000050001),
        .COMMON_CFG                     (32'd0),
        .RSVD_ATTR0                     (16'd0),
        .RSVD_ATTR1                     (16'd0)
    ) gtpe2_common_i (
        //Clock 
        //.GTGREFCLK0                     ( 1'd0),
        //.GTGREFCLK1                     ( 1'd0),
        .GTREFCLK0                      (PIPE_CLK),
        //.GTREFCLK1                      ( 1'd0),
        //.GTEASTREFCLK0                  ( 1'd0),
        //.GTEASTREFCLK1                  ( 1'd0),
        //.GTWESTREFCLK0                  ( 1'd0),
        //.GTWESTREFCLK1                  ( 1'd0),
        .PLL0LOCKDETCLK                 (1'd0),
        .PLL1LOCKDETCLK                 (1'd0),
        .PLL0LOCKEN                     ( 1'd1),
        .PLL1LOCKEN                     ( 1'd1),
        .PLL0REFCLKSEL                  ( 3'd1),
        .PLL1REFCLKSEL                  ( 3'd1),
        .PLLRSVD1                       (16'd0),
        .PLLRSVD2                       ( 5'd0),
        
        .PLL0OUTCLK                     (qpll_qplloutclk[0]),
        .PLL1OUTCLK                     (qpll_qplloutclk1),
        .PLL0OUTREFCLK                  (qpll_qplloutrefclk[0]),
        .PLL1OUTREFCLK                  (qpll_qplloutrefclk1),
        .PLL0LOCK                       (qpll_qplllock[0]),
        .PLL1LOCK                       (),
        .PLL0FBCLKLOST                  (),
        .PLL1FBCLKLOST                  (),
        .PLL0REFCLKLOST                 (),
        .PLL1REFCLKLOST                 (),
        .DMONITOROUT                    (),
        //Reset 
        // TODO PLL0PD and PLL0RESET cause routing problem with openXC7
        //.PLL0PD                         (cpllpd),
        .PLL0PD                         (0),
        .PLL1PD                         (0),
        //.PLL0RESET                      (cpllreset | rst_cpllreset),
        .PLL0RESET                      (0),
        .PLL1RESET                      (0),
        //DRP -> TODO This DRP is causing no wire found for port on CHANNEL with openXC7
        .DRPCLK                         (0),
        .DRPADDR                        (0),
        .DRPEN                          (0),
        .DRPDI                          (0),
        .DRPWE                          (0),
        .DRPDO                          (), 
        .DRPRDY                         (),
        //Band Gap
        .BGBYPASSB                      ( 1'd1), 
        .BGMONITORENB                   ( 1'd1), 
        .BGPDB                          ( 1'd1), 
        .BGRCALOVRD                     ( 5'd31),
        .BGRCALOVRDENB                  ( 1'd1),
        //MISC 
        .PMARSVD                        ( 8'd0),
        .RCALENB                        ( 1'd1),
                                                
        .REFCLKOUTMONITOR0              (refclkoutmon0),
        .REFCLKOUTMONITOR1              (),
        .PMARSVDOUT                     ()
    );
    GTPE2_CHANNEL # (
        //Simulation Attributes 
        .SIM_RESET_SPEEDUP              (PCIE_SIM_SPEEDUP),
        .SIM_RECEIVER_DETECT_PASS       ("TRUE"),
        .SIM_TX_EIDLE_DRIVE_LEVEL       (PCIE_SIM_TX_EIDLE_DRIVE_LEVEL),
        .SIM_VERSION                    (PCIE_USE_MODE),
        //Clock Attributes 
        .TXOUT_DIV                      (2),
        .RXOUT_DIV                      (2),
        .TX_CLK25_DIV                   (4),
        .RX_CLK25_DIV                   (4),
        .TX_CLKMUX_EN                   ( 1'b1),   // GTP rename
        .RX_CLKMUX_EN                   ( 1'b1),   // GTP rename
        .TX_XCLK_SEL                    ("TXUSR"), // TXOUT = use TX buffer, TXUSR = bypass TX buffer
        .RX_XCLK_SEL                    ("RXREC"), // RXREC = use RX buffer, RXUSR = bypass RX buffer
        .OUTREFCLK_SEL_INV              ( 2'b11),
        //Reset Attributes 
        .TXPCSRESET_TIME                ( 5'b00001),
        .RXPCSRESET_TIME                ( 5'b00001),
        .TXPMARESET_TIME                ( 5'b00011),
        .RXPMARESET_TIME                ( 5'b00011), // Optimized for sim
	    .RXISCANRESET_TIME              ( 5'b00001),
        //TX Data Attributes
        .TX_DATA_WIDTH                  (20),        // 2-byte external datawidth for Gen1/Gen2
        //RX Data Attributes
        .RX_DATA_WIDTH                  (20),        // 2-byte external datawidth for Gen1/Gen2
        //Command Attributes
        .TX_RXDETECT_CFG                (14'd100),
        .TX_RXDETECT_REF                ( 3'b011),   // should be 3'b000?????
        .RX_CM_SEL                      ( 2'd3),     // 0 = AVTT, 1 = GND, 2 = Float, 3 = Programmable
        .RX_CM_TRIM	                    ( 4'b1010),  // Select 800mV, Changed from 3 to 4-bits, optimized for IES
        .TX_EIDLE_ASSERT_DELAY          (PCIE_TX_EIDLE_ASSERT_DELAY),// Optimized for sim
        .TX_EIDLE_DEASSERT_DELAY        ( 3'b010),   // Optimized for sim
	    .PD_TRANS_TIME_FROM_P2          (12'h03C),
        .PD_TRANS_TIME_NONE_P2          ( 8'h09),
	    .PD_TRANS_TIME_TO_P2            ( 8'h64),
	    .TRANS_TIME_RATE                ( 8'h0E),
        //Electrical Command Attributes
        .TX_DRIVE_MODE                  ("PIPE"),      // Gen1/Gen2 = PIPE, Gen3 = PIPEGEN3
        .TX_DEEMPH0                     ( 5'b10100),   //  6.0 dB
        .TX_DEEMPH1                     ( 5'b01011),   //  3.5 dB
        .TX_MARGIN_FULL_0               ( 7'b1001111), // 1000 mV
        .TX_MARGIN_FULL_1               ( 7'b1001110), //  950 mV
        .TX_MARGIN_FULL_2               ( 7'b1001101), //  900 mV
        .TX_MARGIN_FULL_3               ( 7'b1001100), //  850 mV
        .TX_MARGIN_FULL_4               ( 7'b1000011), //  400 mV
        .TX_MARGIN_LOW_0                ( 7'b1000101), //  500 mV
        .TX_MARGIN_LOW_1                ( 7'b1000110), //  450 mV
        .TX_MARGIN_LOW_2                ( 7'b1000011), //  400 mV
        .TX_MARGIN_LOW_3                ( 7'b1000010), //  350 mV
        .TX_MARGIN_LOW_4                ( 7'b1000000), //  250 mV
        .TX_MAINCURSOR_SEL              ( 1'b0),
        .TX_PREDRIVER_MODE              ( 1'b0),       // GTP
        //Status Attributes
	    .RX_SIG_VALID_DLY               ( 10),         // CHECK
        //DRP Attributes
        //PCS Attributes
        .PCS_PCIE_EN                    ("TRUE"),     // PCIe
        .PCS_RSVD_ATTR                  (48'h0000_0000_0100), // [8] : 1 = OOB power-up 000..0011111b????
         //PMA Attributes
	    .CLK_COMMON_SWING               ( 1'b0),              // GTP new              
	    .PMA_RSV                        (32'h00000333),
        .PMA_RSV2                       (32'h00002040),       // Optimized for GES
	    .PMA_RSV3                       ( 2'd0),
	    .PMA_RSV4                       ( 4'd0),              // Changed from 15 to 4-bits
	    .PMA_RSV5                       ( 1'd0),              // Changed from 4 to 1-bit
	    .PMA_RSV6                       ( 1'd0),              // GTP new
	    .PMA_RSV7                       ( 1'd0),              // GTP new
        .RX_BIAS_CFG                    (16'h0F33),           // Optimized for IES
        .TERM_RCAL_CFG                  (15'b100001000010000),// Optimized for IES
        .TERM_RCAL_OVRD                 ( 3'b000),            // Optimized for IES 
         //TX PI
	    .TXPI_CFG0                      ( 2'd0),
        .TXPI_CFG1                      ( 2'd0),
        .TXPI_CFG2                      ( 2'd0),
        .TXPI_CFG3                      ( 1'd0),
        .TXPI_CFG4                      ( 1'd0),
        .TXPI_CFG5                      ( 3'd000),
        .TXPI_GREY_SEL                  ( 1'd0),
        .TXPI_INVSTROBE_SEL             ( 1'd0),
        .TXPI_PPMCLK_SEL                ("TXUSRCLK2"),
        .TXPI_PPM_CFG                   ( 8'd0),
        .TXPI_SYNFREQ_PPM               ( 3'd1), // TODO: this is set away from 0 for openxc7
                                                                                                                               
        //RX PI
        .RXPI_CFG0                      ( 3'd0),                                // Changed from 3 to 2-bits, Optimized for IES 
        .RXPI_CFG1                      ( 1'd1),                                // Changed from 2 to 1-bits, Optimized for IES
        .RXPI_CFG2                      ( 1'd1),                                // Changed from 2 to 1-bits, Optimized for IES
        //CDR Attributes
        .RXCDR_CFG                      (83'h0_0001_07FE_4060_0104_1010),       // Optimized for IES                       
        .RXCDR_LOCK_CFG                 ( 6'b010101),                           // [5:3] Window Refresh, [2:1] Window Size, [0] Enable Detection (sensitive lock = 6'b111001)  CHECK
        .RXCDR_HOLD_DURING_EIDLE        ( 1'd1),                                // Hold  RX CDR           on electrical idle for Gen1/Gen2
        .RXCDR_FR_RESET_ON_EIDLE        ( 1'd0),                                // Reset RX CDR frequency on electrical idle for Gen3
        .RXCDR_PH_RESET_ON_EIDLE        ( 1'd0),                                // Reset RX CDR phase     on electrical idle for Gen3
	    .RXCDRFREQRESET_TIME            ( 5'b00001),
	    .RXCDRPHRESET_TIME              ( 5'b00001),
        //LPM Attributes               
	    .RXLPMRESET_TIME                ( 7'b0001111),                          // GTP new
	    .RXLPM_BIAS_STARTUP_DISABLE     ( 1'b0),                                // GTP new
        .RXLPM_CFG                      ( 4'b0110),                             // GTP new, optimized for IES
	    .RXLPM_CFG1                     ( 1'b0),                                // GTP new
	    .RXLPM_CM_CFG                   ( 1'b0),                                // GTP new
        .RXLPM_GC_CFG                   ( 9'b111100010),                        // GTP new, optimized for IES
        .RXLPM_GC_CFG2                  ( 3'b001),                              // GTP new, optimized for IES
	    .RXLPM_HF_CFG                   (14'b00001111110000),
        .RXLPM_HF_CFG2                  ( 5'b01010),                            // GTP new
	    .RXLPM_HF_CFG3                  ( 4'b0000),                             // GTP new
        .RXLPM_HOLD_DURING_EIDLE        ( 1'b1),                                // GTP new
        .RXLPM_INCM_CFG                 ( 1'b1),                                // GTP new, optimized for IES
        .RXLPM_IPCM_CFG                 ( 1'b0),                                // GTP new, optimized for IES
	    .RXLPM_LF_CFG                   (18'b000000001111110000),
        .RXLPM_LF_CFG2                  ( 5'b01010),                            // GTP new, optimized for IES
        .RXLPM_OSINT_CFG                ( 3'b100),                              // GTP new, optimized for IES
        //OS Attributes 
        .RX_OS_CFG                      (13'h0080), // CHECK
        .RXOSCALRESET_TIME              (5'b00011), // Optimized for IES
        .RXOSCALRESET_TIMEOUT           (5'b00000), // Disable timeout, Optimized for IES     
        //Eye Scan Attributes 
        .ES_EYE_SCAN_EN                 ("FALSE"),
        //TX Buffer Attributes               
        .TXBUF_EN                       (PCIE_TXBUF_EN),
        .TXBUF_RESET_ON_RATE_CHANGE     ("TRUE"),
        //RX Buffer Attributes                
        .RXBUF_EN                       ("TRUE"),
	    .RX_BUFFER_CFG                  ( 6'd0),
        .RX_DEFER_RESET_BUF_EN          ("TRUE"),
        .RXBUF_ADDR_MODE                ("FULL"),
        .RXBUF_EIDLE_HI_CNT	            ( 4'd4),   // Optimized for sim
        .RXBUF_EIDLE_LO_CNT	            ( 4'd0),   // Optimized for sim
        .RXBUF_RESET_ON_CB_CHANGE       ("TRUE"),
        .RXBUF_RESET_ON_COMMAALIGN      ("FALSE"),
        .RXBUF_RESET_ON_EIDLE           ("TRUE"),  // PCIe
        .RXBUF_RESET_ON_RATE_CHANGE     ("TRUE"),
        .RXBUF_THRESH_OVRD              ("FALSE"),
        .RXBUF_THRESH_OVFLW             (61),
        .RXBUF_THRESH_UNDFLW            ( 4),
	    .RXBUFRESET_TIME                ( 5'b00001),
        //TX Sync Attributes                
        .TXPH_CFG                       (16'h0780),
        .TXPH_MONITOR_SEL               ( 5'd0),
        .TXPHDLY_CFG                    (24'h084020), // [19] : 1 = full range, 0 = half range
        .TXDLY_CFG                      (16'h001F),
        .TXDLY_LCFG	                    ( 9'h030),
        .TXDLY_TAP_CFG                  (16'd0),
                 
        .TXSYNC_OVRD                    (1),
        .TXSYNC_MULTILANE               (0),
        .TXSYNC_SKIP_DA                 (1'b0),
        //RX Sync Attributes            
        .RXPH_CFG                       (24'd0),
        .RXPH_MONITOR_SEL               ( 5'd0),
        .RXPHDLY_CFG                    (24'h004020), // [19] : 1 = full range, 0 = half range
        .RXDLY_CFG                      (16'h001F),
        .RXDLY_LCFG	                    ( 9'h030),
        .RXDLY_TAP_CFG                  (16'd0),
        .RX_DDI_SEL	                    ( 6'd0),
            
        .RXSYNC_OVRD                    (1),
        .RXSYNC_MULTILANE               (0),
        .RXSYNC_SKIP_DA                 (1'b0),
        //Comma Alignment Attributes            
        .ALIGN_COMMA_DOUBLE             ("FALSE"),
        .ALIGN_COMMA_ENABLE             (10'b1111111111),// PCIe
        .ALIGN_COMMA_WORD               ( 1),
        .ALIGN_MCOMMA_DET               ("TRUE"),
        .ALIGN_MCOMMA_VALUE             (10'b1010000011),
        .ALIGN_PCOMMA_DET               ("TRUE"),
        .ALIGN_PCOMMA_VALUE             (10'b0101111100),
        .DEC_MCOMMA_DETECT              ("TRUE"),
        .DEC_PCOMMA_DETECT              ("TRUE"),
        .DEC_VALID_COMMA_ONLY           ("FALSE"),// PCIe
        .SHOW_REALIGN_COMMA             ("FALSE"),// PCIe
        .RXSLIDE_AUTO_WAIT              ( 7),
        .RXSLIDE_MODE                   ("PMA"),  // PCIe
        //Channel Bonding Attributes                
        .CHAN_BOND_KEEP_ALIGN           ("TRUE"),        // PCIe
        .CHAN_BOND_MAX_SKEW             ( 7),            // 
        .CHAN_BOND_SEQ_LEN              ( 4),            // PCIe
        .CHAN_BOND_SEQ_1_ENABLE         ( 4'b1111),      //
        .CHAN_BOND_SEQ_1_1              (10'b0001001010),// D10.2 (4A) - TS1 
        .CHAN_BOND_SEQ_1_2              (10'b0001001010),// D10.2 (4A) - TS1
        .CHAN_BOND_SEQ_1_3              (10'b0001001010),// D10.2 (4A) - TS1
        .CHAN_BOND_SEQ_1_4              (10'b0110111100),// K28.5 (BC) - COM
        .CHAN_BOND_SEQ_2_USE            ("TRUE"),        // PCIe
        .CHAN_BOND_SEQ_2_ENABLE         (4'b1111),       //
        .CHAN_BOND_SEQ_2_1              (10'b0001000101),// D5.2  (45) - TS2
        .CHAN_BOND_SEQ_2_2              (10'b0001000101),// D5.2  (45) - TS2
        .CHAN_BOND_SEQ_2_3              (10'b0001000101),// D5.2  (45) - TS2
        .CHAN_BOND_SEQ_2_4              (10'b0110111100),// K28.5 (BC) - COM
        .FTS_DESKEW_SEQ_ENABLE          ( 4'b1111),
        .FTS_LANE_DESKEW_EN             ("TRUE"),   // PCIe
        .FTS_LANE_DESKEW_CFG            ( 4'b1111),
        //Clock Correction Attributes 
        .CBCC_DATA_SOURCE_SEL           ("DECODED"),
        .CLK_CORRECT_USE                ("TRUE"),
        .CLK_COR_KEEP_IDLE              ("TRUE"),         // PCIe
        .CLK_COR_MAX_LAT                (15),             // decided by lanes
        .CLK_COR_MIN_LAT                (13),
        .CLK_COR_PRECEDENCE             ("TRUE"),
        .CLK_COR_REPEAT_WAIT            ( 0),
        .CLK_COR_SEQ_LEN                ( 1),
        .CLK_COR_SEQ_1_ENABLE           ( 4'b1111),
        .CLK_COR_SEQ_1_1                (10'b0100011100), // K28.0 (1C) - SKP
        .CLK_COR_SEQ_1_2                (10'b0000000000), // Disabled
        .CLK_COR_SEQ_1_3                (10'b0000000000), // Disabled
        .CLK_COR_SEQ_1_4                (10'b0000000000), // Disabled
        .CLK_COR_SEQ_2_ENABLE           ( 4'b0000),       // Disabled
        .CLK_COR_SEQ_2_USE              ("FALSE"),
        .CLK_COR_SEQ_2_1                (10'b0000000000), // Disabled
        .CLK_COR_SEQ_2_2                (10'b0000000000), // Disabled
        .CLK_COR_SEQ_2_3                (10'b0000000000), // Disabled
        .CLK_COR_SEQ_2_4                (10'b0000000000), // Disabled
        //8b10b Attributes 
        .RX_DISPERR_SEQ_MATCH           ("TRUE"),
        //64b/66b & 64b/67b Attributes 
        .GEARBOX_MODE                   ( 3'd0),
        .TXGEARBOX_EN                   ("FALSE"),
        .RXGEARBOX_EN                   ("FALSE"),
        //PRBS & Loopback Attributes 
        .LOOPBACK_CFG                    ( 1'd0),                               // Enable latch when bypassing TX buffer, equivalent to GTX PCS_RSVD_ATTR[0]      
        .RXPRBS_ERR_LOOPBACK             ( 1'd0),
        .TX_LOOPBACK_DRIVE_HIZ           ("FALSE"),
        //OOB & SATA Attributes 
        .TXOOB_CFG                      ( 1'd1),                                // Filter stale TX data when exiting TX electrical idle, equivalent to GTX PCS_RSVD_ATTR[7]
	    .RXOOB_CFG                      ( 7'b0000110),
        .RXOOB_CLK_CFG                  ("FABRIC"),
        //MISC 
        .DMONITOR_CFG                   (24'h000B01),
        .RX_DEBUG_CFG                   (14'h0000),                             // Optimized for IES
	    .TST_RSV                        (32'd0),
	    .UCODEER_CLR                    ( 1'd0),                                 // 
      
        //GTP 
	    .ACJTAG_DEBUG_MODE              (1'd0),
	    .ACJTAG_MODE                    (1'd0),
	    .ACJTAG_RESET                   (1'd0),
	    .ADAPT_CFG0                     (20'd0),
        .CFOK_CFG                       (43'h490_0004_0E80),                    // Changed from 42 to 43-bits, Optimized for IES
        .CFOK_CFG2                      ( 7'b010_0000),                         // Changed from 6 to 7-bits, Optimized for IES
        .CFOK_CFG3                      ( 7'b010_0000),                         // Changed from 6 to 7-bits, Optimized for IES
        .CFOK_CFG4                      ( 1'd0),                                // GTP new, Optimized for IES
        .CFOK_CFG5                      ( 2'd0),                                // GTP new, Optimized for IES
        .CFOK_CFG6                      ( 4'd0),                                 // GTP new, Optimized for IES
        .USE_PCS_CLK_PHASE_SEL      (1'd0),

        .SAS_MAX_COM                (7'd64),
        .SAS_MIN_COM                (6'd36),
        .SATA_BURST_SEQ_LEN         (3'd5),
        .SATA_BURST_VAL             (3'd4),
        .SATA_EIDLE_VAL             (3'd4),
        .SATA_MAX_BURST             (4'd8),
        .SATA_MAX_INIT              (5'd21),
        .SATA_MAX_WAKE              (3'd7),
        .SATA_MIN_BURST             (3'd4),
        .SATA_MIN_INIT              (4'd12),
        .SATA_MIN_WAKE              (3'd4),
        .SATA_PLL_CFG               ("VCO_3000MHZ"),

        .PMA_LOOPBACK_CFG           (1'd0),
        .ES_CLK_PHASE_SEL           (1'd0),
        .ES_CONTROL                 (1'd0),
        .ES_ERRDET_EN               ("FALSE"),
        .ES_HORZ_OFFSET             (1'd0),
        .ES_PMA_CFG                 (1'd0),
        .ES_PRESCALE                (1'd0),
        .ES_QUALIFIER               (1'd0),
        .ES_QUAL_MASK               (1'd0),
        .ES_SDATA_MASK              (1'd0),
        .ES_VERT_OFFSET             (1'd0)
     )gtpe2_channell_i(
		//Clock 
		.PLL0CLK                        (qpll_qplloutclk[0]),
		.PLL1CLK                        (qpll_qplloutclk1),
		.PLL0REFCLK                     (qpll_qplloutrefclk[0]),
		.PLL1REFCLK                     (qpll_qplloutrefclk1),
		.TXUSRCLK                       (PIPE_PCLK_IN),
		.RXUSRCLK                       (PIPE_RXUSRCLK_IN),
		.TXUSRCLK2                      (PIPE_PCLK_IN),
		.RXUSRCLK2                      (PIPE_RXUSRCLK_IN),
		.TXSYSCLKSEL                    (0),
		.RXSYSCLKSEL                    (0),
		.TXOUTCLKSEL                    (3'd3),
		.RXOUTCLKSEL                    (3'b0),
		.CLKRSVD0                       (1'd0),
		.CLKRSVD1                       (1'd0),
		
		.TXOUTCLK                       (PIPE_TXOUTCLK_OUT),
		.RXOUTCLK                       (),
		.TXOUTCLKFABRIC                 (),
		.RXOUTCLKFABRIC                 (),
		.TXOUTCLKPCS                    (),
		.RXOUTCLKPCS                    (),
		.RXCDRLOCK                      (),
		//Reset 
		.TXUSERRDY                      (rst_userrdy),
		.RXUSERRDY                      (rst_userrdy),
		.CFGRESET                       (1'd0),
		.GTRESETSEL                     (1'd0),
		.RESETOVRD                      (0),
		.GTTXRESET                      (rst_gtreset),
		.GTRXRESET                      (rst_gtreset),
																			   
		.TXRESETDONE                    (gt_txresetdone),
		.RXRESETDONE                    (gt_rxresetdone),
		//TX Data 
		.TXDATA                         (PIPE_TXDATA[31:0]),
		.TXCHARISK                      (PIPE_TXDATAK[3:0]),
		.GTPTXP                         (PIPE_TXP[0]),
		.GTPTXN                         (PIPE_TXN[0]),
		//RX Data 
		.GTPRXP                         (PIPE_RXP[0]),
		.GTPRXN                         (PIPE_RXN[0]),
		.RXDATA                         (PIPE_RXDATA[31:0]),
		.RXCHARISK                      (PIPE_RXDATAK[3:0]),
		//Command                
		.TXDETECTRX                     (PIPE_TXDETECTRX),
		.TXPDELECIDLEMODE               ( 1'd0),
		.RXELECIDLEMODE                 ( 2'd0),
		.TXELECIDLE                     (PIPE_TXELECIDLE[0]),
		.TXCHARDISPMODE                 ({3'd0, PIPE_TXCOMPLIANCE[0]}),// Changed from 8 to 4-bits
		.TXCHARDISPVAL                  ( 4'd0),                       // Changed from 8 to 4-bits
		.TXPOLARITY                     ( 1'b0),
		.RXPOLARITY                     (PIPE_RXPOLARITY[0]),
		.TXPD                           (PIPE_POWERDOWN[1:0]),
		.RXPD                           (PIPE_POWERDOWN[1:0]),
		.TXRATE                         (pipe_rate_reg3 ? 3'd1 : 3'd0),       // always zerofor Gen1, 1 for switching to Gen2
		.RXRATE                         (pipe_rate_reg3 ? 3'd1 : 3'd0),
		.TXRATEMODE                     (1'b0),
		.RXRATEMODE                     (1'b0),
		//Electrical Command                
		.TXMARGIN                       (PIPE_TXMARGIN),
		.TXSWING                        (PIPE_TXSWING),
		.TXDEEMPH                       (PIPE_TXDEEMPH[0]),
		.TXINHIBIT                      (0),
		.TXBUFDIFFCTRL                  (3'd4),
		.TXDIFFCTRL                     (4'b1100), // Select 850mV 
		.TXPRECURSOR                    (1'd0), // * if changed this, nextpnr will complain a lot
		.TXPRECURSORINV                 (1'd0),
		.TXMAINCURSOR                   (1'd0), // *
		.TXPOSTCURSOR                   (0),
		.TXPOSTCURSORINV                (1'd0),
		//Status                
		.RXVALID                        (gt_rxvalid[0]),
		.PHYSTATUS                      (gt_phystatus[0]),
		.RXELECIDLE                     (PIPE_RXELECIDLE),
		.RXSTATUS                       (PIPE_RXSTATUS),
		.TXRATEDONE                     (gt_txratedone[0]),
		.RXRATEDONE                     (gt_rxratedone[0]),
		//DRP TODO: openxc7 doesn't support this yet, but no problem
		//.DRPCLK                         (PIPE_DCLK_IN),
		//.DRPADDR                        (9'h011),
		//.DRPEN                          (0 & drp_en[0]),
		//.DRPDI                          (drp_di[15:0]),
		//.DRPWE                          (drp_we[0]),
																				
		//.DRPDO                          (drp_do[15:0]),
		//.DRPRDY                         (drp_rdy[0]),
		.DRPCLK                         (0),
		.DRPADDR                        (0),
		.DRPEN                          (0),
		.DRPDI                          (0),
		.DRPWE                          (),
																				
		.DRPDO                          (),
		.DRPRDY                         (),
		//PMA 
		.TXPMARESET                     (0),
		.RXPMARESET                     (0),
		.RXLPMRESET                     ( 1'd0), // GTP new  
		.RXLPMOSINTNTRLEN               ( 1'd0), // GTP new   
		.RXLPMHFHOLD                    ( 1'd0),
		.RXLPMHFOVRDEN                  ( 1'd0),
		.RXLPMLFHOLD                    ( 1'd0),
		.RXLPMLFOVRDEN                  ( 1'd0),
		.PMARSVDIN0                     ( 1'd0), // GTP new 
		.PMARSVDIN1                     ( 1'd0), // GTP new 
		.PMARSVDIN2                     ( 1'd0), // GTP new  
		.PMARSVDIN3                     ( 1'd0), // GTP new 
		.PMARSVDIN4                     ( 1'd0), // GTP new 
		.GTRSVD                         (16'd0),
			  
		.PMARSVDOUT0                    (), // GTP new
		.PMARSVDOUT1                    (), // GTP new                                                                       
		.DMONITOROUT                    (), // GTP 15-bits 
																			  
		//PCS 
		.TXPCSRESET                     (0),
		.RXPCSRESET                     (0),
		.PCSRSVDIN                      (16'd0), // [0]: 1 = TXRATE async, [1]: 1 = RXRATE async    
		
		.PCSRSVDOUT                     (),
		//CDR 
		.RXCDRRESET                     (0),
		.RXCDRRESETRSV                  (1'd0),
		.RXCDRFREQRESET                 (0),
		.RXCDRHOLD                      (1'b0),
		.RXCDROVRDEN                    (1'd0),
		//PI 
		.TXPIPPMEN                      (1'd0),
		.TXPIPPMOVRDEN                  (1'd0),
		.TXPIPPMPD                      (1'd0),
		.TXPIPPMSEL                     (1'd0),
		.TXPIPPMSTEPSIZE                (5'd0),
		.TXPISOPD                       (1'd0),                                 // GTP new
		//DFE 
		.RXDFEXYDEN                     (1'd0),
		//OS 
		.RXOSHOLD                       (1'd0),    // Optimized for IES
		.RXOSOVRDEN                     (1'd0),    // Optimized for IES                          
		.RXOSINTEN                      (1'd1),    // Optimized for IES           
		.RXOSINTHOLD                    (1'd0),    // Optimized for IES                                                                                                      
		.RXOSINTNTRLEN                  (1'd0),    // Optimized for IES           
		.RXOSINTOVRDEN                  (1'd0),    // Optimized for IES            
		.RXOSINTPD                      (1'd0),    // GTP new, Optimized for IES             
		.RXOSINTSTROBE                  (1'd0),    // Optimized for IES           
		.RXOSINTTESTOVRDEN              (1'd0),    // Optimized for IES           
		.RXOSINTCFG                     (4'b0010), // Optimized for IES                     
		.RXOSINTID0                     (4'd0),    // Optimized for IES
								  
		.RXOSINTDONE                    (),
		.RXOSINTSTARTED                 (),
		.RXOSINTSTROBEDONE              (),
		.RXOSINTSTROBESTARTED           (),
																				
		//Eye Scan                
		.EYESCANRESET                   (0),
		.EYESCANMODE                    (1'd0),
		.EYESCANTRIGGER                 (1'b0),
																				
		.EYESCANDATAERROR               (),
																				
		//TX Buffer                
		.TXBUFSTATUS                    (),
																				
		//RX Buffer                
		.RXBUFRESET                     (0),
		
		.RXBUFSTATUS                    (),
																				
		//TX Sync                
		.TXPHDLYRESET                   (0),
		.TXPHDLYTSTCLK                  (1'd0),
		.TXPHALIGN                      (sync_txphalign[0]),
		.TXPHALIGNEN                    (1),    //  enable!
		.TXPHDLYPD                      (1'd0),
		.TXPHINIT                       (sync_txphinit[0]),
		.TXPHOVRDEN                     (1'd0),
		.TXDLYBYPASS                    (0),
		.TXDLYSRESET                    (sync_txdlysreset[0]),
		.TXDLYEN                        (sync_txdlyen[0]),
		.TXDLYOVRDEN                    (1'd0),
		.TXDLYHOLD                      (1'd0),
		.TXDLYUPDOWN                    (1'd0),
																				
		.TXPHALIGNDONE                  (PIPE_TXPHALIGNDONE),
		.TXPHINITDONE                   (PIPE_TXPHINITDONE),
		.TXDLYSRESETDONE                (PIPE_TXDLYSRESETDONE),
		
        // don't care https://adaptivesupport.amd.com/s/article/56117
        // txsyncallin may cause error with openXC7
		//.TXSYNCMODE                     (1),
		//.TXSYNCIN                       (gt_txsyncout[0]),
		//.TXSYNCALLIN                    (&PIPE_TXPHALIGNDONE),
        .TXSYNCMODE                     (0),
        .TXSYNCIN                       (0),
        .TXSYNCALLIN                    (0),
		
		.TXSYNCDONE                     (gt_txsyncdone[0]),
		.TXSYNCOUT                      (gt_txsyncout[0]),
		
		//RX Sync 
		.RXPHDLYRESET                   (1'd0),
		.RXPHALIGN                      (),    
		.RXPHALIGNEN                    (0),   
		.RXPHDLYPD                      (1'd0),
		.RXPHOVRDEN                     (1'd0),
		.RXDLYBYPASS                    (1),
		.RXDLYSRESET                    (0),
		.RXDLYEN                        (0),
		.RXDLYOVRDEN                    (1'd0),
		.RXDDIEN                        (0),
																				
		.RXPHALIGNDONE                  (gt_rxphaligndone),
		.RXPHMONITOR                    (),
		.RXPHSLIPMONITOR                (),
		.RXDLYSRESETDONE                (),

		.RXSYNCMODE                     (),
		.RXSYNCIN                       (gt_rxsyncout[0]),
		.RXSYNCALLIN                    (0),
		
		.RXSYNCDONE                     (),
		.RXSYNCOUT                      (gt_rxsyncout[0]),
		//Comma Alignment 
		.RXCOMMADETEN                   (1'd1),
		.RXMCOMMAALIGNEN                (1'd1),
		.RXPCOMMAALIGNEN                (1'd1),
		.RXSLIDE                        (0),
		.RXCOMMADET                     (PIPE_RXCOMMADET),
		.RXCHARISCOMMA                  (gt_rxchariscomma[3:0]),
		.RXBYTEISALIGNED                (gt_rxbyteisaligned[0]),
		.RXBYTEREALIGN                  (gt_rxbyterealign[0]),
		//Channel Bonding 
		.RXCHBONDEN                     (0),
		.RXCHBONDI                      (0),
		.RXCHBONDLEVEL                  (0),
		.RXCHBONDMASTER                 (0),
		.RXCHBONDSLAVE                  (0),
		.RXCHANBONDSEQ                  (), 
		.RXCHANISALIGNED                (PIPE_RXCHANISALIGNED[0]),
		.RXCHANREALIGN                  (),
		.RXCHBONDO                      (),
		//Clock Correction  
		.RXCLKCORCNT                    (),
		//8b10b 
		.TX8B10BBYPASS                  (4'd0),
		.TX8B10BEN                      (1'b1),
		.RX8B10BEN                      (1'b1),
																				
		.RXDISPERR                      (),
		.RXNOTINTABLE                   (),
		//64b/66b & 64b/67b 
		.TXHEADER                       (3'd0),
		.TXSEQUENCE                     (7'd0),
		.TXSTARTSEQ                     (1'd0),
		.RXGEARBOXSLIP                  (1'd0),
		.TXGEARBOXREADY                 (),
		.RXDATAVALID                    (),
		.RXHEADER                       (),
		.RXHEADERVALID                  (),
		.RXSTARTOFSEQ                   (),
		//PRBS/Loopback 
		.TXPRBSSEL                      (0),
		.RXPRBSSEL                      (0),
		.TXPRBSFORCEERR                 (0),
		.RXPRBSCNTRESET                 (0),
		.LOOPBACK                       (0),
		.RXPRBSERR                      (), 
		//OOB 
		.SIGVALIDCLK                    (user_oobclk), // Optimized for debug           
		.TXCOMINIT                      (1'd0),
		.TXCOMSAS                       (1'd0),
		.TXCOMWAKE                      (1'd0),
		.RXOOBRESET                     (1'd0),
		.TXCOMFINISH                    (),
		.RXCOMINITDET                   (),
		.RXCOMSASDET                    (),
		.RXCOMWAKEDET                   (),
		//MISC 
		.SETERRSTATUS                   ( 1'd0),
		.TXDIFFPD                       ( 1'd0),
		.TSTIN                          (20'hFFFFF),
		//GTP 
		.RXADAPTSELTEST                 (14'd0),
		.DMONFIFORESET                  ( 1'd0),
		.DMONITORCLK                    (0),
		.RXOSCALRESET                   ( 1'd0),
		.RXPMARESETDONE                 (PIPE_RXPMARESETDONE),                    // GTP
		.TXPMARESETDONE                 ()
     );         
endmodule

module two_beats #(
	parameter BEATS = 2,
	parameter RSTVAL = 0,
	parameter WIDTH = 1
)(
	input clk,
	input rst,
	input [WIDTH-1:0]sig,
	output reg [WIDTH-1:0]out
);
	(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *) reg [WIDTH-1:0]r0;
	(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *) reg [WIDTH-1:0]r1;
	(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *) reg [WIDTH-1:0]r2;
	always @(posedge clk) begin
		r0 <= sig;
		r1 <= r0;
		r2 <= r1;
		if (rst) out <= RSTVAL;
		else out <= BEATS == 3 ? r2 : r1;
	end
endmodule
