// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2026 regymm
`timescale 1ns / 1ps

module pcie_7x_top_uart_loopback_ypcb_480t (
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

wire rx; // input
wire tx; // output
wire [3:0] led_o;

reg [11:0] uart_led_cnt = 0;
wire uart_led = uart_led_cnt != 0;
always @ (posedge clk_50) begin
    if (!rx) begin
        uart_led_cnt <= 12'hFFF;
    end else begin
        if (uart_led) uart_led_cnt <= uart_led_cnt - 1;
    end
end

assign rx = tx;
assign led = {uart_led, led_o[1:0]};

pcie_7x_top_uart #(
    .NO_RESET(0),
    .ENABLE_GEN2(0),
    .GT_DEVICE("GTX"),
    .CFG_DEV_ID(16'h0481)
) pcie_7x_top_uart_loopback_ypcb_480t_i (
  .pci_exp_txp(pci_exp_txp),
  .pci_exp_txn(pci_exp_txn),
  .pci_exp_rxp(pci_exp_rxp),
  .pci_exp_rxn(pci_exp_rxn),
  .sys_clk_p(sys_clk_p),
  .sys_clk_n(sys_clk_n),
  .sys_rst_n(sys_rst_n),
  .led(led_o),
  .rx(rx),
  .tx(tx)
);
endmodule
