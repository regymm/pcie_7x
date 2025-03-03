// SPDX-License-Identifier: CERN-OHL-P
//
// Copyright 2022-2024 Wavelet Lab
//
// USDR PROJECT
// CLEAN
//
module xilinx_pci_mmcm #(
    parameter PCIE_LANE          = 1,                       // PCIe number of lanes
    parameter PCIE_LINK_SPEED    = 1,                       // PCIe link speed
    parameter PCIE_USERCLK_FREQ  = 2,                       // PCIe user clock 1 frequency
    parameter PCIE_GEN1_MODE     = 0,
    parameter PCIE_ALT_CLOCK     = 0
)(
    input                       rst_n_i,
    input [PCIE_ALT_CLOCK:0]    refclk_i,
    input                       refclk_sel_i,
    input [PCIE_LANE-1:0]       pclk_sel_i,
    input                       pipeclk_en_i,

    output                      pclk_o,
    output                      dclk_o,
    output                      userclk_o,
    output                      mmcm_lock_o,

    output                      clk_50mhz_o,
    output                      clk_200mhz_o,
    output                      clk_333mhz_o
);

localparam          DIVCLK_DIVIDE    = 1;
localparam          CLKFBOUT_MULT_F  = 10;
localparam          CLKIN1_PERIOD    = 10;
localparam          CLKOUT0_DIVIDE_F = 8;
localparam          CLKOUT1_DIVIDE   = 4;
localparam          CLKOUT2_DIVIDE   = (PCIE_USERCLK_FREQ == 5) ?  2 : // 500 Mhz
                                       (PCIE_USERCLK_FREQ == 4) ?  4 : // 250 Mhz
                                       (PCIE_USERCLK_FREQ == 3) ?  8 : // 125 Mhz
                                       (PCIE_USERCLK_FREQ == 1) ? 32 : // 31.25 Mhz
                                                                  16;  // 62.5 Mhz
localparam          CLKOUT3_DIVIDE   = 8;

localparam          CLKOUT4_DIVIDE   = 20; // 50 Mhz
localparam          CLKOUT5_DIVIDE   = 5;  //200 Mhz
localparam          CLKOUT6_DIVIDE   = 3;  //333 Mhz

wire [1:0]                  refclk;
wire                        refclk_sel;
wire                        mmcm_fb;
wire                        clk_125mhz;
wire                        clk_125mhz_buf;
wire                        clk_250mhz;
wire                        userclk1;
reg                         pclk_sel = 1'd0;

wire                        pclk_1;
wire                        pclk;
wire                        userclk1_1;
wire                        mmcm_lock;
wire                        clk_50mhz;
wire                        clk_200mhz;
wire                        clk_333mhz;

