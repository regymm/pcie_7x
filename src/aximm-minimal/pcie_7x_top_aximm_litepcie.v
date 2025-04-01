// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
`timescale 1ns / 1ps

module pcie_7x_top_aximm_litepcie # (
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
  assign led = 0;

  // .LINK_CAP_MAX_LINK_SPEED        ( ENABLE_GEN2 ? 4'h2 : 4'h1 ),
  // .LINK_CTRL2_TARGET_LINK_SPEED   ( ENABLE_GEN2 ? 4'h2 : 4'h1 ),
  // .LINK_STATUS_SLOT_CLOCK_CONFIG  ( "TRUE" ),
  // .USER_CLK_FREQ                  ( ENABLE_GEN2 ? 2 : 1 ), // 62.5 MHz for Gen1, 125 MHz for Gen2

  // .CFG_DEV_ID                     (16'h9999),
  // .BAR0                           (32'hFFFFF000),

  //  //can reduce RAM usage (and performance) by tuning parameters
  //  //results can be derived from 7 Series Integrated Block for PCI Express -
  //  //Core Capabilities - BRAM Configuration Options, depending on Max Payload Size
  // .DEV_CAP_MAX_PAYLOAD_SUPPORTED  (1),
  // .VC0_RX_RAM_LIMIT               (13'h3FF),
  // .VC0_TOTAL_CREDITS_CD           (370),
  // .VC0_TOTAL_CREDITS_CH           (72),
  // .VC0_TOTAL_CREDITS_NPH          (4),
  // .VC0_TOTAL_CREDITS_NPD          (8),
  // .VC0_TOTAL_CREDITS_PD           (32),
  // .VC0_TOTAL_CREDITS_PH           (4),
  // .VC0_TX_LASTPACKET              (28)

wire user_clk;
wire user_reset_q;

wire [31:0] s_axi_awaddr;
wire s_axi_awvalid;
wire s_axi_awready;
wire [31:0] s_axi_wdata;
wire [3:0] s_axi_wstrb;
wire s_axi_wvalid;
wire s_axi_wready;
wire [1:0] s_axi_bresp;
wire s_axi_bvalid;
wire s_axi_bready;
wire [31:0] s_axi_araddr;
wire s_axi_arvalid;
wire s_axi_arready;
wire [31:0] s_axi_rdata;
wire s_axi_rvalid;
wire s_axi_rready;
wire [1:0] s_axi_rresp;

litepcie_core litepcie_core_inst (
  .clk(user_clk),
  .rst(user_reset_q),
  .mmap_axi_lite_araddr(s_axi_araddr),
  .mmap_axi_lite_arprot(),
  .mmap_axi_lite_arready(1'b1),
  .mmap_axi_lite_arvalid(s_axi_arvalid),
  .mmap_axi_lite_awaddr(s_axi_awaddr),
  .mmap_axi_lite_awprot(),
  .mmap_axi_lite_awready(1'b1),
  .mmap_axi_lite_awvalid(s_axi_awvalid),
  .mmap_axi_lite_bready(s_axi_bready),
  .mmap_axi_lite_bresp(2'b00),
  .mmap_axi_lite_bvalid(1'b1),
  .mmap_axi_lite_rdata(32'h12345678),
  .mmap_axi_lite_rready(s_axi_rready),
  .mmap_axi_lite_rresp(2'b00),
  .mmap_axi_lite_rvalid(1'b1),
  .mmap_axi_lite_wdata(s_axi_wdata),
  .mmap_axi_lite_wready(1'b1),
  .mmap_axi_lite_wstrb(s_axi_wstrb),
  .mmap_axi_lite_wvalid(s_axi_wvalid),
//  .mmap_axi_lite_araddr(s_axi_araddr),
//  .mmap_axi_lite_arprot(),
//  .mmap_axi_lite_arready(s_axi_arready),
//  .mmap_axi_lite_arvalid(s_axi_arvalid),
//  .mmap_axi_lite_awaddr(s_axi_awaddr),
//  .mmap_axi_lite_awprot(),
//  .mmap_axi_lite_awready(s_axi_awready),
//  .mmap_axi_lite_awvalid(s_axi_awvalid),
//  .mmap_axi_lite_bready(s_axi_bready),
//  .mmap_axi_lite_bresp(s_axi_bresp),
//  .mmap_axi_lite_bvalid(s_axi_bvalid),
//  .mmap_axi_lite_rdata(s_axi_rdata),
//  .mmap_axi_lite_rready(s_axi_rready),
//  .mmap_axi_lite_rresp(s_axi_rresp),
//  .mmap_axi_lite_rvalid(s_axi_rvalid),
//  .mmap_axi_lite_wdata(s_axi_wdata),
//  .mmap_axi_lite_wready(s_axi_wready),
//  .mmap_axi_lite_wstrb(s_axi_wstrb),
//  .mmap_axi_lite_wvalid(s_axi_wvalid),
  
  .msi_irqs(32'h0),

  .pcie_clk_n(sys_clk_n),
  .pcie_clk_p(sys_clk_p),
  .pcie_rst_n(sys_rst_n),
  .pcie_rx_n(pci_exp_rxn),
  .pcie_rx_p(pci_exp_rxp),
  .pcie_tx_n(pci_exp_txn),
  .pcie_tx_p(pci_exp_txp)
);

// Instantiate axil_minimum
//axil_minimum axil_minimum_inst (
//	.clk(user_clk),
//	.rst_n(!user_reset_q),
//	// AXI Lite Interface
//	.s_axi_awaddr(s_axi_awaddr),
//	.s_axi_awvalid(s_axi_awvalid),
//	.s_axi_awready(s_axi_awready),
//	.s_axi_wdata(s_axi_wdata),
//	.s_axi_wstrb(s_axi_wstrb),
//	.s_axi_wvalid(s_axi_wvalid),
//	.s_axi_wready(s_axi_wready),
//	.s_axi_bresp(s_axi_bresp),
//	.s_axi_bvalid(s_axi_bvalid),
//	.s_axi_bready(s_axi_bready),
//	.s_axi_araddr(s_axi_araddr),
//	.s_axi_arvalid(s_axi_arvalid),
//	.s_axi_arready(s_axi_arready),
//	.s_axi_rdata(s_axi_rdata),
//	.s_axi_rvalid(s_axi_rvalid),
//	.s_axi_rready(s_axi_rready),
//	.s_axi_rresp(s_axi_rresp)
//);
endmodule
