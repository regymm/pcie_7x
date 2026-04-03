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
//  GTX main differences: PCIE_USE_MODE must be "3.0" for correct GTX init  during vivado simulation
//                        CPLL is used, no QPLL (GTXE2_COMMON) required!
//                        FSM skips some states? (no drp as usual...)
//                        PCS_RSVD_ATTR, etc. contains more bits that were stand-alone in GTP

`timescale 1ns / 1ps

module pipe_wrapper_gtx # (
    parameter PCIE_SIM_MODE                 = "TRUE",      // PCIe sim mode 
    parameter PCIE_SIM_SPEEDUP              = "TRUE",      // PCIe sim speedup
    parameter PCIE_SIM_TX_EIDLE_DRIVE_LEVEL = "1",          // PCIe sim TX electrical idle drive level 
    parameter PCIE_GT_DEVICE                = "GTX",        // PCIe GT device, unused actually
    parameter PCIE_USE_MODE                 = "3.0",        // PCIe use mode, 3.0 is necessary!
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

    //---------- GTX CPLL lock -----------------------
    wire             gt_cplllock;

    //---------- GTX Wrapper Output ------------------------
    wire             gt_txresetdone;
    wire             gt_rxresetdone;
    wire             gt_rxcdrlock;
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
    localparam CPLL_CFG = ((PCIE_USE_MODE == "1.0") || (PCIE_USE_MODE == "1.1"))
                          ? 24'hB407CC : 24'hA407CC;

    // clock mux power-down 
    localparam CLKMUX_PD = ((PCIE_USE_MODE == "1.0") || (PCIE_USE_MODE == "1.1"))
                           ? 1'd0 : 1'd1;

    localparam CPLL_REFCLK_DIV = 1;
    localparam CPLL_FBDIV_45   = 5;
    localparam CPLL_FBDIV      = (PCIE_REFCLK_FREQ == 2) ? 2 :
                                 (PCIE_REFCLK_FREQ == 1) ? 4 : 5;
    localparam OUT_DIV         = 2;

    // CLK25 divider: reference clock divided down to ~25 MHz for internal calibration
    localparam CLK25_DIV       = (PCIE_REFCLK_FREQ == 2) ? 10 :
                                 (PCIE_REFCLK_FREQ == 1) ?  5 : 4;

    // For GTX PCIe Gen1/Gen2 with 8B/10B, the following CDR setting may provide more margin
    // Async 72'h03_8000_23FF_1040_0020
    // Sync: 72'h03_0000_23FF_1040_0020   
    localparam RXCDR_CFG_GTX = ((PCIE_USE_MODE == "1.0") || (PCIE_USE_MODE == "1.1"))
                                ? ((PCIE_ASYNC_EN == "TRUE")
                                   ? 72'h11_07FE_2060_0104_0010
                                   : 72'h11_07FE_4060_0104_0000)   // IES setting
                                : ((PCIE_ASYNC_EN == "TRUE")
                                   ? 72'h03_8000_23FF_1020_0020     // GES async
                                   : 72'h03_0000_23FF_1020_0020);   // GES sync (recommended)

    // TXUSR for bypass TX buffer
    localparam TX_XCLK_SEL = (PCIE_TXBUF_EN == "TRUE") ? "TXOUT" : "TXUSR";

    localparam TX_RXDETECT_CFG = (PCIE_REFCLK_FREQ == 2) ? 14'd250 :
                                 (PCIE_REFCLK_FREQ == 1) ? 14'd125 : 14'd100;
    localparam TX_RXDETECT_REF = (((PCIE_USE_MODE == "1.0") || (PCIE_USE_MODE == "1.1"))
                                  && (PCIE_SIM_MODE == "FALSE")) ? 3'b000 : 3'b011;

    //---------- Select PCS_RSVD_ATTR ----------------------
    //  [0]: 1 = enable latch when bypassing TX buffer, 0 = disable latch when using TX buffer 
    //  [1]: 1 = enable manual TX sync,                 0 = enable auto TX sync
    //  [2]: 1 = enable manual RX sync,                 0 = enable auto RX sync
    //  [3]: 1 = select external clock for OOB          0 = select reference clock for OOB    
    //  [6]: 1 = enable DMON                            0 = disable DMON     
    //  [7]: 1 = filter stale TX[P/N] data when exiting TX electrical idle
    //  [8]: 1 = power up OOB                           0 = power down OOB
    // For our config: manual TX/RX sync (bits 1,2), TX buf bypass latch (bit 0),
    // OOB clock from fabric (bit 3 = OOBCLK_SEL), filter stale TX (bit 7),
    // OOB power-up (bit 8), DMON enable (bit 6, dmon helped me debug state machine somehow).
    localparam PCS_RSVD_ATTR = ((PCIE_TXBUF_EN == "FALSE") && (PCIE_TXSYNC_MODE == 0) && (PCIE_RXSYNC_MODE == 0))
                                ? {44'h0000000001C, OOBCLK_SEL, 3'd7}   // bypass + manual sync
                                : ((PCIE_TXBUF_EN == "TRUE")  && (PCIE_TXSYNC_MODE == 0) && (PCIE_RXSYNC_MODE == 0))
                                ? {44'h0000000001C, OOBCLK_SEL, 3'd6}   // use buf + manual sync
                                : {44'h0000000001C, OOBCLK_SEL, 3'd7};  // default
    // OOBCLK_SEL: 1 = CLKRSVD[0] pin (default), 0 = reference clock
    localparam OOBCLK_SEL = (PCIE_OOBCLK_MODE == 0) ? 1'd0 : 1'd1;

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

    wire [PCIE_LANE-1:0]     drp_done_reg2;
    wire [PCIE_LANE-1:0]     rxpmaresetdone_reg2;
    wire                     plllock_reg2;
    wire                     mmcm_lock_reg2;
    wire [PCIE_LANE-1:0]     resetdone_reg2;
    wire [PCIE_LANE-1:0]     phystatus_reg2;
    wire gt_rxcdrlock_reg2;
    two_beats #(.BEATS(2), .RSTVAL(0)) drp_done_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(drp_done), .out(drp_done_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) rxpmaresetdone_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(PIPE_RXPMARESETDONE), .out(rxpmaresetdone_reg2));
    two_beats #(.BEATS(2), .RSTVAL(0)) plllock_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(gt_cplllock),    .out(plllock_reg2));
    // rxcdrlock: just monitoring, unused
    two_beats #(.BEATS(2), .RSTVAL(0)) rxcdrlock_beats (.clk(PIPE_PCLK_IN), .rst(!reset_n_reg2), .sig(gt_rxcdrlock), .out(gt_rxcdrlock_reg2));
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
            //---------- Hold PLL and GTX Channel in Reset ----
            FSM_PLLRESET : begin
                rst_cpllreset  <= 1'd1;
                rst_gtreset   <= 1'd1;
                if (
                    (~plllock_reg2) && // TODO: skipped, don't manually reset GTPE2_COMMON for openXC7
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
                if (plllock_reg2) // TODO: skipped, don't manually reset GTPE2_COMMON for openXC7
                    fsm <= FSM_GTRESET;
                rst_cpllreset  <= 1'd0;
            end
            //---------- Release GTRESET -----------------------
            FSM_GTRESET : begin
                // GTX: no RXPMARESETDONE port; skip those states
                fsm <= FSM_MMCM_LOCK;
                rst_gtreset   <= 1'b0;
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
                //txdlyen <= 1'd1;
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
    wire [14:0] dmonitorout;
    wire dmonitorclk;
    BUFG dmonitorclk_bufg (.I(dmonitorout[7]), .O(dmonitorclk));

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
    //wire cpllpd   = 1'b0;
    //wire cpllrst  = 1'b0;
    (* equivalent_register_removal="no" *)  reg [95:0] cpllpd_wait = 96'hFFFFFFFFFFFFFFFFFFFFFFFF;             
    (* equivalent_register_removal="no" *)  reg [127:0] cpllreset_wait = 128'h000000000000000000000000000000FF;
    always @(posedge PIPE_CLK)                                                                            
    begin                                                                                                      
        cpllpd_wait <= {cpllpd_wait[94:0], 1'b0};                                                              
        cpllreset_wait <= {cpllreset_wait[126:0], 1'b0};                                                       
    end                                                                                                        
    wire cpllpd = cpllpd_wait[95];                                                                    
    wire cpllrst = cpllreset_wait[127];                                                             


    // No GTXE2_COMMON needed: use CPLL, clk into GTREFCLK0
    GTXE2_CHANNEL # (

        //Simulation Attributes
        .SIM_CPLLREFCLK_SEL             (3'b001),
        .SIM_RESET_SPEEDUP              (PCIE_SIM_SPEEDUP),
        .SIM_RECEIVER_DETECT_PASS       ("TRUE"),
        .SIM_TX_EIDLE_DRIVE_LEVEL       (PCIE_SIM_TX_EIDLE_DRIVE_LEVEL),
        .SIM_VERSION                    (PCIE_USE_MODE),
        //Clock Attributes 
        .CPLL_REFCLK_DIV                (CPLL_REFCLK_DIV),  // =1
        .CPLL_FBDIV_45                  (CPLL_FBDIV_45),    // =5
        .CPLL_FBDIV                     (CPLL_FBDIV),       // =5 for 100 MHz → 2500 MHz VCO
        .CPLL_CFG                       (CPLL_CFG),         // charge-pump config, silicon-dependent

        .TXOUT_DIV                      (OUT_DIV),          // =2: VCO/2 for line rate
        .RXOUT_DIV                      (OUT_DIV),
        .TX_CLK25_DIV                   (CLK25_DIV),        // =4 for 100 MHz ref
        .RX_CLK25_DIV                   (CLK25_DIV),
        .TX_CLKMUX_PD                   (CLKMUX_PD),
        .RX_CLKMUX_PD                   (CLKMUX_PD),
        .TX_XCLK_SEL                    ("TXUSR"), // TXOUT = use TX buffer, TXUSR = bypass TX buffer
        .RX_XCLK_SEL                    ("RXREC"), // RXREC = use RX buffer, RXUSR = bypass RX buffer
        .OUTREFCLK_SEL_INV              ( 2'b11),
        //Reset Attributes 
        .TXPCSRESET_TIME                ( 5'b00001),
        .RXPCSRESET_TIME                ( 5'b00001),
        .TXPMARESET_TIME                ( 5'b00011),
        .RXPMARESET_TIME                ( 5'b00011), // Optimized for sim
        //TX Data Attributes
        .TX_DATA_WIDTH                  (20),        // 2-byte external datawidth for Gen1/Gen2
        .TX_INT_DATAWIDTH               (0),
        //RX Data Attributes
        .RX_DATA_WIDTH                  (20),        // 2-byte external datawidth for Gen1/Gen2
        .RX_INT_DATAWIDTH               (0),
        //Command Attributes
        .TX_RXDETECT_CFG                (TX_RXDETECT_CFG),
        .TX_RXDETECT_REF                (TX_RXDETECT_REF),
        .RX_CM_SEL                      ( 2'd3),     // 0 = AVTT, 1 = GND, 2 = Float, 3 = Programmable
        .RX_CM_TRIM                        ( 3'b010),  // Select 800mV, Changed from 3 to 4-bits, optimized for IES
        .TX_EIDLE_ASSERT_DELAY          (PCIE_TX_EIDLE_ASSERT_DELAY),// Optimized for sim
        .TX_EIDLE_DEASSERT_DELAY        (3'b100),
        .PD_TRANS_TIME_NONE_P2          ( 8'h09),
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
        .TX_PREDRIVER_MODE              ( 1'b0),
        .TX_QPI_STATUS_EN               (1'b0),
        //Status Attributes
        .RX_SIG_VALID_DLY               (4),
        //DRP Attributes
        //PCS Attributes
        .PCS_PCIE_EN                    ("TRUE"),     // PCIe
        .PCS_RSVD_ATTR                  (/*48'h1cf*/ PCS_RSVD_ATTR),
         //PMA Attributes
        .PMA_RSV                        (32'h00018480),
        .PMA_RSV2                       (16'h2050),
        .RX_BIAS_CFG                    (12'b000000000100),
        //CDR Attributes
        .RXCDR_CFG                      (RXCDR_CFG_GTX),       // Optimized for IES                       
        .RXCDR_LOCK_CFG                 ( 6'b010101),                           // [5:3] Window Refresh, [2:1] Window Size, [0] Enable Detection (sensitive lock = 6'b111001)  CHECK
        .RXCDR_HOLD_DURING_EIDLE        ( 1'd1),                                // Hold  RX CDR           on electrical idle for Gen1/Gen2
        .RXCDR_FR_RESET_ON_EIDLE        ( 1'd0),                                // Reset RX CDR frequency on electrical idle for Gen3
        .RXCDR_PH_RESET_ON_EIDLE        ( 1'd0),                                // Reset RX CDR phase     on electrical idle for Gen3
        //LPM Attributes               
        .RXLPM_HF_CFG                   (14'h00F0),
        .RXLPM_LF_CFG                   (14'h00F0),
        //DFE Attributes, probably unused as we only use LPM
        .RX_DFE_GAIN_CFG                (23'h020FEA),
        .RX_DFE_H2_CFG                  (12'b000000000000),
        .RX_DFE_H3_CFG                  (12'b000001000000),
        .RX_DFE_H4_CFG                  (11'b00011110000),
        .RX_DFE_H5_CFG                  (11'b00011100000),
        .RX_DFE_KL_CFG                  (13'b0000011111110),
        .RX_DFE_KL_CFG2                 (32'h3290D86C),
        .RX_DFE_LPM_CFG                 (16'h0954),
        .RX_DFE_LPM_HOLD_DURING_EIDLE   ( 1'd1),
        .RX_DFE_UT_CFG                  (17'b10001111000000000),
        .RX_DFE_VP_CFG                  (17'b00011111100000011),
        .RX_DFE_XYD_CFG                 (13'h0000),
        //OS Attributes 
        .RX_OS_CFG                      (13'b0000010000000),
        //Eye Scan Attributes 
        .ES_EYE_SCAN_EN                 ("FALSE"),
        .ES_HORZ_OFFSET                 (12'd0),
        //TX Buffer Attributes               
        .TXBUF_EN                       (PCIE_TXBUF_EN),
        .TXBUF_RESET_ON_RATE_CHANGE     ("TRUE"),
        //RX Buffer Attributes                
        .RXBUF_EN                       ("TRUE"),
        .RX_DEFER_RESET_BUF_EN          ("TRUE"),
        .RXBUF_ADDR_MODE                ("FULL"),
        .RXBUF_EIDLE_HI_CNT                ( 4'd4),   // Optimized for sim
        .RXBUF_EIDLE_LO_CNT                ( 4'd0),   // Optimized for sim
        .RXBUF_RESET_ON_CB_CHANGE       ("TRUE"),
        .RXBUF_RESET_ON_COMMAALIGN      ("FALSE"),
        .RXBUF_RESET_ON_EIDLE           ("TRUE"),  // PCIe
        .RXBUF_RESET_ON_RATE_CHANGE     ("TRUE"),
        .RXBUF_THRESH_OVRD              ("FALSE"),
        .RXBUF_THRESH_OVFLW             (61),
        .RXBUF_THRESH_UNDFLW            ( 4),
        //TX Sync Attributes                
        .TXPH_MONITOR_SEL               ( 5'd0),
        .RXPHDLY_CFG                    (24'h004020),
        .RX_DDI_SEL                     (6'd0),
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
        .RXPRBS_ERR_LOOPBACK             ( 1'd0),
        .TX_LOOPBACK_DRIVE_HIZ           ("FALSE"),
        //MISC 
        .DMONITOR_CFG                   (24'h000B01),
        .RX_DEBUG_CFG                   (12'd0)
        //   Not used so far, maybe required for openxc7:
        //   ACJTAG-related 
        //   SAS and SATA related
        //   CFOK_CFG-related, RXPI, TXPI
    ) gtxe2_channel_i (
		//Clock 
        .GTGREFCLK                      (1'd0),
        .GTREFCLK0                      (PIPE_CLK), // 100 MHz refclk to CPLL
        .GTREFCLK1                      (1'd0),
        .GTNORTHREFCLK0                 (1'd0),
        .GTNORTHREFCLK1                 (1'd0),
        .GTSOUTHREFCLK0                 (1'd0),
        .GTSOUTHREFCLK1                 (1'd0),
        .QPLLCLK                        (1'd0), // QPLL unused
        .QPLLREFCLK                     (1'd0),
        .TXUSRCLK                       (PIPE_PCLK_IN),
        .RXUSRCLK                       (PIPE_RXUSRCLK_IN),
        .TXUSRCLK2                      (PIPE_PCLK_IN),
        .RXUSRCLK2                      (PIPE_RXUSRCLK_IN),
        .TXSYSCLKSEL                    (0),
        .RXSYSCLKSEL                    (0),
        .TXOUTCLKSEL                    (3'd3),
        .RXOUTCLKSEL                    (3'b0),
        // CPLL
        .CPLLREFCLKSEL                  (3'd1), // GTREFCLK0
        .CPLLLOCKDETCLK                 (1'd0),
        .CPLLLOCKEN                     (1'd1),
        .CLKRSVD                        ({2'd0, 1'b0, user_oobclk}),

        // CPLLLOCK: like PLL0LOCK from GTPE2_COMMON.
        .CPLLLOCK                       (gt_cplllock),
        .TXOUTCLK                       (PIPE_TXOUTCLK_OUT),
        .RXOUTCLK                       (),
        .TXOUTCLKFABRIC                 (),
        .RXOUTCLKFABRIC                 (),
        .TXOUTCLKPCS                    (),
        .RXOUTCLKPCS                    (),
        .RXCDRLOCK                      (gt_rxcdrlock),
        //Reset 
        .CPLLPD                         (cpllpd | 1'b0),
        .CPLLRESET                      (cpllrst | rst_cpllreset),
        .TXUSERRDY                      (rst_userrdy),
        .RXUSERRDY                      (rst_userrdy),
        .CFGRESET                       (1'd0),
        .GTRESETSEL                     (1'd0),
        .RESETOVRD                      (0),
        .GTTXRESET                      (rst_gtreset),
        .GTRXRESET                      (rst_gtreset),
                                                                               
        .TXRESETDONE                    (gt_txresetdone),
        .RXRESETDONE                    (gt_rxresetdone),
        .RXDFELPMRESET                  (1'd0),
		//TX Data 
        .TXDATA                         ({32'd0, PIPE_TXDATA[31:0]}),
        .TXCHARISK                      ({4'd0, PIPE_TXDATAK[3:0]}),
        .GTXTXP                         (PIPE_TXP[0]),
        .GTXTXN                         (PIPE_TXN[0]),
		//RX Data 
        .GTXRXP                         (PIPE_RXP[0]),
        .GTXRXN                         (PIPE_RXN[0]),
        .RXDATA                         (PIPE_RXDATA[31:0]),
        .RXCHARISK                      (PIPE_RXDATAK[3:0]),
        //Command                
        .TXDETECTRX                     (PIPE_TXDETECTRX),
        .TXPDELECIDLEMODE               ( 1'd0),
        .RXELECIDLEMODE                 ( 2'd0),
        .TXELECIDLE                     (PIPE_TXELECIDLE[0]),
        .TXCHARDISPMODE                 ({7'd0, PIPE_TXCOMPLIANCE[0]}),// Changed from 8 to 4-bits
        .TXCHARDISPVAL                  ( 8'd0),                       // Changed from 8 to 4-bits
        .TXPOLARITY                     ( 1'b0),
        .RXPOLARITY                     (PIPE_RXPOLARITY[0]),
        .TXPD                           (PIPE_POWERDOWN[1:0]),
        .RXPD                           (PIPE_POWERDOWN[1:0]),
        .TXRATE                         (pipe_rate_reg3 ? 3'd1 : 3'd0),
        .RXRATE                         (pipe_rate_reg3 ? 3'd1 : 3'd0),
        //Electrical Command                
        .TXMARGIN                       (PIPE_TXMARGIN),
        .TXSWING                        (PIPE_TXSWING),
        .TXDEEMPH                       (PIPE_TXDEEMPH[0]),
        .TXINHIBIT                      (0),
        .TXBUFDIFFCTRL                  (3'd4),
        .TXDIFFCTRL                     (4'b1100), // Select 850mV 
        .TXPRECURSOR                    (1'd0), // * if changed this, nextpnr will complain a lot (was 5'd0)
        .TXPRECURSORINV                 (1'd0),
        .TXMAINCURSOR                   (1'd0), // same, was 7'd0
        .TXPOSTCURSOR                   (0),
        .TXPOSTCURSORINV                (1'd0),
        .RXLPMEN                        ((PCIE_LPM_DFE == "LPM") ? 1'd1 : 1'd0), // LPM for Gen1/Gen2
        .RXDFEXYDEN                     (1'd0),
        //Status                
        .RXVALID                        (gt_rxvalid[0]),
        .PHYSTATUS                      (gt_phystatus[0]),
        .RXELECIDLE                     (PIPE_RXELECIDLE),
        .RXSTATUS                       (PIPE_RXSTATUS),
        .TXRATEDONE                     (gt_txratedone[0]),
        .RXRATEDONE                     (gt_rxratedone[0]),
        //DRP TODO: openxc7 doesn't support this yet, but no problem
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
        .GTRSVD                         (16'd0),

        //PCS 
        .TXPCSRESET                     (0),
        .RXPCSRESET                     (0),
        .PCSRSVDIN                      (16'd0), // [0]: 1 = TXRATE async, [1]: 1 = RXRATE async    
        
        .PCSRSVDOUT                     (),
        //CDR 
        .RXCDRRESET                     (0),
        .RXCDRFREQRESET                 (0),
        .RXCDRHOLD                      (1'b0),
        .RXCDROVRDEN                    (1'd0),
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
        .TX8B10BBYPASS                  (8'd0),
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
        .TXPISOPD                       ( 1'd0),
        .TSTIN                          (20'hFFFFF),
        .DMONITOROUT                    (dmonitorout[7:0])
    );

    assign gt_txsyncdone = {PCIE_LANE{1'b1}};
    assign gt_txsyncout  = {PCIE_LANE{1'b0}};
    assign gt_rxsyncout  = {PCIE_LANE{1'b0}};
    assign PIPE_RXPMARESETDONE = {PCIE_LANE{1'b0}};
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
