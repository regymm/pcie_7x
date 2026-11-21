// SPDX-License-Identifier: GPL-3.0-or-later
// Author: regymm
// AXI 16550 UART module, to be placed on Block Design
module axi_uart16550 #(
    parameter CLOCK_FREQ = 62500000,
    parameter RESET_BAUD_RATE = 9600,
    parameter FIFODEPTH = 16,
    parameter LENDIAN = 1,
    parameter SIM = 0
) (
    input wire        s_axi_clk,
    input wire        s_axi_aresetn,
    // AXI Lite Write Address Channel
    input wire [31:0] s_axi_awaddr,
    input wire        s_axi_awvalid,
    output wire       s_axi_awready,
    // AXI Lite Write Data Channel
    input wire [31:0] s_axi_wdata,
    input wire [3:0]  s_axi_wstrb,
    input wire        s_axi_wvalid,
    output wire       s_axi_wready,
    // AXI Lite Write Response
    output wire [1:0] s_axi_bresp,
    output wire       s_axi_bvalid,
    input wire        s_axi_bready,
    // AXI Lite Read Address Channel
    input wire [31:0] s_axi_araddr,
    input wire        s_axi_arvalid,
    output wire       s_axi_arready,
    // AXI Lite Read Data Channel
    output wire [31:0] s_axi_rdata,
    output wire        s_axi_rvalid,
    input wire         s_axi_rready,
    output wire  [1:0] s_axi_rresp,

    input wire rx, // sin
    output wire tx, // sout
    output wire irq,

    input wire rxsim_en,
    input wire [7:0]rxsim_data,
    output wire rxnew,
    output wire [7:0]rxdata
);
    wire [31:0]a;
    wire [31:0]d;
    wire       rd;
    wire       we;
    wire [31:0]spo;
    wire       ready;

    axil2mm axil2mm_inst (
        .s_axi_clk(s_axi_clk),
        .s_axi_aresetn(s_axi_aresetn),
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
    uart16550 #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .RESET_BAUD_RATE(RESET_BAUD_RATE),
        .FIFODEPTH(FIFODEPTH),
        .LENDIAN(LENDIAN),
        .SIM(SIM)
    ) uart16550_inst (
        .clk(s_axi_clk),
        .rst(!s_axi_aresetn),
        .a(a[4:2]),
        .d(d),
        .rd(rd),
        .we(we),
        .spo(spo),
        .ready(ready),
        .rx(rx),
        .tx(tx),
        .irq(irq),
        .rxsim_en(rxsim_en),
        .rxsim_data(rxsim_data),
        .rxnew(rxnew),
        .rxdata(rxdata)
    );
endmodule