(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg [PCIE_LANE-1:0] pclk_sel_reg1 = {PCIE_LANE{1'd0}};
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg [PCIE_LANE-1:0] pclk_sel_reg2 = {PCIE_LANE{1'd0}};

always @ (posedge pclk)
begin
  if (!rst_n_i) begin
    pclk_sel_reg1 <= {PCIE_LANE{1'd0}};
    pclk_sel_reg2 <= {PCIE_LANE{1'd0}};
  end else begin
    pclk_sel_reg1 <= pclk_sel_i;
    pclk_sel_reg2 <= pclk_sel_reg1;
  end
end

BUFG txoutclk0_i(.I(refclk_i[0]), .O(refclk[0]));
generate
  if (PCIE_ALT_CLOCK) begin
    BUFG txoutclk1_i(.I(refclk_i[1]), .O(refclk[1]));
    assign refclk_sel = refclk_sel_i;
  end else begin
    assign refclk[1]  = refclk[0];
    assign refclk_sel = 1'b1;
  end
endgenerate

MMCME2_ADV #(
    .BANDWIDTH                  ("OPTIMIZED"),
    .CLKOUT4_CASCADE            ("FALSE"),
    .COMPENSATION               ("ZHOLD"),
    .STARTUP_WAIT               ("FALSE"),
    .DIVCLK_DIVIDE              (DIVCLK_DIVIDE), // /1
    .CLKFBOUT_MULT_F            (CLKFBOUT_MULT_F), // 100 * 10 = 1000 MHz (PLL)
    .CLKFBOUT_PHASE             (0.000),
    .CLKFBOUT_USE_FINE_PS       ("FALSE"),
    .CLKOUT0_DIVIDE_F           (CLKOUT0_DIVIDE_F), // 1000 / 8 = 125 MHz
    .CLKOUT0_PHASE              (0.000),
    .CLKOUT0_DUTY_CYCLE         (0.500),
    .CLKOUT0_USE_FINE_PS        ("FALSE"),
    .CLKOUT1_DIVIDE             (CLKOUT1_DIVIDE), // 1000 / 4 = 250 MHz
    .CLKOUT1_PHASE              (0.000),
    .CLKOUT1_DUTY_CYCLE         (0.500),
    .CLKOUT1_USE_FINE_PS        ("FALSE"),
    .CLKOUT2_DIVIDE             (CLKOUT2_DIVIDE), // 1000 / 16 = 62.5 MHz
    .CLKOUT2_PHASE              (0.000),
    .CLKOUT2_DUTY_CYCLE         (0.500),
    .CLKOUT2_USE_FINE_PS        ("FALSE"),
    .CLKOUT3_DIVIDE             (CLKOUT3_DIVIDE),
    .CLKOUT3_PHASE              (0.000),
    .CLKOUT3_DUTY_CYCLE         (0.500),
    .CLKOUT3_USE_FINE_PS        ("FALSE"),
    .CLKOUT4_DIVIDE             (CLKOUT4_DIVIDE),
    .CLKOUT4_PHASE              (0.000),
    .CLKOUT4_DUTY_CYCLE         (0.500),
    .CLKOUT4_USE_FINE_PS        ("FALSE"),
    .CLKOUT5_DIVIDE             (CLKOUT5_DIVIDE),
    .CLKOUT5_PHASE              (0.000),
    .CLKOUT5_DUTY_CYCLE         (0.500),
    .CLKOUT5_USE_FINE_PS        ("FALSE"),
    .CLKOUT6_DIVIDE             (CLKOUT6_DIVIDE),
    .CLKOUT6_PHASE              (0.000),
    .CLKOUT6_DUTY_CYCLE         (0.500),
    .CLKOUT6_USE_FINE_PS        ("FALSE"),
    .CLKIN1_PERIOD              (CLKIN1_PERIOD),
    .CLKIN2_PERIOD              (CLKIN1_PERIOD),
    .REF_JITTER1                (0.010)
) mmcm_i (
     //---------- Input ------------------------------------
    .CLKIN1                     (refclk[1]),
    .CLKIN2                     (refclk[0]),
    .CLKINSEL                   (refclk_sel),  // High = CLKIN1, Low = CLKIN2
    .CLKFBIN                    (mmcm_fb),
    .RST                        (!rst_n_i),
    .PWRDWN                     (1'd0),

    //---------- Output ------------------------------------
    .CLKFBOUT                   (mmcm_fb),
    .CLKFBOUTB                  (),
    .CLKOUT0                    (clk_125mhz),
    .CLKOUT0B                   (),
    .CLKOUT1                    (clk_250mhz),
    .CLKOUT1B                   (),
    .CLKOUT2                    (userclk1),
    .CLKOUT2B                   (),
    .CLKOUT3                    (),
    .CLKOUT3B                   (),
    .CLKOUT4                    (clk_50mhz),
    .CLKOUT5                    (clk_200mhz),
    .CLKOUT6                    (clk_333mhz),
    .LOCKED                     (mmcm_lock),

    //---------- Dynamic Reconfiguration -------------------
    .DCLK                       (1'b0),
    .DADDR                      (0),
    .DEN                        (1'b0),
    .DWE                        (1'b0),
    .DI                         (16'h0000),
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

//---------- Select PCLK MUX ---------------------------------------------------
generate
if (PCIE_LINK_SPEED != 1) begin: pclk_i1_bufgctrl
  BUFGCTRL pclk_i1(
        .CE0                        (pipeclk_en_i),
        .CE1                        (pipeclk_en_i),
        .I0                         (clk_125mhz),
        .I1                         (clk_250mhz),
        .IGNORE0                    (1'd0),
        .IGNORE1                    (1'd0),
        .S0                         (~pclk_sel),
        .S1                         ( pclk_sel),
        .O                          (pclk_1)
    );
end else begin: pclk_i1_bufg
  BUFG pclk_i1(.I(clk_125mhz), .O(clk_125mhz_buf));
  assign pclk_1 = clk_125mhz_buf;
end
endgenerate

generate
if (PCIE_LINK_SPEED != 1) begin: dclk_i_bufg
  BUFGCE dclk_i(.I(clk_125mhz), .O(dclk_o), .CE(pipeclk_en_i));
end else begin : dclk_i
  assign dclk_o = clk_125mhz_buf;
end
endgenerate


generate
if (PCIE_GEN1_MODE == 1'b1 && PCIE_USERCLK_FREQ == 3) begin: userclk1_i1_no_bufg
    assign userclk1_1 = pclk_1;
end else begin : userclk1_i1
    BUFG usrclk1_i1(.I(userclk1), .O(userclk1_1));
end
endgenerate

assign pclk         = pclk_1;
assign userclk_o    = userclk1_1;

always @(posedge pclk)
begin
  if (!rst_n_i) begin
    pclk_sel <= 1'd0;
  end else begin
    if (&pclk_sel_reg2)
      pclk_sel <= 1'd1; // 250Mhz
    else if (&(~pclk_sel_reg2))
      pclk_sel <= 1'd0; // 125Mhz
    else
      pclk_sel <= pclk_sel;

  end
end

BUFG clk_50mhz_i (.I(clk_50mhz),  .O(clk_50mhz_o));
BUFG clk_200mhz_i(.I(clk_200mhz), .O(clk_200mhz_o));
BUFG clk_300mhz_i(.I(clk_333mhz), .O(clk_333mhz_o));

assign pclk_o      = pclk;
assign mmcm_lock_o = mmcm_lock;

endmodule
