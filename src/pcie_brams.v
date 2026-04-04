// SPDX-License-Identifier: CERN-OHL-P
// Copyright 2024 regymm
`timescale 1ps/1ps

module pcie_four_brams #(
    parameter DEPTH = 11
) (
	input          user_clk_i,
	input          reset_i,

	input          wen,
	input  [12:0]  waddr,
	input  [71:0]  wdata,
	input          ren,
	input          rce,
	input  [12:0]  raddr,
	output [71:0]  rdata
);
	reg [71:0]rdata0;
	reg [71:0]rdata1;
    // TODO: before nextpnr-xilinx BRAM support is investigated, use dist. ram instead. 
	/*(* ram_style = "distributed" *)*/ reg [71:0]ram[2**DEPTH-1:0]; // VC0_RX_RAM_LIMIT 7FF -> 11 bits
	always @ (posedge user_clk_i) begin
		if (wen)
			ram[waddr] <= wdata;
		if (ren)
			//if (waddr != raddr)
				rdata0 <= ram[raddr];
			//else
				//rdata0 <= wdata;
		rdata1 <= rdata0;
	end
	assign rdata = rdata1;
	/*
	one_bram ramb36_0(
		.DOA            (),
		.DOB            (rdata[17:0]),
		.ADDRA          (waddr[10:0]),
		.ADDRB          (raddr[10:0]),
		.CLKA           (user_clk_i),
		.CLKB           (user_clk_i),
		.DIA            (wdata[17:0]),
		.DIB            (2'b00),
		.ENA            (wen),
		.ENB            (ren),
		.REGCEA         (1'b0),
		.REGCEB         (1'b1),
		.RSTA           (1'b0),
		.RSTB           (1'b0),
		.WEA            (2'b11),
		.WEB            (2'b00)
	);
	one_bram ramb36_1(
		.DOA            (),
		.DOB            (rdata[35:18]),
		.ADDRA          (waddr[10:0]),
		.ADDRB          (raddr[10:0]),
		.CLKA           (user_clk_i),
		.CLKB           (user_clk_i),
		.DIA            (wdata[35:18]),
		.DIB            (2'b00),
		.ENA            (wen),
		.ENB            (ren),
		.REGCEA         (1'b0),
		.REGCEB         (1'b1),
		.RSTA           (1'b0),
		.RSTB           (1'b0),
		.WEA            (2'b11),
		.WEB            (2'b00)
	);
	one_bram ramb36_2(
		.DOA            (),
		.DOB            (rdata[53:36]),
		.ADDRA          (waddr[10:0]),
		.ADDRB          (raddr[10:0]),
		.CLKA           (user_clk_i),
		.CLKB           (user_clk_i),
		.DIA            (wdata[53:36]),
		.DIB            (2'b00),
		.ENA            (wen),
		.ENB            (ren),
		.REGCEA         (1'b0),
		.REGCEB         (1'b1),
		.RSTA           (1'b0),
		.RSTB           (1'b0),
		.WEA            (2'b11),
		.WEB            (2'b00)
	);
	one_bram ramb36_3(
		.DOA            (),
		.DOB            (rdata[71:54]),
		.ADDRA          (waddr[10:0]),
		.ADDRB          (raddr[10:0]),
		.CLKA           (user_clk_i),
		.CLKB           (user_clk_i),
		.DIA            (wdata[71:54]),
		.DIB            (2'b00),
		.ENA            (wen),
		.ENB            (ren),
		.REGCEA         (1'b0),
		.REGCEB         (1'b1),
		.RSTA           (1'b0),
		.RSTB           (1'b0),
		.WEA            (2'b11),
		.WEB            (2'b00)
	);
	*/
endmodule

module one_bram(DOA, DOB, ADDRA, ADDRB, CLKA, CLKB, DIA, DIB, ENA, ENB, REGCEA, REGCEB, RSTA, RSTB, WEA, WEB);
  input [10:0] ADDRA;
  input [10:0] ADDRB;
  input CLKA;
  input CLKB;
  input [17:0] DIA;
  input [17:0] DIB;
  output [17:0] DOA;
  output [17:0] DOB;
  input ENA;
  input ENB;
  input REGCEA;
  input REGCEB;
  input RSTA;
  input RSTB;
  input [1:0] WEA;
  input [1:0] WEB;
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .RAM_MODE("TDP"),
    .READ_WIDTH_A(18),
    .READ_WIDTH_B(18),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(0),
    .SRVAL_B(0),
    .WRITE_MODE_A("NO_CHANGE"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(18),
    .WRITE_WIDTH_B(18)
  ) bram36_tdp_bl (
    .ADDRARDADDR({ 1'h1, ADDRA, 4'hf }),
    .ADDRBWRADDR({ 1'h1, ADDRB, 4'hf }),
    //.CASCADEINA(1'h0),
    //.CASCADEINB(1'h0),
    .CLKARDCLK(CLKA),
    .CLKBWRCLK(CLKB),
    .DIADI({ DIA[16:9], DIA[7:0] }),
    .DIBDI({ DIB[16:9], DIB[7:0] }),
    .DIPADIP({ 2'h0, DIA[17], DIA[8] }),
    .DIPBDIP({ 2'h0, DIB[17], DIB[8] }),
    .DOADO({ DOA[16:9], DOA[7:0] }),
    .DOBDO({ DOB[16:9], DOB[7:0] }),
    .DOPADOP({ DOA[17], DOA[8] }),
    .DOPBDOP({ DOB[17], DOB[8] }),
    .ENARDEN(ENA),
    .ENBWREN(ENB),
    .INJECTDBITERR(1'h0),
    .INJECTSBITERR(1'h0),
    .REGCEAREGCE(REGCEA),
    .REGCEB(REGCEB),
    .RSTRAMARSTRAM(RSTA),
    .RSTRAMB(RSTB),
    .RSTREGARSTREG(1'h0),
    .RSTREGB(RSTB),
    .WEA({ WEA, WEA }),
    .WEBWE({ 4'h0, WEB, WEB })
  );
endmodule
