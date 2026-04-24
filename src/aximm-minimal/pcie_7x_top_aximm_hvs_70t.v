// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2026 regymm
`timescale 1ns / 1ps

module pcie_7x_top_aximm_hvs_70t (
  output      pci_exp_txp,
  output      pci_exp_txn,
  input       pci_exp_rxp,
  input       pci_exp_rxn,

  input       sys_clk_p,
  input       sys_clk_n,

//  input       clk200_p,
//  input       clk200_n,
  
  output      [3:0] led
);
// Card PCIe bracket 
// / [SFP] [SFP] led1(g) led3(g) sw2 sw1 jtag |
// \ [   ] [   ] led0(r) led2(r)              |
wire [3:0] led_n;
assign led = ~led_n;

//wire aux_clk_in;
//IBUFDS refclk_ibuf (.O(aux_clk_in), .I(clk200_p), .IB(clk200_n));

pcie_7x_top_aximm #(
    .NO_RESET(1),
    .ENABLE_GEN2(1),
    .GT_DEVICE("GTX"),
    .CFG_DEV_ID(16'h7070)
) pcie_7x_top_aximm_i (
  .pci_exp_txp(pci_exp_txp),
  .pci_exp_txn(pci_exp_txn),
  .pci_exp_rxp(pci_exp_rxp),
  .pci_exp_rxn(pci_exp_rxn),
  .sys_clk_p(sys_clk_p),
  .sys_clk_n(sys_clk_n),
  .sys_rst_n(1'b1),
//  .aux_clk_in(aux_clk_in),
  .led(led_n)
);
endmodule
