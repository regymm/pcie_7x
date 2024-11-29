// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
`default_nettype wire
module axil_to_al #(
    parameter ADDR_WIDTH = 32
)(

	input clk,
	input rst_n,

	// Standard AXI Lite
    output reg  [ADDR_WIDTH-1:0] s_axi_awaddr,
    output reg                  s_axi_awvalid,
    input                       s_axi_awready,

    output reg  [31:0]          s_axi_wdata,
    output reg  [3:0]           s_axi_wstrb,
    output reg                  s_axi_wvalid,
    input                       s_axi_wready,

    input       [1:0]           s_axi_bresp,
    input                       s_axi_bvalid,
    output                      s_axi_bready,

    output reg  [ADDR_WIDTH-1:0] s_axi_araddr,
    output reg                  s_axi_arvalid,
    input                       s_axi_arready,

    input       [31:0]          s_axi_rdata,
    input                       s_axi_rvalid,
    output                      s_axi_rready,
    input       [1:0]           s_axi_rresp,

    // AL Write channel
    input     [ADDR_WIDTH - 1:2]       m_al_waddr,
    input     [31:0]                   m_al_wdata,
    input                              m_al_wvalid,
    output reg                         m_al_wready,

    // AL Read address channel
    input     [ADDR_WIDTH - 1:2]       m_al_araddr,
    input                              m_al_arvalid,
    output reg                         m_al_arready,

    // AL Read data channel signals
    output reg [31:0]                  m_al_rdata,
    output reg                         m_al_rvalid,
    input                              m_al_rready
);

    // Internal state variables
    reg write_in_progress;
    reg read_in_progress;

    // Assignments for ready signals
    assign s_axi_bready = 1'b1;    // Always ready to accept write responses
    assign s_axi_rready = 1'b1;    // Always ready to accept read data

    // Write Transaction Handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset signals
            s_axi_awaddr     <= {ADDR_WIDTH{1'b0}};
            s_axi_awvalid    <= 1'b0;
            s_axi_wdata      <= 32'b0;
            s_axi_wstrb      <= 4'b1111;
            s_axi_wvalid     <= 1'b0;
            m_al_wready      <= 1'b1;
            write_in_progress <= 1'b0;
        end else begin
            if (!write_in_progress) begin
                if (m_al_wvalid && m_al_wready) begin
                    // Start write transaction
                    s_axi_awaddr  <= {m_al_waddr, 2'b00};  // Convert word address to byte address
                    s_axi_awvalid <= 1'b1;
                    s_axi_wdata   <= m_al_wdata;
                    s_axi_wvalid  <= 1'b1;
                    s_axi_wstrb   <= 4'b1111;              // All bytes are valid
                    m_al_wready   <= 1'b0;                 // Wait until write transaction is complete
                    write_in_progress <= 1'b1;
                end
            end else begin
                // Write address handshake
                if (s_axi_awvalid && s_axi_awready) begin
                    s_axi_awvalid <= 1'b0;
                end

                // Write data handshake
                if (s_axi_wvalid && s_axi_wready) begin
                    s_axi_wvalid <= 1'b0;
                end

                // Write response handling
                if (s_axi_bvalid && s_axi_bready) begin
                    // Transaction complete
                    write_in_progress <= 1'b0;
                    m_al_wready <= 1'b1;  // Ready to accept next write request
                    // Optionally, you can check s_axi_bresp for errors
                end
            end
        end
    end

    // Read Transaction Handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset signals
            s_axi_araddr      <= {ADDR_WIDTH{1'b0}};
            s_axi_arvalid     <= 1'b0;
            m_al_arready      <= 1'b1;
            m_al_rdata        <= 32'b0;
            m_al_rvalid       <= 1'b0;
            read_in_progress  <= 1'b0;
        end else begin
            if (!read_in_progress) begin
                if (m_al_arvalid && m_al_arready) begin
                    // Start read transaction
                    s_axi_araddr   <= {m_al_araddr, 2'b00};  // Convert word address to byte address
                    s_axi_arvalid  <= 1'b1;
                    m_al_arready   <= 1'b0;                  // Wait until read transaction is complete
                    read_in_progress <= 1'b1;
                end
            end else begin
                // Read address handshake
                if (s_axi_arvalid && s_axi_arready) begin
                    s_axi_arvalid <= 1'b0;
                end

                // Read data handling
                if (s_axi_rvalid && s_axi_rready) begin
                    m_al_rdata  <= s_axi_rdata;
                    m_al_rvalid <= 1'b1;
                end

                // Custom interface read data handshake
                if (m_al_rvalid && m_al_rready) begin
                    m_al_rvalid      <= 1'b0;
                    m_al_arready     <= 1'b1;  // Ready to accept next read request
                    read_in_progress <= 1'b0;
                    // Optionally, you can check s_axi_rresp for errors
                end
            end
        end
	end

endmodule
