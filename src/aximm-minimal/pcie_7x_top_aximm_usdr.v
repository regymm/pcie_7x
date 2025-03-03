// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
`timescale 1ns / 1ps

module pcie_7x_top_aximm_usdr (
  output      pci_exp_txp,
  output      pci_exp_txn,
  input       pci_exp_rxp,
  input       pci_exp_rxn,

  input       sys_clk_p,
  input       sys_clk_n,
  
  output      [2:0] led
);
pcie_7x_top_aximm #(.NO_RESET(1)) pcie_7x_top_aximm_i (
  .pci_exp_txp(pci_exp_txp),
  .pci_exp_txn(pci_exp_txn),
  .pci_exp_rxp(pci_exp_rxp),
  .pci_exp_rxn(pci_exp_rxn),
  .sys_clk_p(sys_clk_p),
  .sys_clk_n(sys_clk_n),
  .sys_rst_n(1'b1),
  .led(led)
);
endmodule
