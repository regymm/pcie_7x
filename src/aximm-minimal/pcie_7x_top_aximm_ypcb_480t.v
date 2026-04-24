// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2026 regymm
`timescale 1ns / 1ps

module pcie_7x_top_aximm_ypcb_480t (
  output      pci_exp_txp,
  output      pci_exp_txn,
  input       pci_exp_rxp,
  input       pci_exp_rxn,

  input       sys_clk_p,
  input       sys_clk_n,

  input       sys_rst_n,
  
  input       clk_50,
  output      [2:0] led
);
//wire sys_clk;
//IBUFDS_GTE2 refclk_ibuf(.O(sys_clk), .ODIV2(), .I(sys_clk_p), .CEB(1'b0), .IB(sys_clk_n));
//reg [31:0] cnt = 0;
//always @(posedge sys_clk) begin
    //cnt = cnt + 1;
//end
//assign led = cnt[27:25];
pcie_7x_top_aximm #(
    .NO_RESET(1),
    .ENABLE_GEN2(1),
    .GT_DEVICE("GTX"),
    .CFG_DEV_ID(16'h0480)
) pcie_7x_top_aximm_i (
  .pci_exp_txp(pci_exp_txp),
  .pci_exp_txn(pci_exp_txn),
  .pci_exp_rxp(pci_exp_rxp),
  .pci_exp_rxn(pci_exp_rxn),
  .sys_clk_p(sys_clk_p),
  .sys_clk_n(sys_clk_n),
  .sys_rst_n(sys_rst_n),
  .led(led)
);
endmodule
