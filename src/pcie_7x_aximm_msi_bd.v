// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
// PCIe to AXI4 Lite Memory-Mapped with MSI interrupt, can place on Block Design
// This uses little endian!
`timescale 1ns / 1ps
`default_nettype wire

// external clock, not external GT
module pcie_7x_aximm_msi_bd (
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt txp" *)
  output      [0:0]pci_exp_txp,
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt txn" *)
  output      [0:0]pci_exp_txn,
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt rxp" *)
  input       [0:0]pci_exp_rxp,
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt rxn" *)
  input       [0:0]pci_exp_rxn,

  // 100 MHz refclk in via BUFGDS
  input refclk,
  input sys_rst_n,

  output user_link_up,
  output mmcm_lock,

  // interrupts, msi_vector_width unused on TimeCard
  input  intx_msi_request,
  input  [4:0]msi_vector_num,
  output intx_msi_grant,
  output msi_enable,
  output [2:0]msi_vector_width,

  // AXI Lite master interface

  (* X_INTERFACE_PARAMETER = "FREQ_HZ 62500000" *)
  output m_axi_clk,
  output m_axi_aresetn,

  output [31:0] m_axi_awaddr,
  output        m_axi_awvalid,
  input         m_axi_awready,
  
  output [31:0] m_axi_wdata,
  output [3:0]  m_axi_wstrb,
  output        m_axi_wvalid,
  input         m_axi_wready,
  
  input  [1:0]  m_axi_bresp,
  input         m_axi_bvalid,
  output        m_axi_bready,
  
  output [31:0] m_axi_araddr,
  output        m_axi_arvalid,
  input         m_axi_arready,
  
  input  [31:0] m_axi_rdata,
  input         m_axi_rvalid,
  output        m_axi_rready,
  input  [1:0]  m_axi_rresp
);
  localparam C_DATA_WIDTH        = 64; // RX/TX interface data width
  localparam KEEP_WIDTH          = C_DATA_WIDTH / 8; // TSTRB width

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

  reg                                         user_reset_q;
  reg                                         user_lnk_up_q;

  localparam USER_CLK_FREQ     = 1;
  localparam USER_CLK2_DIV2    = "FALSE";
  localparam USERCLK2_FREQ     = (USER_CLK2_DIV2 == "TRUE") ? (USER_CLK_FREQ == 4) ? 3 : (USER_CLK_FREQ == 3) ? 2 : USER_CLK_FREQ: USER_CLK_FREQ;

  always @(posedge user_clk) begin
    user_reset_q  <= user_reset;
    user_lnk_up_q <= user_lnk_up;
  end

