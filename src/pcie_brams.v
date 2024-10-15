//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
`timescale 1ps/1ps

module pcie_four_brams (
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
    .CASCADEINA(1'h0),
    .CASCADEINB(1'h0),
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
