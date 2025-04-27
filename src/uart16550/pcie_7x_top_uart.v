// SPDX-License-Identifier: CERN-OHL-P
// Author: regymm
`timescale 1ns / 1ps

module pcie_7x_top_uart # (
  parameter C_DATA_WIDTH        = 64, // RX/TX interface data width
  parameter KEEP_WIDTH          = C_DATA_WIDTH / 8, // TSTRB width
  parameter NO_RESET            = 0,
  parameter ENABLE_GEN2         = 0,
  parameter MULTI_VECTOR_MSI    = 0 // 0 for single vector, 1 for 32 vectors
) (
  output      pci_exp_txp,
  output      pci_exp_txn,
  input       pci_exp_rxp,
  input       pci_exp_rxn,

  input       sys_clk_p,
  input       sys_clk_n,
  input       sys_rst_n,
  
  output      [3:0] led,

  input       rx,
  output      tx,
  output      sma1inN,
  output      sma2outN
);
assign sma1inN = 0;
assign sma2outN = 0;
// basic state monitoring by LEDs
assign led = ~{2'b00, user_reset, user_lnk_up};
wire [4:0]gt_reset_fsm;
wire [5:0]pl_ltssm_state;

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
  IBUF sys_reset_n_ibuf (.O(sys_rst_n_c), .I(sys_rst_n));
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
  .MSI_CAP_MULTIMSGCAP            (5),

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
  .cfg_interrupt_stat                        ( 1'b0 ), // 0
  .cfg_pciecap_interrupt_msgnum              ( 5'd0 ),

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
assign cfg_pm_halt_aspm_l0s = 1'b0;              // Allow entry into L0s (not allow)
assign cfg_pm_halt_aspm_l1 = 1'b0;               // Allow entry into L1 (not allow)
assign cfg_pm_force_state_en  = 1'b0;            // Do not qualify cfg_pm_force_state
assign cfg_pm_force_state  = 2'b00;              // Do not move force core into specific PM state
assign cfg_dsn = 64'h0000000101000a35;           // Assign the input DSN (Device Serial Number)
//assign s_axis_tx_tuser[0] = 1'b0;                // Unused for V6
//assign s_axis_tx_tuser[1] = 1'b0;                // Error forward packet
//assign s_axis_tx_tuser[2] = 1'b0;                // Stream packet
//assign s_axis_tx_tuser[3] = 1'b0;                // Transmit source discontinue
assign cfg_turnoff_ok = cfg_to_turnoff; //

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

wire msi_enable;
reg  intx_msi_request;
wire intx_msi_grant;
wire [2:0]msi_vector_width;
wire [4:0]msi_vector_num;
wire uart_irq;

// Bridge irq to MSI
assign msi_vector_num = 5'b1; // usually don't use 0
always @ (posedge user_clk) begin
  if (user_reset_q) begin
    intx_msi_request <= 1'b0;
  end else begin
    if (intx_msi_request) begin
      if (intx_msi_grant)
        intx_msi_request <= 1'b0;
    end else if (msi_enable & uart_irq) begin
      intx_msi_request <= 1'b1;
    end
  end
end

// AXIL to MM
wire [31:0] a;
wire [31:0] d;
wire        rd;
wire        we;
wire [31:0] spo;
wire        ready;
axil2mm axil2mm_inst(
  .s_axi_clk(user_clk),
  .s_axi_aresetn(!user_reset_q),
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
  .a(a),
  .d(d),
  .rd(rd),
  .we(we),
  .spo(spo),
  .ready(ready)
);
// UART 16550
uart16550 #(
  .CLOCK_FREQ(62500000),
  .RESET_BAUD_RATE(9600),
  .FIFODEPTH(16),
  .SIM(0)
) uart16550_inst (
  .clk(user_clk),
  .rst(user_reset_q),
  .a(a[4:2]),
  .d(d),
  .rd(rd),
  .we(we),
  .spo(spo),
  .ready(ready),
  .rx(rx),
  .tx(tx),
  .irq(uart_irq)
);
endmodule
