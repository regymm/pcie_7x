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
`timescale 1ns / 1ps

// 100 MHz ref clock, 1 lane, Gen1
module pipe_clock # (
    parameter PCIE_USERCLK1_FREQ = 2,
    parameter PCIE_USERCLK2_FREQ = 2
)(
    //---------- Input -------------------------------------
    input                       CLK_TXOUTCLK,
    input                       CLK_RST_N,
    //---------- Output ------------------------------------
    output                      CLK_PCLK,
    output                      CLK_RXUSRCLK,
    output                      CLK_DCLK,
    output                      CLK_OOBCLK,
    output                      CLK_USERCLK1,
    output                      CLK_USERCLK2,
    output                      CLK_MMCM_LOCK
);
    //---------- Select Clock Divider ----------------------
    localparam          CLKOUT2_DIVIDE   = (PCIE_USERCLK1_FREQ == 5) ?  2 : 
                                           (PCIE_USERCLK1_FREQ == 4) ?  4 :
                                           (PCIE_USERCLK1_FREQ == 3) ?  8 :
                                           (PCIE_USERCLK1_FREQ == 1) ? 32 : 16;
    localparam          CLKOUT3_DIVIDE   = (PCIE_USERCLK2_FREQ == 5) ?  2 : 
                                           (PCIE_USERCLK2_FREQ == 4) ?  4 :
                                           (PCIE_USERCLK2_FREQ == 3) ?  8 :
                                           (PCIE_USERCLK2_FREQ == 1) ? 32 : 16;

BUFG txoutclk_i (
	.I                          (CLK_TXOUTCLK),
	.O                          (refclk)
);

	//wire                            clk_250mhz;
	//wire                            oobclk;
	wire                            refclk;
	wire                            clk_125mhz;
	wire                            mmcm_fb;
	wire                            userclk1;
	wire                            userclk2;
	MMCME2_ADV # (
		.BANDWIDTH                  ("OPTIMIZED"),
		.CLKOUT4_CASCADE            ("FALSE"),
		.COMPENSATION               ("ZHOLD"),
		.STARTUP_WAIT               ("FALSE"),
		.DIVCLK_DIVIDE              (1), // nothign
		.CLKFBOUT_MULT_F            (10),  // 100 * 10 = 1000
		.CLKFBOUT_PHASE             (0.000),
		.CLKFBOUT_USE_FINE_PS       ("FALSE"),
		.CLKOUT0_DIVIDE_F           (8), // 125 MHz
		.CLKOUT0_PHASE              (0.000),
		.CLKOUT0_DUTY_CYCLE         (0.500),
		.CLKOUT0_USE_FINE_PS        ("FALSE"),
		.CLKOUT1_DIVIDE             (4), // 250 MHz
		.CLKOUT1_PHASE              (0.000),
		.CLKOUT1_DUTY_CYCLE         (0.500),
		.CLKOUT1_USE_FINE_PS        ("FALSE"),
		.CLKOUT2_DIVIDE             (CLKOUT2_DIVIDE), // 16 -> 62.5 MHz
		.CLKOUT2_PHASE              (0.000),
		.CLKOUT2_DUTY_CYCLE         (0.500),
		.CLKOUT2_USE_FINE_PS        ("FALSE"),
		.CLKOUT3_DIVIDE             (CLKOUT3_DIVIDE),                  
		.CLKOUT3_PHASE              (0.000),
		.CLKOUT3_DUTY_CYCLE         (0.500),
		.CLKOUT3_USE_FINE_PS        ("FALSE"),
		.CLKOUT4_DIVIDE             (20), // 50 MHz
		.CLKOUT4_PHASE              (0.000),
		.CLKOUT4_DUTY_CYCLE         (0.500),
		.CLKOUT4_USE_FINE_PS        ("FALSE"),
		.CLKIN1_PERIOD              (10), // 100 MHz, 10 ns
		.REF_JITTER1                (0.010)
	) mmcm_i (
		.CLKIN1                     (refclk),
		.CLKIN2                     (1'd0),                     // not used, comment out CLKIN2 if it cause implementation issues
	  //.CLKIN2                     (refclk),                   // not used, comment out CLKIN2 if it cause implementation issues
		.CLKINSEL                   (1'd1),
		.CLKFBIN                    (mmcm_fb),
		.RST                        (!CLK_RST_N),
		.PWRDWN                     (1'd0), 
		//---------- Output ------------------------------------
		.CLKFBOUT                   (mmcm_fb),
		.CLKFBOUTB                  (),
		.CLKOUT0                    (clk_125mhz),
		.CLKOUT0B                   (),
		.CLKOUT1                    (), // clk_250mhz
		.CLKOUT1B                   (),
		.CLKOUT2                    (userclk1),
		.CLKOUT2B                   (),
		.CLKOUT3                    (userclk2),
		.CLKOUT3B                   (),
		.CLKOUT4                    (), // oobclk
		.CLKOUT5                    (),
		.CLKOUT6                    (),
		.LOCKED                     (CLK_MMCM_LOCK),
		//---------- Dynamic Reconfiguration -------------------
		.DCLK                       ( 1'd0),
		.DADDR                      ( 7'd0),
		.DEN                        ( 1'd0),
		.DWE                        ( 1'd0),
		.DI                         (16'd0),
		.DO                         (),
		.DRDY                       (),
		//---------- Dynamic Phase Shift -----------------------
		.PSCLK                      (1'd0),
		.PSEN                       (1'd0),
		.PSINCDEC                   (1'd0),
		.PSDONE                     (),
		//---------- Status ------------------------------------
		.CLKINSTOPPED               (),
		.CLKFBSTOPPED               ()  
	); 

    wire                            clk_125mhz_buf;
    BUFG pclk_i1 (
        .I                          (clk_125mhz), 
        .O                          (clk_125mhz_buf)
    );

// we keep the ability to change user clock freq
	wire                        userclk1_1;
	wire                        userclk2_1;
generate if (PCIE_USERCLK1_FREQ == 3) 
    //---------- USERCLK1 same as PCLK -------------------
    begin :userclk1_i1_no_bufg
    assign userclk1_1 =clk_125mhz_buf;
    end 
else begin : userclk1_i1
    BUFG usrclk1_i1 (
        .I                          (userclk1),
        .O                          (userclk1_1)
    );
    end 
endgenerate 
generate if (PCIE_USERCLK2_FREQ == 3 ) 
	//---------- USERCLK2 same as PCLK -------------------
    begin : userclk2_i1_no_bufg0
    assign userclk2_1 = clk_125mhz_buf;
    end 
else if (PCIE_USERCLK2_FREQ == PCIE_USERCLK1_FREQ ) 
	//---------- USERCLK2 same as USERCLK1 -------------------
    begin : userclk2_i1_no_bufg1
    assign userclk2_1 = userclk1_1;
    end  
else begin : userclk2_i1
    BUFG usrclk2_i1 (
        .I                          (userclk2),
        .O                          (userclk2_1)
    );
    end
endgenerate 

	assign CLK_DCLK = clk_125mhz_buf; // always 125 MHz in Gen1
	assign CLK_RXUSRCLK = clk_125mhz_buf;
	assign CLK_OOBCLK = clk_125mhz_buf;
	assign CLK_USERCLK1 = userclk1_1;
	assign CLK_USERCLK2 = userclk2_1;

	//---------- PIPE Clock Output
	assign CLK_PCLK      = clk_125mhz_buf;

endmodule
