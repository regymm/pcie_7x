// SPDX-License-Identifier: CERN-OHL-P
//
// Copyright 2022-2024 Wavelet Lab
//
// USDR PROJECT
// CLEAN
//
// Bus width 256 / 128 for ULTRA_SCALE and 64 bit for 7-series
//
// Multiple CplD to a single MemRd isn't supported, so we assume all MemRd <= MaxPayload
//
// Parameters
//  RELAX_TIMING: 1 - Adds bubbly cycles in AL bus but relaxes timing in PCIe AXI-S, 0 - no extra bubbles
//  ULTRA_SCALE:  1 - UltraScale+, 0 - 7-series 
//  EN64BIT:      1 - Enable MemRd64 & MemWr64 on 7-seeries, no effect on UltraScale
//
// Note: cfg_completer_id isn't used in US+ mode, PCIE4 core will fill it automatically in TLP
//
`default_nettype wire
module axis_pcie_to_al_us #(
    parameter ADDR_WIDTH = 10,
    parameter BUS_WIDTH = 128,
    parameter ULTRA_SCALE = 1,
    parameter TKEEP_WIDTH = BUS_WIDTH / 32,
    parameter SYNC_READ_WRITE = 1,
    parameter RELAX_TIMING = 0,
    parameter EN64BIT = 0,
    parameter DWISBE = 1'b1
)(
    input             clk,
    input             rst_n,

    // Configuration
    input  [15:0]                       cfg_completer_id,

    // AXI-S PCIe RX
    input  [BUS_WIDTH-1:0]              s_axis_rx_tdata,
    input  [TKEEP_WIDTH-1:0]            s_axis_rx_tkeep,
    input                               s_axis_rx_tlast,
    input                               s_axis_rx_tvalid,
    input  [87:0]                       s_axis_rx_tuser,
    output                              s_axis_rx_tready,

    // AXI-S PCIe TX
    input                               m_axis_tx_tready,
    output  reg [BUS_WIDTH-1:0]         m_axis_tx_tdata = 0,
    output  reg [TKEEP_WIDTH-1:0]       m_axis_tx_tkeep = 0,
    output  reg                         m_axis_tx_tlast = 0,
    output  reg                         m_axis_tx_tvalid = 0,
    output      [32:0]                  m_axis_tx_tuser,

    // AL Write channel
    output reg [ADDR_WIDTH - 1:2]       m_al_waddr = 0,
    output reg [31:0]                   m_al_wdata = 0,
    output reg                          m_al_wvalid,
    input                               m_al_wready,

    // AL Read address channel
    output reg [ADDR_WIDTH - 1:2]       m_al_araddr = 0,
    output reg                          m_al_arvalid,
    input                               m_al_arready,

    // AL Read data channel signals
    input [31:0]                        m_al_rdata,
    input                               m_al_rvalid,
    output                              m_al_rready
);

// 7-series AXI-S PCIe bytes are already swapped
function automatic [31:0] swap_bdw;
    input [31:0] indw;
    begin
        swap_bdw = (DWISBE && ULTRA_SCALE || !DWISBE && !ULTRA_SCALE) ? { indw[7:0], indw[15:8], indw[23:16], indw[31:24] } : indw;
    end
endfunction

assign m_axis_tx_tuser = 0;

//UltraScale TLP types
localparam [3:0]
    US_MEM_RD = 4'b000,
    US_MEM_WR = 4'b001;

// 7-Series PCIe TLP types
localparam [6:0]
    MEM_RD32_FMT_TYPE =      7'b00_00000,   // 3DW
    MEM_RD64_FMT_TYPE =      7'b01_00000,   // 4DW
    MEM_WR32_FMT_TYPE =      7'b10_00000,   // 3DW + data
    MEM_WR64_FMT_TYPE =      7'b11_00000,   // 4DW + data
    CPL_FMT_TYPE =           7'b00_01010,   // 3DW
    CPL_DATA_FMT_TYPE =      7'b10_01010;   // 3DW + data

// Common TLP types
localparam [1:0] 
    MEM_RD = 0,
    MEM_WR = 1,
    UNSUPPORTED = 2;

localparam REQA_WIDTH = (ADDR_WIDTH < 7) ? 7 : ADDR_WIDTH;
localparam MAX_BURST_LEN_DW = 8;

reg [15:0]                   pcie_req_id = 0;
reg [7:0]                    pcie_tag = 0;
reg [7:0]                    pcie_trg_func;
reg [2:0]                    pcie_tc = 0;
reg [1:0]                    pcie_attr = 0;
reg [MAX_BURST_LEN_DW-1:0]   pcie_len_dw = 0; // max 128 DW -> 512 bytes
reg [REQA_WIDTH-1:2]         pcie_req_addr = 0;
reg                          pcie_req_valid = 0;
wire                         pcie_req_ready;

wire        tlp_ep;
wire [1:0]  tlp_addr_type;
wire [63:2] tlp_addr;
wire [10:0] tlp_length;
wire [3:0]  tlp_req_type;
wire [15:0] tlp_req_id;
wire [7:0]  tlp_tag;
wire [7:0]  tlp_trg_func;
wire [2:0]  tlp_bar_id;
wire [5:0]  tlp_bar_apr;
wire [2:0]  tlp_tc;
wire [2:0]  tlp_attr;

wire [3:0]  tlp_fdwbe;
wire [3:0]  tlp_ldwbe;

wire [1:0]  tlp_common_type;

wire        tlp64bit;
generate 
if (ULTRA_SCALE) begin
    assign tlp_ep       = 0;
    assign tlp_addr_type= s_axis_rx_tdata[1:0];
    assign tlp_addr     = s_axis_rx_tdata[63:2];
    assign tlp_length   = s_axis_rx_tdata[74:64];
    assign tlp_req_type = s_axis_rx_tdata[78:75];
    assign tlp_req_id   = s_axis_rx_tdata[95:80];
    assign tlp_tag      = s_axis_rx_tdata[103:96];
    assign tlp_trg_func = s_axis_rx_tdata[111:104];
    assign tlp_bar_id   = s_axis_rx_tdata[114:112];
    assign tlp_bar_apr  = s_axis_rx_tdata[120:115];
    assign tlp_tc       = s_axis_rx_tdata[123:121];
    assign tlp_attr     = s_axis_rx_tdata[126:124];

    assign tlp_fdwbe    = s_axis_rx_tuser[3:0];
    assign tlp_ldwbe    = s_axis_rx_tuser[7:4];
    
    assign tlp_common_type =
        (tlp_req_type == US_MEM_RD) ? MEM_RD :
        (tlp_req_type == US_MEM_WR) ? MEM_WR : UNSUPPORTED;

    assign tlp64bit     = 1'b1;
    
    if (BUS_WIDTH != 128 && BUS_WIDTH != 256) begin
        //incorrect_us_bus_width module_error(.width(BUS_WIDTH));
    end
end else begin
    wire [1:0] tlp_fmt;
    wire [4:0] tlp_type;
    
    // Beat 0:
    assign tlp_length    = s_axis_rx_tdata[9:0];
    assign tlp_addr_type = s_axis_rx_tdata[11:10];
    assign tlp_attr   = 
        { s_axis_rx_tdata[18], s_axis_rx_tdata[13:12] };
    assign tlp_ep     = s_axis_rx_tdata[14];
    // assign tlp_dp     = s_axis_rx_tdata[15];
    // TH - 16
    // LN - 17
    //  reserved        s_axis_rx_tdata[19]
    assign tlp_tc     = s_axis_rx_tdata[22:20];
    //  reserved        s_axis_rx_tdata[23]
    assign tlp_type   = s_axis_rx_tdata[28:24];
    assign tlp_fmt    = s_axis_rx_tdata[30:29];
    //  reserved        s_axis_rx_tdata[31]
    assign tlp_fdwbe  = s_axis_rx_tdata[35:32];
    assign tlp_ldwbe  = s_axis_rx_tdata[39:36];
    assign tlp_tag    = s_axis_rx_tdata[47:40];
    assign tlp_req_id = s_axis_rx_tdata[63:48];
    
    assign tlp_common_type =
        ({tlp_fmt,tlp_type} == MEM_RD32_FMT_TYPE) ? MEM_RD :
        ({tlp_fmt,tlp_type} == MEM_WR32_FMT_TYPE) ? MEM_WR :
        (({tlp_fmt,tlp_type} == MEM_RD64_FMT_TYPE) && EN64BIT) ? MEM_RD :
        (({tlp_fmt,tlp_type} == MEM_WR64_FMT_TYPE) && EN64BIT) ? MEM_WR : UNSUPPORTED;
    assign tlp64bit   = (EN64BIT && tlp_fmt[0] == 1'b1);
    
    //Beat 1: ADDR32 or ADDR64
       
    if (BUS_WIDTH != 64) begin
        //incorrect_7s_bus_width module_error(.width(BUS_WIDTH));
    end
end
endgenerate

// byte_en [23:8] or [39:8]
// sop [40]
// discontinue [41]
// tph_preset
// tph_type[1:0]
// tph_st_tag[7:0]
// parity[31]

localparam [3:0] 
    TX_RESET = 0,
    TX_SKIP = 1,
    TX_HDR2_TX32 = 4,
    TX_HDR2_TX64 = 5,
    TX_HDR2_RX32 = 6,
    TX_HDR2_RX64 = 7,
    TX_DW0 = 8,
    TX_DW1 = 9,
    TX_DW2 = 10,
    TX_DW3 = 11,
    TX_DW4 = 12,
    TX_DW5 = 13,
    TX_DW6 = 14,
    TX_DW7 = 15;
reg [3:0] state;

wire last_dw_in_transfer = (
    BUS_WIDTH == 256 && (state == TX_DW7 ? 1'b1 : s_axis_rx_tlast && ~s_axis_rx_tkeep[state - TX_DW0 + 1'b1]) ||
    BUS_WIDTH == 128 && (state == TX_DW3 ? 1'b1 : s_axis_rx_tlast && ~s_axis_rx_tkeep[state - TX_DW0 + 1'b1]) ||
    BUS_WIDTH == 64 && (state == TX_DW1 ? 1'b1 : s_axis_rx_tlast && ~s_axis_rx_tkeep[1'b1]));

wire pcie_core_rx_ready = (~pcie_req_valid || (!RELAX_TIMING && pcie_req_ready));
wire pcie_core_tx_ready = (~m_al_wvalid    || (!RELAX_TIMING && m_al_wready));
wire pcie_core_ready = 
        SYNC_READ_WRITE ? pcie_core_rx_ready && pcie_core_tx_ready :
        (tlp_common_type == MEM_WR) ? pcie_core_tx_ready :
        (tlp_common_type == MEM_RD) ? pcie_core_rx_ready : 1'b1;
        
wire pcie_b256_single_dw = s_axis_rx_tlast ;//&& !s_axis_rx_tkeep[5]; // s_axis_rx_tkeep[5] doesn't exist. It causes problem with nextpnr
assign s_axis_rx_tready = (state == TX_RESET && ((BUS_WIDTH == 256 ? pcie_b256_single_dw : 1'b1) && pcie_core_ready)) ||
                          (state == TX_SKIP)   ||
                          (state == TX_HDR2_TX32 || state == TX_HDR2_TX64)   ||
                          (state == TX_HDR2_RX32 || state == TX_HDR2_RX64)   ||
                          ((state >= TX_DW0) && (last_dw_in_transfer) && (!m_al_wvalid || m_al_wready));

wire valid32bit_tlp_req = (tlp_ep == 1'b0 && tlp_fdwbe == 4'hF);
reg tx_inc_addr = 0;

generate 
if (!ULTRA_SCALE) begin
assign tlp_addr     = (EN64BIT && (state == TX_HDR2_TX64 || state == TX_HDR2_RX64)) ?
       { s_axis_rx_tdata[31:0], s_axis_rx_tdata[63:34] } : { 32'h0, s_axis_rx_tdata[31:2] };
end
endgenerate

always @( posedge clk ) begin
  if (!rst_n) begin
    m_al_wvalid      <= 1'b0;
    pcie_req_valid   <= 1'b0;
    
    state            <= TX_RESET;
  end else begin
    if (m_al_wready && m_al_wvalid) begin
      m_al_wvalid <= 1'b0;
    end
    
    if (pcie_req_valid && pcie_req_ready) begin
      pcie_req_valid <= 1'b0;
    end

    case (state)
    TX_RESET: begin
      if (pcie_core_ready && s_axis_rx_tvalid) begin
        case (tlp_common_type)
        MEM_WR: begin
          if (valid32bit_tlp_req) begin           
            if (BUS_WIDTH == 256) begin
                m_al_wdata       <= swap_bdw(s_axis_rx_tdata[159:128]);
                m_al_waddr       <= tlp_addr[ADDR_WIDTH - 1:2];
                m_al_wvalid      <= 1'b1;
                tx_inc_addr      <= 1'b1;
                state            <= (pcie_b256_single_dw) ? TX_RESET : TX_DW5;
            end else if (BUS_WIDTH == 128) begin
                m_al_waddr       <= tlp_addr[ADDR_WIDTH - 1:2];
                tx_inc_addr      <= 1'b0;
                state            <= TX_DW0;
            end else if (BUS_WIDTH == 64) begin
                tx_inc_addr      <= 1'b0;
                state            <= tlp64bit ? TX_HDR2_TX64 : TX_HDR2_TX32;
            end
            
          end else begin
            state <= s_axis_rx_tlast ? TX_RESET : TX_SKIP;
          end
        end
        
        MEM_RD: begin
          pcie_trg_func <= tlp_trg_func;
          pcie_req_id   <= tlp_req_id;
          pcie_tag      <= tlp_tag;
          pcie_tc       <= tlp_tc;
          pcie_attr     <= tlp_attr;
          pcie_len_dw   <= tlp_length[MAX_BURST_LEN_DW-1:0]; // holds up to 128DW == 512 Bytes
            
          if (BUS_WIDTH == 64) begin
            state         <= !valid32bit_tlp_req ? TX_SKIP : tlp64bit ? TX_HDR2_RX64 : TX_HDR2_RX32;
          end else begin
            pcie_req_valid<= valid32bit_tlp_req;
            pcie_req_addr <= tlp_addr[REQA_WIDTH-1:2];
            state         <= s_axis_rx_tlast ? TX_RESET : TX_SKIP;
          end
        end

        default: begin
          state <= s_axis_rx_tlast ? TX_RESET : TX_SKIP;
        end
        
        endcase
      end
    end // TX_RESET

    TX_SKIP: begin
      if (s_axis_rx_tlast && s_axis_rx_tvalid) begin
        state <= TX_RESET;
      end
    end
    
    TX_HDR2_RX32, TX_HDR2_RX64: begin
        if (s_axis_rx_tready && s_axis_rx_tvalid && !ULTRA_SCALE) begin
            pcie_req_valid <= 1'b1;
            pcie_req_addr  <= tlp_addr[ADDR_WIDTH - 1:2];
            state          <= TX_RESET;
        end
    end
    
    TX_HDR2_TX32, TX_HDR2_TX64: begin
        if (s_axis_rx_tready && s_axis_rx_tvalid && !ULTRA_SCALE) begin
            m_al_waddr     <= tlp_addr[ADDR_WIDTH - 1:2];
            
            if (state == TX_HDR2_TX64) begin
                tx_inc_addr      <= 1'b0;
                state            <= TX_DW0;
            end else begin
                m_al_wdata       <= swap_bdw(s_axis_rx_tdata[63:32]);
                m_al_wvalid      <= 1'b1;
                tx_inc_addr      <= 1'b1;
                state            <= s_axis_rx_tlast ? TX_RESET : TX_DW0;
            end
        end
    end

    default: begin
      if (s_axis_rx_tvalid && (!m_al_wvalid || m_al_wready)) begin
        tx_inc_addr    <= 1'b1;
        m_al_waddr     <= m_al_waddr + tx_inc_addr;
        
        if (BUS_WIDTH == 256) begin
            m_al_wdata   <= swap_bdw(
                state == TX_DW0 ? s_axis_rx_tdata[31:0] :
                state == TX_DW1 ? s_axis_rx_tdata[63:32] :
                state == TX_DW2 ? s_axis_rx_tdata[95:64] :
                state == TX_DW3 ? s_axis_rx_tdata[127:96] :
                state == TX_DW4 ? s_axis_rx_tdata[159:128] :
                state == TX_DW5 ? s_axis_rx_tdata[191:160] :
                state == TX_DW6 ? s_axis_rx_tdata[223:192] : s_axis_rx_tdata[255:224]);
        end else if (BUS_WIDTH == 128) begin
            m_al_wdata   <= swap_bdw(
                state == TX_DW0 ? s_axis_rx_tdata[31:0] :
                state == TX_DW1 ? s_axis_rx_tdata[63:32] :
                state == TX_DW2 ? s_axis_rx_tdata[95:64] : s_axis_rx_tdata[127:96]);
        end else begin
            m_al_wdata   <=  swap_bdw(state == TX_DW0 ? s_axis_rx_tdata[31:0] : s_axis_rx_tdata[63:32]);
        end
        
        m_al_wvalid <= 1'b1;

        if (last_dw_in_transfer) begin
            state <= s_axis_rx_tlast ? TX_RESET : TX_DW0;
        end else begin
            state <= state + 1'b1;
        end
        
      end
    end
    endcase
    
  end
end
    
reg [3:0]   rx_state;
localparam [3:0] 
    RX_RESET = 0,
    RX_HDR2 = 9,
    RX_DW0 = 1,
    RX_DW1 = 2,
    RX_DW2 = 3,
    RX_DW3 = 4,
    RX_DW4 = 5,
    RX_DW5 = 6,
    RX_DW6 = 7,
    RX_DW7 = 8;

reg pcie_req_processed;
assign pcie_req_ready = pcie_req_processed;

reg [MAX_BURST_LEN_DW-1:0]            pcie_len_dw_rd = 0;
reg [MAX_BURST_LEN_DW-1:0]            pcie_len_dw_rb = 0;
wire rx_last_dw_in_lane = (BUS_WIDTH == 256 && rx_state == RX_DW7 || BUS_WIDTH == 128 && rx_state == RX_DW3 || BUS_WIDTH == 64 && rx_state == RX_DW1);
wire rx_last_transfer = (pcie_len_dw_rb == 1);

assign m_al_rready = (~m_axis_tx_tvalid || m_axis_tx_tready);

always @( posedge clk ) begin
  if (!rst_n) begin
    rx_state           <= RX_RESET;
    m_axis_tx_tvalid   <= 1'b0;
    m_al_arvalid       <= 1'b0;
    pcie_req_processed <= 1'b0;
  end else begin
    if (m_al_arvalid && m_al_arready) begin
        pcie_len_dw_rd <= pcie_len_dw_rd - 1'b1;
        m_al_araddr    <= m_al_araddr + 1'b1;
        m_al_arvalid   <= (pcie_len_dw_rd != 1);
    end
    
    if (m_axis_tx_tvalid && m_axis_tx_tready) begin
        m_axis_tx_tvalid <= 1'b0;
    end
    
    if (pcie_req_processed && pcie_req_valid) begin
        pcie_req_processed <= 1'b0;
    end
  
    case (rx_state)
    RX_RESET: begin
        if (pcie_req_valid && ~pcie_req_processed && (~m_al_arvalid || m_al_arready) && (~m_axis_tx_tvalid || m_axis_tx_tready)) begin
            pcie_len_dw_rd <= pcie_len_dw;
            pcie_len_dw_rb <= pcie_len_dw;
            m_al_araddr    <= pcie_req_addr;
            m_al_arvalid   <= 1'b1;
            
            if (ULTRA_SCALE) begin
                // Completion header (3 DWs)
                m_axis_tx_tdata[6:0]   <= { pcie_req_addr[6:2], 2'b00 };
                m_axis_tx_tdata[7]     <= 1'b0;  //Reserved
                m_axis_tx_tdata[9:8]   <= 2'b00; //Address type
                m_axis_tx_tdata[15:10] <= 6'h0;
                m_axis_tx_tdata[28:16] <= { pcie_len_dw, 2'b00 };
                m_axis_tx_tdata[29]    <= 0;
                m_axis_tx_tdata[30]    <= 0;
                m_axis_tx_tdata[31]    <= 0;
                m_axis_tx_tdata[42:32] <= pcie_len_dw;
                m_axis_tx_tdata[45:43] <= 3'b000; // Successful completion
                m_axis_tx_tdata[46]    <= 1'b0;
                m_axis_tx_tdata[47]    <= 1'b0;
                m_axis_tx_tdata[63:48] <= pcie_req_id;
                m_axis_tx_tdata[71:64] <= pcie_tag;
                m_axis_tx_tdata[79:72] <= pcie_trg_func;
                m_axis_tx_tdata[87:80] <= 0; //Completer Bus Number
                m_axis_tx_tdata[88]    <= 1'b0;
                m_axis_tx_tdata[91:89] <= pcie_tc;
                m_axis_tx_tdata[94:92] <= pcie_attr;
                m_axis_tx_tdata[95]    <= 1'b0;
                
                m_axis_tx_tlast        <= 1'b0;
                rx_state               <= RX_DW3;
                pcie_req_processed     <= !SYNC_READ_WRITE;
            end else begin
                m_axis_tx_tdata[63:32] <= { cfg_completer_id, 3'b000, 1'b0, { 2'b0, pcie_len_dw, 2'b0 }};
                m_axis_tx_tdata[31:0]  <= { 1'b0, CPL_DATA_FMT_TYPE, 1'b0, pcie_tc, 4'b0, 1'b0, 1'b0, pcie_attr[1:0], 2'b0, { 2'b0, pcie_len_dw } };
                m_axis_tx_tlast        <= 1'b0;
                m_axis_tx_tkeep   <= 2'b11;
                m_axis_tx_tvalid       <= 1'b1;
                rx_state               <= RX_HDR2;
            end
        end
    end
    
    RX_HDR2: begin
        if (m_al_rvalid && m_al_rready && !ULTRA_SCALE) begin
            m_axis_tx_tdata[63:0]  <= { swap_bdw(m_al_rdata),
                                        pcie_req_id, pcie_tag, 1'b0, pcie_req_addr[6:2], 2'b0 };
            m_axis_tx_tkeep   <= 2'b11;
            m_axis_tx_tvalid       <= 1'b1;
            
            pcie_len_dw_rb         <= pcie_len_dw_rb - 1'b1;
            m_axis_tx_tlast        <= rx_last_transfer;
            
            rx_state               <= rx_last_transfer ? RX_RESET : RX_DW0; 
            pcie_req_processed     <= !SYNC_READ_WRITE ? 1'b1 : rx_last_transfer ? 1'b1 : 1'b0; 
        end
    end
    
    default: begin
        if (m_al_rvalid && m_al_rready) begin
            
            case (rx_state)
            RX_DW0: begin m_axis_tx_tdata[31:0]    <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 1'b1; end
            RX_DW1: begin m_axis_tx_tdata[63:32]   <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 2'b11; end
            endcase
            
            if (BUS_WIDTH >= 128) case (rx_state)
            RX_DW2: begin m_axis_tx_tdata[95:64]   <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 3'b111; end
            RX_DW3: begin m_axis_tx_tdata[127:96]  <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 4'b1111; end
            endcase
            
            if (BUS_WIDTH >= 256) case (rx_state)
            RX_DW4: begin m_axis_tx_tdata[159:128] <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 5'b11111; end
            RX_DW5: begin m_axis_tx_tdata[191:160] <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 6'b111111; end
            RX_DW6: begin m_axis_tx_tdata[223:192] <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 7'b1111111; end
            RX_DW7: begin m_axis_tx_tdata[255:224] <= swap_bdw(m_al_rdata); m_axis_tx_tkeep   <= 8'b11111111; end
            endcase
            
            pcie_len_dw_rb     <= pcie_len_dw_rb - 1'b1;
            m_axis_tx_tlast    <= rx_last_transfer;
            pcie_req_processed <= 1'b0;
            
            if (rx_last_transfer) begin 
                m_axis_tx_tvalid   <= 1'b1;
                rx_state           <= RX_RESET;
                pcie_req_processed <= SYNC_READ_WRITE;
            end else if (rx_last_dw_in_lane) begin
                m_axis_tx_tvalid   <= 1'b1;
                rx_state           <= RX_DW0;
            end else begin
                rx_state           <= rx_state + 1'b1;
            end
        end
    end
    
    endcase

  end
end



endmodule