pcie_7x #
   (	 
  .PCIE_USERCLK1_FREQ             ( USER_CLK_FREQ +1 ),
  .PCIE_USERCLK2_FREQ             ( USERCLK2_FREQ +1 ),

  // Time Card
  .CFG_VEND_ID                    (16'h1D9B),
  .CFG_DEV_ID                     (16'h0400),
  .CFG_SUBSYS_VEND_ID             (16'h10EE),
  .CFG_SUBSYS_ID                  (16'h0007),
  .CLASS_CODE                     (24'h058000),
  // 32 MB Bar
  .BAR0                           (32'hFE000000),
  // enable up to 32 interrupts
  .MSI_CAP_MULTIMSGCAP            (5)

  // can reduce RAM usage (and performance) by tuning parameters
  // results can be derived from 7 Series Integrated Block for PCI Express -
  // Core Capabilities - BRAM Configuration Options, depending on Max Payload Size
  //.DEV_CAP_MAX_PAYLOAD_SUPPORTED  (1),
  //.VC0_RX_RAM_LIMIT               (13'h3FF),
  //.VC0_TOTAL_CREDITS_CD           (370),
  //.VC0_TOTAL_CREDITS_CH           (72),
  //.VC0_TOTAL_CREDITS_NPH          (4),
  //.VC0_TOTAL_CREDITS_NPD          (8),
  //.VC0_TOTAL_CREDITS_PD           (32),
  //.VC0_TOTAL_CREDITS_PH           (4),
  //.VC0_TX_LASTPACKET              (28)
   ) 
pcie_7x_i
  (
  .pci_exp_txn                               ( pci_exp_txn[0] ),
  .pci_exp_txp                               ( pci_exp_txp[0] ),
  .pci_exp_rxn                               ( pci_exp_rxn[0] ),
  .pci_exp_rxp                               ( pci_exp_rxp[0] ),
  .pipe_mmcm_rst_n                            ( 1 ),
  .pipe_mmcm_lock                            ( mmcm_lock ),
  // Common
  .user_clk_out                              ( user_clk ),
  .user_reset_out                            ( user_reset ),
  .user_lnk_up                               ( user_link_up ),
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

  // refer to PG054 Interrupt Interface Signals
  .cfg_interrupt                             ( intx_msi_request ),
  .cfg_interrupt_rdy                         ( intx_msi_grant),
  .cfg_interrupt_assert                      ( 1'b0 ), // for legacy interrupt, tie to 0
  .cfg_interrupt_di                          ( {3'b0, msi_vector_num} ), // MSI vector number, only up to 5 bits are supported by PCIe standard, but somehow Xilinx's endpoint can go up to 8-bit (256 vectors)
  .cfg_interrupt_do                          ( ),
  .cfg_interrupt_mmenable                    ( msi_vector_width ), // 0 to 5 bits. However, Linux kernel may only support single-vector MSI
  .cfg_interrupt_msienable                   ( msi_enable ), // only MSI interrupt (not legacy or PCIe Gen3 MSI-X)
  .cfg_interrupt_msixenable                  ( ),
  .cfg_interrupt_msixfm                      ( ),
  .cfg_interrupt_stat                        ( 1'b0 ),
  .cfg_pciecap_interrupt_msgnum              ( 5'b0 ),

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
  .sys_clk                                    ( refclk ),
  .sys_rst_n                                  ( sys_rst_n )
);

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

wire [1:0]s_axis_tx_tkeep_2;
assign s_axis_tx_tkeep = {{4{s_axis_tx_tkeep_2[1]}}, {4{s_axis_tx_tkeep_2[0]}}};

axis_pcie_to_al_us #(
	.ADDR_WIDTH(32),
	.BUS_WIDTH(C_DATA_WIDTH),
	.ULTRA_SCALE(0),
	.TKEEP_WIDTH(C_DATA_WIDTH/32),
	//.SYNC_READ_WRITE(0),
	//.EN64BIT(1),
	.DWISBE(0)
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

assign tx_cfg_gnt = 1'b1;                        // Always allow transmission of Config traffic within block
assign rx_np_ok = 1'b1;                          // Allow Reception of Non-posted Traffic
assign rx_np_req = 1'b1;                         // Always request Non-posted Traffic if available
assign cfg_pm_wake = 1'b0;                       // Never direct the core to send a PM_PME Message
assign cfg_trn_pending = 1'b0;                   // Never set the transaction pending bit in the Device Status Register
assign cfg_pm_halt_aspm_l0s = 1'b0;              // Allow entry into L0s (not allow)
assign cfg_pm_halt_aspm_l1 = 1'b0;               // Allow entry into L1 (not allow)
assign cfg_pm_force_state_en  = 1'b0;            // Do not qualify cfg_pm_force_state
assign cfg_pm_force_state  = 2'b00;              // Do not move force core into specific PM state
assign cfg_dsn = 64'h0000000101000a35;           // Assign the input DSN (Device Serial Number)
assign cfg_turnoff_ok = cfg_to_turnoff;

//assign cfg_interrupt = 1'b0;
//assign cfg_interrupt_assert = 1'b0;
//assign cfg_interrupt_stat = 1'b0;
//assign cfg_interrupt_di= 0;

assign m_axi_clk = user_clk;
assign m_axi_aresetn = !user_reset_q;

// Instantiate axil_to_al
axil_to_al #(
	.ADDR_WIDTH(32)
) axil_to_al_inst (
	.clk(user_clk),
	.rst_n(!user_reset_q),
	// AXI Lite Interface
	.s_axi_awaddr(m_axi_awaddr),
	.s_axi_awvalid(m_axi_awvalid),
	.s_axi_awready(m_axi_awready),
	.s_axi_wdata(m_axi_wdata),
	.s_axi_wstrb(m_axi_wstrb),
	.s_axi_wvalid(m_axi_wvalid),
	.s_axi_wready(m_axi_wready),
	.s_axi_bresp(m_axi_bresp),
	.s_axi_bvalid(m_axi_bvalid),
	.s_axi_bready(m_axi_bready),
	.s_axi_araddr(m_axi_araddr),
	.s_axi_arvalid(m_axi_arvalid),
	.s_axi_arready(m_axi_arready),
	.s_axi_rdata(m_axi_rdata),
	.s_axi_rvalid(m_axi_rvalid),
	.s_axi_rready(m_axi_rready),
	.s_axi_rresp(m_axi_rresp),
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

endmodule
