/**
 * File              : axil_minimum.v
 * License           : GPL-3.0-or-later
 * Author            : Peter Gu <github.com/regymm>
 * Date              : 2024.11.20
 * Last Modified Date: 2024.11.20
 */
module axil_minimum(
	input clk,
	input rst_n,

	// Standard AXI Lite
    input  [31:0] s_axi_awaddr,
    input                  s_axi_awvalid,
    output reg                       s_axi_awready,

    input  [31:0]          s_axi_wdata,
    input  [3:0]           s_axi_wstrb,
    input                  s_axi_wvalid,
    output reg                       s_axi_wready,

    output reg       [1:0]           s_axi_bresp,
    output reg                       s_axi_bvalid,
    input                      s_axi_bready,

    input  [31:0] s_axi_araddr,
    input                  s_axi_arvalid,
    output reg                       s_axi_arready,

    output reg       [31:0]          s_axi_rdata = 0,
    output reg                       s_axi_rvalid,
    input                      s_axi_rready,
    output reg       [1:0]           s_axi_rresp
);

    // Memory and initialization
	reg [31:0]mem[255:0];
    integer i;
    initial begin
        // Initialize memory to zero
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h0;
        end
    end

	// Internal signals
    reg [31:0] write_address;
    reg [31:0] read_address;
    //reg        aw_en;

    // AXI Lite Write Address Channel
    always @(posedge clk) begin
        if (!rst_n) begin
			s_axi_awready <= 1'b1;
            //s_axi_awready <= 1'b0;
            //aw_en         <= 1'b1;
        end else begin
			if (s_axi_awvalid) begin
				write_address <= s_axi_awaddr;
			end
            //if (!s_axi_awready && s_axi_awvalid && aw_en) begin
                //s_axi_awready <= 1'b1;
                //write_address  <= s_axi_awaddr;
                //aw_en          <= 1'b0;
            //end else if (s_axi_wready && s_axi_wvalid && s_axi_awready) begin
                //s_axi_awready <= 1'b0;
            //end else begin
                //s_axi_awready <= 1'b0;
            //end
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
                s_axi_bvalid <= 1'b1;
                s_axi_bresp  <= 2'b00; // OKAY response
            end else if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
                //aw_en        <= 1'b1;
            end else begin
                s_axi_bvalid <= s_axi_bvalid;
            end
        end
    end

    // AXI Lite Read Address Channel
    always @(posedge clk) begin
        if (!rst_n) begin
			//s_axi_arready <= 1'b1;
			s_axi_arready <= 1'b0;
        end else begin
			//if (s_axi_arvalid) begin
				//read_address <= s_axi_araddr;
			//end
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
