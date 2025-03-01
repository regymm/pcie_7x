// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
module axil_minimum(
	input clk,
	input rst_n,

	// Standard AXI Lite
    input           [31:0] s_axi_awaddr,
    input                  s_axi_awvalid,
    output reg             s_axi_awready,

    input           [31:0] s_axi_wdata,
    input            [3:0] s_axi_wstrb,
    input                  s_axi_wvalid,
    output reg             s_axi_wready,

    output reg       [1:0] s_axi_bresp,
    output reg             s_axi_bvalid,
    input                  s_axi_bready,

    input           [31:0] s_axi_araddr,
    input                  s_axi_arvalid,
    output reg             s_axi_arready,

    output reg      [31:0] s_axi_rdata = 0,
    output reg             s_axi_rvalid,
    input                  s_axi_rready,
    output reg       [1:0] s_axi_rresp
);

    // Memory and initialization
    // mem uses BRAM or DRAM, tmp uses just LUT
    // ram_style: block or distributed
    (* ram_style = "distributed" *)reg [31:0]mem[255:0];
    integer i;
    initial begin
        // Initialize memory to zero
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h12345678;
        end
    end
    reg [31:0]tmp = 32'h11223344;

    // Internal signals
    reg [31:0] write_address;
    reg [31:0] read_address;

    // AXI Lite Write Address Channel
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_awready <= 1'b1;
        end else begin
			if (s_axi_awvalid) begin
				write_address <= s_axi_awaddr;
			end
        end
    end

    // AXI Lite Write Data Channel
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_wready <= 1'b0;
        end else begin
            if (!s_axi_wready && s_axi_wvalid) begin
                s_axi_wready <= 1'b1;
            end else begin
                s_axi_wready <= 1'b0;
            end
        end
    end

    // Write Operation
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_bvalid <= 1'b0;
            s_axi_bresp  <= 2'b00;
        end else begin
            if (s_axi_wready && s_axi_wvalid) begin
            //if (s_axi_awready && s_axi_awvalid && s_axi_wready && s_axi_wvalid) begin
                // Perform write operation
                // Address decoding
                // Assuming 4-byte aligned addresses
                mem[write_address[9:2]] <= s_axi_wdata;
                tmp <= s_axi_wdata;
                s_axi_bvalid <= 1'b1;
                s_axi_bresp  <= 2'b00; // OKAY response
            end else if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end else begin
                s_axi_bvalid <= s_axi_bvalid;
            end
        end
    end

    // AXI Lite Read Address Channel
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_arready <= 1'b0;
        end else begin
            if (!s_axi_arready && s_axi_arvalid) begin
                s_axi_arready <= 1'b1;
                read_address   <= s_axi_araddr;
            end else begin
                s_axi_arready <= 1'b0;
            end
        end
    end

    // Read Operation
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_rvalid <= 1'b0;
            s_axi_rresp  <= 2'b00;
        end else begin
            if (s_axi_arready && s_axi_arvalid) begin
                // Perform read operation
                // Address decoding
                // Assuming 4-byte aligned addresses
                s_axi_rdata  <= mem[read_address[9:2]];
                //s_axi_rdata  <= tmp;
                s_axi_rvalid <= 1'b1;
                s_axi_rresp  <= 2'b00; // OKAY response
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end else begin
                s_axi_rvalid <= s_axi_rvalid;
            end
        end
	end
endmodule
