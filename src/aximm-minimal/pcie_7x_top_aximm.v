// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
`timescale 1ns / 1ps
//`define STOCK_APP

module pcie_7x_top_aximm # (
  parameter C_DATA_WIDTH        = 64, // RX/TX interface data width
  parameter KEEP_WIDTH          = C_DATA_WIDTH / 8, // TSTRB width
  parameter NO_RESET            = 0,
  parameter ENABLE_GEN2         = 0
) (
  output      pci_exp_txp,
  output      pci_exp_txn,
  input       pci_exp_rxp,
  input       pci_exp_rxn,

  input       sys_clk_p,
  input       sys_clk_n,
  input       sys_rst_n,
  
  output      [3:0] led
);
  // basic state monitoring by LEDs
  assign led = ~{2'b00, user_reset, user_lnk_up};
  wire [4:0]gt_reset_fsm;
  wire [5:0]pl_ltssm_state;
  //assign led = ~pl_ltssm_state[3:0];
  //assign led = ~pl_ltssm_state[5:2];
  //assign led = ~gt_reset_fsm[3:0];
  //reg fsm_was_4 = 0;
  //reg fsm_was_5 = 0;
  //reg fsm_was_6 = 0;
  //reg fsm_was_7 = 0;
  //wire pclk;
  //assign led = ~{fsm_was_4, fsm_was_5, fsm_was_6, fsm_was_7};
  //always @ (posedge pclk) begin
	  //if (!sys_rst_n_c) begin
		  //fsm_was_4 <= 0;
		  //fsm_was_5 <= 0;
		  //fsm_was_6 <= 0;
		  //fsm_was_7 <= 0;
	  //end else begin
		  //if ( pl_ltssm_state == 6'h4) begin
			  //fsm_was_4 <= 1;
		  //end
		  //if ( pl_ltssm_state == 6'h5) begin
			  //fsm_was_5 <= 1;
		  //end
		  //if ( pl_ltssm_state == 6'h6) begin
			  //fsm_was_6 <= 1;
		  //end
		  //if ( pl_ltssm_state == 6'h7) begin
			  //fsm_was_7 <= 1;
		  //end
	  //end
  //end

  wire                                        user_clk;
  wire                                        user_reset;
  wire                                        user_lnk_up;

  // Tx
  wire                                        s_axis_tx_tready;
  wire [3:0]                                  s_axis_tx_tuser;
  wire [C_DATA_WIDTH-1:0]                     s_axis_tx_tdata;
  wire [KEEP_WIDTH-1:0]                       s_axis_tx_tkeep;
  wire                                        s_axis_tx_tlast;
  wire                                        s_axis_tx_tvalid;

  // Rx
  wire [C_DATA_WIDTH-1:0]                     m_axis_rx_tdata;
  wire [KEEP_WIDTH-1:0]                       m_axis_rx_tkeep;
  wire                                        m_axis_rx_tlast;
  wire                                        m_axis_rx_tvalid;
  wire                                        m_axis_rx_tready;
  wire  [21:0]                                m_axis_rx_tuser;

  wire                                        tx_cfg_gnt;
  wire                                        rx_np_ok;
  wire                                        rx_np_req;
  wire                                        cfg_turnoff_ok;
  wire                                        cfg_trn_pending;
  wire                                        cfg_pm_halt_aspm_l0s;
  wire                                        cfg_pm_halt_aspm_l1;
  wire                                        cfg_pm_force_state_en;
  wire   [1:0]                                cfg_pm_force_state;
  wire                                        cfg_pm_wake;
  wire  [63:0]                                cfg_dsn;

  wire                                        cfg_interrupt;
  wire                                        cfg_interrupt_assert;
  wire   [7:0]                                cfg_interrupt_di;
  wire                                        cfg_interrupt_stat;
  wire   [4:0]                                cfg_pciecap_interrupt_msgnum;

  wire                                        cfg_to_turnoff;
  wire   [7:0]                                cfg_bus_number;
  wire   [4:0]                                cfg_device_number;
  wire   [2:0]                                cfg_function_number;

  wire                                        sys_rst_n_c;
  wire                                        sys_clk;

  reg                                         user_reset_q;
  reg                                         user_lnk_up_q;

  localparam USER_CLK_FREQ     = 1;
  localparam USER_CLK2_DIV2    = "FALSE";
  localparam USERCLK2_FREQ     = (USER_CLK2_DIV2 == "TRUE") ? (USER_CLK_FREQ == 4) ? 3 : (USER_CLK_FREQ == 3) ? 2 : USER_CLK_FREQ: USER_CLK_FREQ;

  generate if (NO_RESET) begin
    reg [12:0]sys_rst_cnt = 0;
    // should use sys_clk, but now openXC7 doesn't support using IBUFDS clock to ordinary logic. 
    // since MMCM is never reset, user_clk is available from the beginning
    always @ (posedge user_clk) begin 
        if (!sys_rst_cnt[12])
            sys_rst_cnt <= sys_rst_cnt + 1;
    end
    assign sys_rst_n_c = sys_rst_cnt[12];
  end else begin
    IBUF   sys_reset_n_ibuf (.O(sys_rst_n_c), .I(sys_rst_n));
  end
  endgenerate
  IBUFDS_GTE2 refclk_ibuf (.O(sys_clk), .ODIV2(), .I(sys_clk_p), .CEB(1'b0), .IB(sys_clk_n));

  always @(posedge user_clk) begin
    user_reset_q  <= user_reset;
    user_lnk_up_q <= user_lnk_up;
  end

pcie_7x # (	 
  .LINK_CAP_MAX_LINK_SPEED        ( ENABLE_GEN2 ? 4'h2 : 4'h1 ),
  .LINK_CTRL2_TARGET_LINK_SPEED   ( ENABLE_GEN2 ? 4'h2 : 4'h1 ),
  .LINK_STATUS_SLOT_CLOCK_CONFIG  ( "TRUE" ),
  .USER_CLK_FREQ                  ( ENABLE_GEN2 ? 2 : 1 ), // 62.5 MHz for Gen1, 125 MHz for Gen2

  .CFG_DEV_ID                     (16'h9999),
  .BAR0                           (32'hFFFFF000),

   //can reduce RAM usage (and performance) by tuning parameters
   //results can be derived from 7 Series Integrated Block for PCI Express -
   //Core Capabilities - BRAM Configuration Options, depending on Max Payload Size
  .DEV_CAP_MAX_PAYLOAD_SUPPORTED  (1),
  .VC0_RX_RAM_LIMIT               (13'h3FF),
  .VC0_TOTAL_CREDITS_CD           (370),
  .VC0_TOTAL_CREDITS_CH           (72),
  .VC0_TOTAL_CREDITS_NPH          (4),
  .VC0_TOTAL_CREDITS_NPD          (8),
  .VC0_TOTAL_CREDITS_PD           (32),
  .VC0_TOTAL_CREDITS_PH           (4),
  .VC0_TX_LASTPACKET              (28)
) pcie_7x_i (
  .pci_exp_txn                               ( pci_exp_txn ),
  .pci_exp_txp                               ( pci_exp_txp ),
  .pci_exp_rxn                               ( pci_exp_rxn ),
  .pci_exp_rxp                               ( pci_exp_rxp ),
  .pipe_mmcm_rst_n                            ( 1 ),
  // Common
  .user_clk_out                              ( user_clk ),
  .user_reset_out                            ( user_reset ),
  .user_lnk_up                               ( user_lnk_up ),
  // TX
  .s_axis_tx_tready                          ( s_axis_tx_tready ),
  .s_axis_tx_tdata                           ( s_axis_tx_tdata ),
  .s_axis_tx_tkeep                           ( s_axis_tx_tkeep ),
  .s_axis_tx_tuser                           ( s_axis_tx_tuser ),
  .s_axis_tx_tlast                           ( s_axis_tx_tlast ),
  .s_axis_tx_tvalid                          ( s_axis_tx_tvalid ),
  // Rx
  .m_axis_rx_tdata                           ( m_axis_rx_tdata ),
  .m_axis_rx_tkeep                           ( m_axis_rx_tkeep ),
  .m_axis_rx_tlast                           ( m_axis_rx_tlast ),
  .m_axis_rx_tvalid                          ( m_axis_rx_tvalid ),
  .m_axis_rx_tready                          ( m_axis_rx_tready ),
  .m_axis_rx_tuser                           ( m_axis_rx_tuser ),

  .tx_cfg_gnt                                ( tx_cfg_gnt ),
  .rx_np_ok                                  ( rx_np_ok ),
  .rx_np_req                                 ( rx_np_req ),
  .cfg_trn_pending                           ( cfg_trn_pending ),
  .cfg_pm_halt_aspm_l0s                      ( cfg_pm_halt_aspm_l0s ),
  .cfg_pm_halt_aspm_l1                       ( cfg_pm_halt_aspm_l1 ),
  .cfg_pm_force_state_en                     ( cfg_pm_force_state_en ),
  .cfg_pm_force_state                        ( cfg_pm_force_state ),
  .cfg_dsn                                   ( cfg_dsn ),
  .cfg_turnoff_ok                            ( cfg_turnoff_ok ),
  .cfg_pm_wake                               ( cfg_pm_wake ),

  .cfg_interrupt                             ( cfg_interrupt ),
  .cfg_interrupt_rdy                         ( ),
  .cfg_interrupt_assert                      ( cfg_interrupt_assert ),
  .cfg_interrupt_di                          ( cfg_interrupt_di ),
  .cfg_interrupt_do                          ( ),
  .cfg_interrupt_mmenable                    ( ),
  .cfg_interrupt_msienable                   ( ),
  .cfg_interrupt_msixenable                  ( ),
  .cfg_interrupt_msixfm                      ( ),
  .cfg_interrupt_stat                        ( cfg_interrupt_stat ),
  .cfg_pciecap_interrupt_msgnum              ( cfg_pciecap_interrupt_msgnum ),

  .cfg_status                                ( ),
  .cfg_command                               ( ),
  .cfg_dstatus                               ( ),
  .cfg_lstatus                               ( ),
  .cfg_pcie_link_state                       ( ),
  .cfg_dcommand                              ( ),
  .cfg_lcommand                              ( ),
  .cfg_dcommand2                             ( ),

  .cfg_pmcsr_pme_en                          ( ),
  .cfg_pmcsr_powerstate                      ( ),
  .cfg_pmcsr_pme_status                      ( ),
  .cfg_received_func_lvl_rst                 ( ),
  .tx_buf_av                                 ( ),
  .tx_err_drop                               ( ),
  .tx_cfg_req                                ( ),
  .cfg_to_turnoff                            ( cfg_to_turnoff ),
  .cfg_bus_number                            ( cfg_bus_number ),
  .cfg_device_number                         ( cfg_device_number ),
  .cfg_function_number                       ( cfg_function_number ),
  .sys_clk                                   ( sys_clk ),
  .sys_rst_n                                 ( sys_rst_n_c ),
  .gt_reset_fsm                              ( gt_reset_fsm ),
  .pl_ltssm_state                            ( pl_ltssm_state )
);

`ifndef STOCK_APP
wire[31:2]      m_al_waddr;
wire[31:0]      m_al_wdata;
wire            m_al_wvalid;
wire            m_al_wready;
wire[31:2]      m_al_araddr;
wire            m_al_arvalid;
wire            m_al_arready;
wire[31:0]      m_al_rdata;
wire            m_al_rvalid;
wire            m_al_rready;
axis_pcie_to_al_us #(
	.ADDR_WIDTH(32),
	.BUS_WIDTH(C_DATA_WIDTH),
	.ULTRA_SCALE(0),
	.TKEEP_WIDTH(C_DATA_WIDTH/32),
	//.SYNC_READ_WRITE(0),
	//.EN64BIT(1),
	.DWISBE(1)
) axis_pcie_to_al_us_inst (
	.clk(user_clk),
	.rst_n(!user_reset_q),
	.cfg_completer_id({ cfg_bus_number, cfg_device_number, cfg_function_number }),

	.s_axis_rx_tdata(m_axis_rx_tdata),
	.s_axis_rx_tkeep({m_axis_rx_tkeep[4], m_axis_rx_tkeep[0]}), // assume no other than 0 or f
	.s_axis_rx_tlast(m_axis_rx_tlast),
	.s_axis_rx_tvalid(m_axis_rx_tvalid),
	.s_axis_rx_tuser({66'b0, m_axis_rx_tuser}),
	.s_axis_rx_tready(m_axis_rx_tready),

	.m_axis_tx_tdata(s_axis_tx_tdata),
	.m_axis_tx_tkeep(s_axis_tx_tkeep_2),
	.m_axis_tx_tlast(s_axis_tx_tlast),
	.m_axis_tx_tvalid(s_axis_tx_tvalid),
	.m_axis_tx_tuser(s_axis_tx_tuser),
	.m_axis_tx_tready(s_axis_tx_tready),

	.m_al_waddr(m_al_waddr),
	.m_al_wdata(m_al_wdata),
	.m_al_wvalid(m_al_wvalid),
	.m_al_wready(m_al_wready),

	.m_al_araddr(m_al_araddr),
	.m_al_arvalid(m_al_arvalid),
	.m_al_arready(m_al_arready),

	.m_al_rdata(m_al_rdata),
	.m_al_rvalid(m_al_rvalid),
	.m_al_rready(m_al_rready)
);

wire [1:0]s_axis_tx_tkeep_2;
assign s_axis_tx_tkeep = {{4{s_axis_tx_tkeep_2[1]}}, {4{s_axis_tx_tkeep_2[0]}}};

wire [31:0] s_axi_awaddr;
wire        s_axi_awvalid;
wire        s_axi_awready;

wire [31:0] s_axi_wdata;
wire [3:0]  s_axi_wstrb;
wire        s_axi_wvalid;
wire        s_axi_wready;

wire [1:0]  s_axi_bresp;
wire        s_axi_bvalid;
wire        s_axi_bready;

wire [31:0] s_axi_araddr;
wire        s_axi_arvalid;
wire        s_axi_arready;

wire [31:0] s_axi_rdata;
wire        s_axi_rvalid;
wire        s_axi_rready;
wire [1:0]  s_axi_rresp;

assign tx_cfg_gnt = 1'b1;                        // Always allow transmission of Config traffic within block
assign rx_np_ok = 1'b1;                          // Allow Reception of Non-posted Traffic
assign rx_np_req = 1'b1;                         // Always request Non-posted Traffic if available
assign cfg_pm_wake = 1'b0;                       // Never direct the core to send a PM_PME Message
assign cfg_trn_pending = 1'b0;                   // Never set the transaction pending bit in the Device Status Register
assign cfg_pm_halt_aspm_l0s = 1'b0;              // Allow entry into L0s
assign cfg_pm_halt_aspm_l1 = 1'b0;               // Allow entry into L1
assign cfg_pm_force_state_en  = 1'b0;            // Do not qualify cfg_pm_force_state
assign cfg_pm_force_state  = 2'b00;              // Do not move force core into specific PM state
assign cfg_dsn = 64'h0000000101000a35;           // Assign the input DSN (Device Serial Number)
//assign s_axis_tx_tuser[0] = 1'b0;                // Unused for V6
//assign s_axis_tx_tuser[1] = 1'b0;                // Error forward packet
//assign s_axis_tx_tuser[2] = 1'b0;                // Stream packet
//assign s_axis_tx_tuser[3] = 1'b0;                // Transmit source discontinue
assign cfg_turnoff_ok = cfg_to_turnoff; //

assign cfg_interrupt = 1'b0;
assign cfg_interrupt_assert = 1'b0;
assign cfg_interrupt_stat = 1'b0;
assign cfg_interrupt_di= 0;

// Instantiate axil_to_al
axil_to_al #(
	.ADDR_WIDTH(32)
) axil_to_al_inst (
	.clk(user_clk),
	.rst_n(!user_reset_q),
	// AXI Lite Interface
	.s_axi_awaddr(s_axi_awaddr),
	.s_axi_awvalid(s_axi_awvalid),
	.s_axi_awready(s_axi_awready),
	.s_axi_wdata(s_axi_wdata),
	.s_axi_wstrb(s_axi_wstrb),
	.s_axi_wvalid(s_axi_wvalid),
	.s_axi_wready(s_axi_wready),
	.s_axi_bresp(s_axi_bresp),
	.s_axi_bvalid(s_axi_bvalid),
	.s_axi_bready(s_axi_bready),
	.s_axi_araddr(s_axi_araddr),
	.s_axi_arvalid(s_axi_arvalid),
	.s_axi_arready(s_axi_arready),
	.s_axi_rdata(s_axi_rdata),
	.s_axi_rvalid(s_axi_rvalid),
	.s_axi_rready(s_axi_rready),
	.s_axi_rresp(s_axi_rresp),
	// AL Interface
	.m_al_waddr(m_al_waddr),
	.m_al_wdata(m_al_wdata),
	.m_al_wvalid(m_al_wvalid),
	.m_al_wready(m_al_wready),
	.m_al_araddr(m_al_araddr),
	.m_al_arvalid(m_al_arvalid),
	.m_al_arready(m_al_arready),
	.m_al_rdata(m_al_rdata),
	.m_al_rvalid(m_al_rvalid),
	.m_al_rready(m_al_rready)
);

// Instantiate axil_minimum
axil_minimum axil_minimum_inst (
	.clk(user_clk),
	.rst_n(!user_reset_q),
	// AXI Lite Interface
	.s_axi_awaddr(s_axi_awaddr),
	.s_axi_awvalid(s_axi_awvalid),
	.s_axi_awready(s_axi_awready),
	.s_axi_wdata(s_axi_wdata),
	.s_axi_wstrb(s_axi_wstrb),
	.s_axi_wvalid(s_axi_wvalid),
	.s_axi_wready(s_axi_wready),
	.s_axi_bresp(s_axi_bresp),
	.s_axi_bvalid(s_axi_bvalid),
	.s_axi_bready(s_axi_bready),
	.s_axi_araddr(s_axi_araddr),
	.s_axi_arvalid(s_axi_arvalid),
	.s_axi_arready(s_axi_arready),
	.s_axi_rdata(s_axi_rdata),
	.s_axi_rvalid(s_axi_rvalid),
	.s_axi_rready(s_axi_rready),
	.s_axi_rresp(s_axi_rresp)
);
`endif

// default Vivado testing userapp
`ifdef STOCK_APP
pcie_app_7x  #(
  .C_DATA_WIDTH( C_DATA_WIDTH )
) app (
  // Common
  .user_clk                       ( user_clk ),
  .user_reset                     ( user_reset_q ),
  .user_lnk_up                    ( user_lnk_up_q ),

  // Tx
  .s_axis_tx_tready               ( s_axis_tx_tready ),
  .s_axis_tx_tdata                ( s_axis_tx_tdata ),
  .s_axis_tx_tkeep                ( s_axis_tx_tkeep ),
  .s_axis_tx_tuser                ( s_axis_tx_tuser ),
  .s_axis_tx_tlast                ( s_axis_tx_tlast ),
  .s_axis_tx_tvalid               ( s_axis_tx_tvalid ),

  // Rx
  .m_axis_rx_tdata                ( m_axis_rx_tdata ),
  .m_axis_rx_tkeep                ( m_axis_rx_tkeep ),
  .m_axis_rx_tlast                ( m_axis_rx_tlast ),
  .m_axis_rx_tvalid               ( m_axis_rx_tvalid ),
  .m_axis_rx_tready               ( m_axis_rx_tready ),
  .m_axis_rx_tuser                ( m_axis_rx_tuser ),

  .tx_cfg_gnt                     ( tx_cfg_gnt ),
  .rx_np_ok                       ( rx_np_ok ),
  .rx_np_req                      ( rx_np_req ),
  .cfg_turnoff_ok                 ( cfg_turnoff_ok ),
  .cfg_trn_pending                ( cfg_trn_pending ),
  .cfg_pm_halt_aspm_l0s           ( cfg_pm_halt_aspm_l0s ),
  .cfg_pm_halt_aspm_l1            ( cfg_pm_halt_aspm_l1 ),
  .cfg_pm_force_state_en          ( cfg_pm_force_state_en ),
  .cfg_pm_force_state             ( cfg_pm_force_state ),
  .cfg_pm_wake                    ( cfg_pm_wake ),
  .cfg_dsn                        ( cfg_dsn ),

  .cfg_to_turnoff                 ( cfg_to_turnoff ),
  .cfg_bus_number                 ( cfg_bus_number ),
  .cfg_device_number              ( cfg_device_number ),
  .cfg_function_number            ( cfg_function_number ),

  .cfg_interrupt                  ( cfg_interrupt ),
  .cfg_interrupt_assert           ( cfg_interrupt_assert ),
  .cfg_interrupt_di               ( cfg_interrupt_di ),
  .cfg_interrupt_stat             ( cfg_interrupt_stat ),
  .cfg_pciecap_interrupt_msgnum   ( cfg_pciecap_interrupt_msgnum )

);
`endif

endmodule
