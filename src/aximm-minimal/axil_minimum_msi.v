// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
module axil_minimum_msi (
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
    output reg       [1:0] s_axi_rresp,

    input                  msi_enable,
    output             reg intx_msi_request,
    input                  intx_msi_grant,
    input            [2:0] msi_vector_width,
    output           [4:0] msi_vector_num
);

    reg [31:0]counter = 0;
    always @ (posedge clk) begin
        if (!rst_n) counter <= 0;
        else counter <= counter + 1;
    end

    // periodical interrupt
    wire interrupt = counter[25:0] == 26'h3FFFFFF;

    // BAR memory accessible, unused
    reg [31:0]tmp_in = 0;
    assign msi_vector_num = tmp_in[4:0];

    reg [31:0]tmp_out = 0;
    always @ (posedge clk) begin
        if (!rst_n) tmp_out <= 0;
        else tmp_out <= {msi_enable, msi_vector_width, intx_msi_request, intx_msi_grant, counter[25:0]};
        //else tmp_out <= {msi_enable, msi_vector_width, intx_msi_request, intx_msi_grant, 10'b0, 16'hABCD};
    end

    // request and wait to deassert until core reply
    always @ (posedge clk) begin
        if (!rst_n)
            intx_msi_request <= 1'b0;
        else begin
            if (intx_msi_request) begin
                if (intx_msi_grant)
                    intx_msi_request <= 1'b0;
            end else if (msi_enable & interrupt) begin
                intx_msi_request <= 1'b1;
            end
        end
    end

    // AXI Lite Unused
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_awready <= 1'b1;
            s_axi_arready <= 1'b1;
            s_axi_wready <= 1'b1;
            s_axi_bresp  <= 2'b00;
            s_axi_rresp  <= 2'b00;
        end
    end

    // Write Operation
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_bvalid <= 1'b0;
            tmp_in <= 32'b0;
        end else begin
            if (s_axi_wready && s_axi_wvalid) begin
                tmp_in <= {s_axi_wdata[7:0], s_axi_wdata[15:8], s_axi_wdata[23:16], s_axi_wdata[31:24]};
                s_axi_bvalid <= 1'b1;
            end else if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end
        end
    end

    // Read Operation
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_rvalid <= 1'b0;
        end else begin
            if (s_axi_arready && s_axi_arvalid) begin
                s_axi_rdata  <= {tmp_out[7:0], tmp_out[15:8], tmp_out[23:16], tmp_out[31:24]};
                s_axi_rvalid <= 1'b1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end
        end
	end
endmodule
