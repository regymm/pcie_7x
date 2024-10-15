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

module pcie_7x # (
	// REAL parameters!
	parameter         CFG_VEND_ID        = 16'h10EE,
	parameter         CFG_DEV_ID         = 16'h7011,
	parameter         CFG_REV_ID         =  8'h00,
	parameter         CFG_SUBSYS_VEND_ID = 16'h10EE,
	parameter         CFG_SUBSYS_ID      = 16'habcd,

	parameter         EXT_PIPE_SIM = "FALSE",

	parameter         ALLOW_X8_GEN2 = "FALSE",
	parameter         PIPE_PIPELINE_STAGES = 0,
	parameter [11:0]  AER_BASE_PTR = 12'h000,
	parameter         AER_CAP_ECRC_CHECK_CAPABLE = "FALSE",
	parameter         AER_CAP_ECRC_GEN_CAPABLE = "FALSE",
	parameter         AER_CAP_MULTIHEADER = "FALSE",
	parameter [11:0]  AER_CAP_NEXTPTR = 12'h000,
	parameter [23:0]  AER_CAP_OPTIONAL_ERR_SUPPORT = 24'h000000,
	parameter         AER_CAP_ON = "FALSE",
	parameter         AER_CAP_PERMIT_ROOTERR_UPDATE = "FALSE",

	parameter [31:0]  BAR0 = 32'hFE000000,
	parameter [31:0]  BAR1 = 32'h00000000,
	parameter [31:0]  BAR2 = 32'h00000000,
	parameter [31:0]  BAR3 = 32'h00000000,
	parameter [31:0]  BAR4 = 32'h00000000,
	parameter [31:0]  BAR5 = 32'h00000000,

	parameter         C_DATA_WIDTH = 64,
	parameter [31:0]  CARDBUS_CIS_POINTER = 32'h00000000,
	parameter [23:0]  CLASS_CODE = 24'h058000,
	parameter         CMD_INTX_IMPLEMENTED = "TRUE",
	parameter         CPL_TIMEOUT_DISABLE_SUPPORTED = "FALSE",
	parameter [3:0]   CPL_TIMEOUT_RANGES_SUPPORTED = 4'h2,

	parameter integer DEV_CAP_ENDPOINT_L0S_LATENCY = 0,
	parameter integer DEV_CAP_ENDPOINT_L1_LATENCY = 7,
	parameter         DEV_CAP_EXT_TAG_SUPPORTED = "FALSE",
	parameter integer DEV_CAP_MAX_PAYLOAD_SUPPORTED = 2,
	parameter integer DEV_CAP_PHANTOM_FUNCTIONS_SUPPORT = 0,

	parameter         DEV_CAP2_ARI_FORWARDING_SUPPORTED = "FALSE",
	parameter         DEV_CAP2_ATOMICOP32_COMPLETER_SUPPORTED = "FALSE",
	parameter         DEV_CAP2_ATOMICOP64_COMPLETER_SUPPORTED = "FALSE",
	parameter         DEV_CAP2_ATOMICOP_ROUTING_SUPPORTED = "FALSE",
	parameter         DEV_CAP2_CAS128_COMPLETER_SUPPORTED = "FALSE",
	parameter [1:0]   DEV_CAP2_TPH_COMPLETER_SUPPORTED = 2'b00,
	parameter         DEV_CONTROL_EXT_TAG_DEFAULT = "FALSE",

	parameter         DISABLE_LANE_REVERSAL = "TRUE",
	parameter         DISABLE_RX_POISONED_RESP = "FALSE",
	parameter         DISABLE_SCRAMBLING = "FALSE",
	parameter [11:0]  DSN_BASE_PTR = 12'h000,
	parameter [11:0]  DSN_CAP_NEXTPTR = 12'h000,
	parameter         DSN_CAP_ON = "FALSE",

	parameter [10:0]  ENABLE_MSG_ROUTE = 11'b00000000000,
	parameter         ENABLE_RX_TD_ECRC_TRIM = "FALSE",
	parameter [31:0]  EXPANSION_ROM = 32'h00000000,
	parameter [5:0]   EXT_CFG_CAP_PTR = 6'h3F,
	parameter [9:0]   EXT_CFG_XP_CAP_PTR = 10'h3FF,
	parameter [7:0]   HEADER_TYPE = 8'h00,
	parameter [7:0]   INTERRUPT_PIN = 8'h1,

	parameter [9:0]   LAST_CONFIG_DWORD = 10'h3FF,
	parameter         LINK_CAP_ASPM_OPTIONALITY = "FALSE",
	parameter         LINK_CAP_DLL_LINK_ACTIVE_REPORTING_CAP = "FALSE",
	parameter         LINK_CAP_LINK_BANDWIDTH_NOTIFICATION_CAP = "FALSE",
	parameter [3:0]   LINK_CAP_MAX_LINK_SPEED = 4'h1,
	parameter [5:0]   LINK_CAP_MAX_LINK_WIDTH = 6'h1,

	parameter         LINK_CTRL2_DEEMPHASIS = "FALSE",
	parameter         LINK_CTRL2_HW_AUTONOMOUS_SPEED_DISABLE = "FALSE",
	parameter [3:0]   LINK_CTRL2_TARGET_LINK_SPEED = 4'h0,
	parameter         LINK_STATUS_SLOT_CLOCK_CONFIG = "FALSE",

	parameter [14:0]  LL_ACK_TIMEOUT = 15'h0000,
	parameter         LL_ACK_TIMEOUT_EN = "FALSE",
	parameter integer LL_ACK_TIMEOUT_FUNC = 0,
	parameter [14:0]  LL_REPLAY_TIMEOUT = 15'h0000,
	parameter         LL_REPLAY_TIMEOUT_EN = "FALSE",
	parameter integer LL_REPLAY_TIMEOUT_FUNC = 1,

	parameter [5:0]   LTSSM_MAX_LINK_WIDTH = 6'h1,
	parameter         MSI_CAP_MULTIMSGCAP = 0,
	parameter         MSI_CAP_MULTIMSG_EXTENSION = 0,
	parameter         MSI_CAP_ON = "TRUE",
	parameter         MSI_CAP_PER_VECTOR_MASKING_CAPABLE = "FALSE",
	parameter         MSI_CAP_64_BIT_ADDR_CAPABLE = "TRUE",

	parameter         MSIX_CAP_ON = "FALSE",
	parameter         MSIX_CAP_PBA_BIR = 0,
	parameter [28:0]  MSIX_CAP_PBA_OFFSET = 29'h0,
	parameter         MSIX_CAP_TABLE_BIR = 0,
	parameter [28:0]  MSIX_CAP_TABLE_OFFSET = 29'h0,
	parameter [10:0]  MSIX_CAP_TABLE_SIZE = 11'h000,

	parameter [3:0]   PCIE_CAP_DEVICE_PORT_TYPE = 4'h0,
	parameter [7:0]   PCIE_CAP_NEXTPTR = 8'h00,

	parameter         PM_CAP_DSI = "FALSE",
	parameter         PM_CAP_D1SUPPORT = "FALSE",
	parameter         PM_CAP_D2SUPPORT = "FALSE",
	parameter [7:0]   PM_CAP_NEXTPTR = 8'h48,
	parameter [4:0]   PM_CAP_PMESUPPORT = 5'h00,
	parameter         PM_CSR_NOSOFTRST = "TRUE",

	parameter [1:0]   PM_DATA_SCALE0 = 2'h0,
	parameter [7:0]   PM_DATA0 = 8'h00,

	parameter [11:0]  RBAR_BASE_PTR = 12'h000,
	parameter [4:0]   RBAR_CAP_CONTROL_ENCODEDBAR0 = 5'h00,
	parameter [4:0]   RBAR_CAP_CONTROL_ENCODEDBAR1 = 5'h00,
	parameter [4:0]   RBAR_CAP_CONTROL_ENCODEDBAR2 = 5'h00,
	parameter [4:0]   RBAR_CAP_CONTROL_ENCODEDBAR3 = 5'h00,
	parameter [4:0]   RBAR_CAP_CONTROL_ENCODEDBAR4 = 5'h00,
	parameter [4:0]   RBAR_CAP_CONTROL_ENCODEDBAR5 = 5'h00,
	parameter [2:0]   RBAR_CAP_INDEX0 = 3'h0,
	parameter [2:0]   RBAR_CAP_INDEX1 = 3'h0,
	parameter [2:0]   RBAR_CAP_INDEX2 = 3'h0,
	parameter [2:0]   RBAR_CAP_INDEX3 = 3'h0,
	parameter [2:0]   RBAR_CAP_INDEX4 = 3'h0,
	parameter [2:0]   RBAR_CAP_INDEX5 = 3'h0,
	parameter         RBAR_CAP_ON = "FALSE",
	parameter [31:0]  RBAR_CAP_SUP0 = 32'h00001,
	parameter [31:0]  RBAR_CAP_SUP1 = 32'h00001,
	parameter [31:0]  RBAR_CAP_SUP2 = 32'h00001,
	parameter [31:0]  RBAR_CAP_SUP3 = 32'h00001,
	parameter [31:0]  RBAR_CAP_SUP4 = 32'h00001,
	parameter [31:0]  RBAR_CAP_SUP5 = 32'h00001,
	parameter [2:0]   RBAR_NUM = 3'h0,

	parameter         RECRC_CHK = 0,
	parameter         RECRC_CHK_TRIM = "FALSE",
	parameter         REF_CLK_FREQ = 0,     // 0 - 100 MHz, 1 - 125 MHz, 2 - 250 MHz
	parameter         REM_WIDTH  = (C_DATA_WIDTH == 128) ? 2 : 1,
	parameter         KEEP_WIDTH = C_DATA_WIDTH / 8,

	parameter         TL_RX_RAM_RADDR_LATENCY = 0,
	parameter         TL_RX_RAM_WRITE_LATENCY = 0,
	parameter         TL_TX_RAM_RADDR_LATENCY = 0,
	parameter         TL_TX_RAM_WRITE_LATENCY = 0,
	parameter         TL_RX_RAM_RDATA_LATENCY = 2,
	parameter         TL_TX_RAM_RDATA_LATENCY = 2,
	parameter         TRN_NP_FC = "TRUE",
	parameter         TRN_DW = "FALSE",

	parameter         UPCONFIG_CAPABLE = "TRUE",
	parameter         UPSTREAM_FACING = "TRUE",
	parameter         UR_ATOMIC = "FALSE",
	parameter         UR_INV_REQ = "TRUE",
	parameter         UR_PRS_RESPONSE = "TRUE",
	parameter         USER_CLK_FREQ = 1,
	parameter         USER_CLK2_DIV2 = "FALSE",

	parameter [11:0]  VC_BASE_PTR = 12'h000,
	parameter [11:0]  VC_CAP_NEXTPTR = 12'h000,
	parameter         VC_CAP_ON = "FALSE",
	parameter         VC_CAP_REJECT_SNOOP_TRANSACTIONS = "FALSE",

	parameter         VC0_CPL_INFINITE = "TRUE",
	parameter [12:0]  VC0_RX_RAM_LIMIT = 13'h7FF,
	parameter         VC0_TOTAL_CREDITS_CD = 461,
	parameter         VC0_TOTAL_CREDITS_CH = 36,
	parameter         VC0_TOTAL_CREDITS_NPH = 12,
	parameter         VC0_TOTAL_CREDITS_NPD = 24,
	parameter         VC0_TOTAL_CREDITS_PD = 437,
	parameter         VC0_TOTAL_CREDITS_PH = 32,
	parameter         VC0_TX_LASTPACKET = 29,

	parameter [11:0]  VSEC_BASE_PTR = 12'h000,
	parameter [11:0]  VSEC_CAP_NEXTPTR = 12'h000,
	parameter         VSEC_CAP_ON = "FALSE",

	parameter         DISABLE_ASPM_L1_TIMER = "FALSE",
	parameter         DISABLE_BAR_FILTERING = "FALSE",
	parameter         DISABLE_ID_CHECK = "FALSE",
	parameter         DISABLE_RX_TC_FILTER = "FALSE",
	parameter [7:0]   DNSTREAM_LINK_NUM = 8'h00,

	parameter [15:0]  DSN_CAP_ID = 16'h0003,
	parameter [3:0]   DSN_CAP_VERSION = 4'h1,
	parameter         ENTER_RVRY_EI_L0 = "TRUE",
	parameter [4:0]   INFER_EI = 5'h00,
	parameter         IS_SWITCH = "FALSE",

	parameter         LINK_CAP_ASPM_SUPPORT = 1,
	parameter         LINK_CAP_CLOCK_POWER_MANAGEMENT = "FALSE",
	parameter         LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 = 7,
	parameter         LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 = 7,
	parameter         LINK_CAP_L0S_EXIT_LATENCY_GEN1 = 7,
	parameter         LINK_CAP_L0S_EXIT_LATENCY_GEN2 = 7,
	parameter         LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 = 7,
	parameter         LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 = 7,
	parameter         LINK_CAP_L1_EXIT_LATENCY_GEN1 = 7,
	parameter         LINK_CAP_L1_EXIT_LATENCY_GEN2 = 7,
	parameter         LINK_CAP_RSVD_23 = 0,
	parameter         LINK_CONTROL_RCB = 0,

	parameter [7:0]   MSI_BASE_PTR = 8'h48,
	parameter [7:0]   MSI_CAP_ID = 8'h05,
	parameter [7:0]   MSI_CAP_NEXTPTR = 8'h60,
	parameter [7:0]   MSIX_BASE_PTR = 8'h9C,
	parameter [7:0]   MSIX_CAP_ID = 8'h11,
	parameter [7:0]   MSIX_CAP_NEXTPTR =8'h00,

	parameter         N_FTS_COMCLK_GEN1 = 255,
	parameter         N_FTS_COMCLK_GEN2 = 255,
	parameter         N_FTS_GEN1 = 255,
	parameter         N_FTS_GEN2 = 255,

	parameter [7:0]   PCIE_BASE_PTR = 8'h60,
	parameter [7:0]   PCIE_CAP_CAPABILITY_ID = 8'h10,
	parameter [3:0]   PCIE_CAP_CAPABILITY_VERSION = 4'h2,
	parameter         PCIE_CAP_ON = "TRUE",
	parameter         PCIE_CAP_RSVD_15_14 = 0,
	parameter         PCIE_CAP_SLOT_IMPLEMENTED = "FALSE",
	parameter         PCIE_REVISION = 2,

	parameter         PL_AUTO_CONFIG = 0,
	parameter         PL_FAST_TRAIN = "FALSE",
	parameter         PCIE_EXT_CLK = "TRUE",

	parameter         PCIE_EXT_GT_COMMON = "FALSE",
	parameter         EXT_CH_GT_DRP      = "FALSE",
	parameter         TRANSCEIVER_CTRL_STATUS_PORTS = "FALSE", 
	parameter         SHARED_LOGIC_IN_CORE = "FALSE",

	parameter [7:0]   PM_BASE_PTR = 8'h40,
	parameter         PM_CAP_AUXCURRENT = 0,
	parameter [7:0]   PM_CAP_ID = 8'h01,
	parameter         PM_CAP_ON = "TRUE",
	parameter         PM_CAP_PME_CLOCK = "FALSE",
	parameter         PM_CAP_RSVD_04 = 0,
	parameter         PM_CAP_VERSION = 3,
	parameter         PM_CSR_BPCCEN = "FALSE",
	parameter         PM_CSR_B2B3 = "FALSE",

	parameter         ROOT_CAP_CRS_SW_VISIBILITY = "FALSE",
	parameter         SELECT_DLL_IF = "FALSE",
	parameter         SLOT_CAP_ATT_BUTTON_PRESENT = "FALSE",
	parameter         SLOT_CAP_ATT_INDICATOR_PRESENT = "FALSE",
	parameter         SLOT_CAP_ELEC_INTERLOCK_PRESENT = "FALSE",
	parameter         SLOT_CAP_HOTPLUG_CAPABLE = "FALSE",
	parameter         SLOT_CAP_HOTPLUG_SURPRISE = "FALSE",
	parameter         SLOT_CAP_MRL_SENSOR_PRESENT = "FALSE",
	parameter         SLOT_CAP_NO_CMD_COMPLETED_SUPPORT = "FALSE",
	parameter [12:0]  SLOT_CAP_PHYSICAL_SLOT_NUM = 13'h0000,
	parameter         SLOT_CAP_POWER_CONTROLLER_PRESENT = "FALSE",
	parameter         SLOT_CAP_POWER_INDICATOR_PRESENT = "FALSE",
	parameter         SLOT_CAP_SLOT_POWER_LIMIT_SCALE = 0,
	parameter [7:0]   SLOT_CAP_SLOT_POWER_LIMIT_VALUE = 8'h00,

	parameter         TL_RBYPASS = "FALSE",
	parameter         TL_TFC_DISABLE = "FALSE",
	parameter         TL_TX_CHECKS_DISABLE = "FALSE",
	parameter         EXIT_LOOPBACK_ON_EI = "TRUE",

	parameter         CFG_ECRC_ERR_CPLSTAT = 0,
	parameter [7:0]   CAPABILITIES_PTR = 8'h40,
	parameter [6:0]   CRM_MODULE_RSTS = 7'h00,
	parameter         DEV_CAP_ENABLE_SLOT_PWR_LIMIT_SCALE = "TRUE",
	parameter         DEV_CAP_ENABLE_SLOT_PWR_LIMIT_VALUE = "TRUE",
	parameter         DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE = "FALSE",
	parameter         DEV_CAP_ROLE_BASED_ERROR = "TRUE",
	parameter         DEV_CAP_RSVD_14_12 = 0,
	parameter         DEV_CAP_RSVD_17_16 = 0,
	parameter         DEV_CAP_RSVD_31_29 = 0,
	parameter         DEV_CONTROL_AUX_POWER_SUPPORTED = "FALSE",

	parameter [15:0]  VC_CAP_ID = 16'h0002,
	parameter [3:0]   VC_CAP_VERSION = 4'h1,
	parameter [15:0]  VSEC_CAP_HDR_ID = 16'h1234,
	parameter [11:0]  VSEC_CAP_HDR_LENGTH = 12'h018,
	parameter [3:0]   VSEC_CAP_HDR_REVISION = 4'h1,
	parameter [15:0]  VSEC_CAP_ID = 16'h000B,
	parameter         VSEC_CAP_IS_LINK_VISIBLE = "TRUE",
	parameter [3:0]   VSEC_CAP_VERSION = 4'h1,

	parameter         DISABLE_ERR_MSG = "FALSE",
	parameter         DISABLE_LOCKED_FILTER = "FALSE",
	parameter         DISABLE_PPM_FILTER = "FALSE",
	parameter         ENDEND_TLP_PREFIX_FORWARDING_SUPPORTED = "FALSE",
	parameter         INTERRUPT_STAT_AUTO = "TRUE",
	parameter         MPS_FORCE = "FALSE",
	parameter [14:0]  PM_ASPML0S_TIMEOUT = 15'h0000,
	parameter         PM_ASPML0S_TIMEOUT_EN = "FALSE",
	parameter         PM_ASPML0S_TIMEOUT_FUNC = 0,
	parameter         PM_ASPM_FASTEXIT = "FALSE",
	parameter         PM_MF = "FALSE",

	parameter [1:0]   RP_AUTO_SPD = 2'h1,
	parameter [4:0]   RP_AUTO_SPD_LOOPCNT = 5'h1f,
	parameter         SIM_VERSION = "1.0",
	parameter         SSL_MESSAGE_AUTO = "FALSE",
	parameter         TECRC_EP_INV = "FALSE",
	parameter         UR_CFG1 = "TRUE",
	parameter         USE_RID_PINS = "FALSE",

	// New Parameters
	parameter         DEV_CAP2_ENDEND_TLP_PREFIX_SUPPORTED = "FALSE",
	parameter         DEV_CAP2_EXTENDED_FMT_FIELD_SUPPORTED = "FALSE",
	parameter         DEV_CAP2_LTR_MECHANISM_SUPPORTED = "FALSE",
	parameter [1:0]   DEV_CAP2_MAX_ENDEND_TLP_PREFIXES = 2'h0,
	parameter         DEV_CAP2_NO_RO_ENABLED_PRPR_PASSING = "FALSE",

	parameter         LINK_CAP_SURPRISE_DOWN_ERROR_CAPABLE = "FALSE",

	parameter [15:0]  AER_CAP_ID = 16'h0001,
	parameter [3:0]   AER_CAP_VERSION = 4'h1,

	parameter [15:0]  RBAR_CAP_ID = 16'h0015,
	parameter [11:0]  RBAR_CAP_NEXTPTR = 12'h000,
	parameter [3:0]   RBAR_CAP_VERSION = 4'h1,
	parameter         PCIE_USE_MODE = "1.0",
	parameter         PCIE_GT_DEVICE = "GTP",
	parameter         PCIE_CHAN_BOND = 1,
	parameter         PCIE_PLL_SEL   = "CPLL",
	parameter         PCIE_ASYNC_EN  = "FALSE",
	parameter         PCIE_TXBUF_EN  = "FALSE",
	parameter         PL_INTERFACE = "FALSE",
	parameter         CFG_MGMT_IF = "FALSE",
	parameter         CFG_CTL_IF = "TRUE",
	parameter         CFG_STATUS_IF = "TRUE",
	parameter         RCV_MSG_IF = "FALSE",
	parameter         CFG_FC_IF = "FALSE",
	parameter         EXT_PIPE_INTERFACE = "FALSE",

	parameter         TX_MARGIN_FULL_0  = 7'b1001111,
	parameter         TX_MARGIN_FULL_1  = 7'b1001110,
	parameter         TX_MARGIN_FULL_2  = 7'b1001101,
	parameter         TX_MARGIN_FULL_3  = 7'b1001100,
	parameter         TX_MARGIN_FULL_4  = 7'b1000011,
	parameter         TX_MARGIN_LOW_0   = 7'b1000101,
	parameter         TX_MARGIN_LOW_1   = 7'b1000110,
	parameter         TX_MARGIN_LOW_2   = 7'b1000011,
	parameter         TX_MARGIN_LOW_3   = 7'b1000010,
	parameter         TX_MARGIN_LOW_4   = 7'b1000000,
	parameter         ENABLE_JTAG_DBG = "FALSE",
	parameter PCIE_USERCLK1_FREQ      = 2,
	parameter PCIE_USERCLK2_FREQ      = 2
) (
	// Tx
	output  [0:0] pci_exp_txn,
	output  [0:0] pci_exp_txp,
	// Rx
	input   [0:0] pci_exp_rxn,
	input   [0:0] pci_exp_rxp,
	input   pipe_mmcm_rst_n,
	// AXIS Common
	output                                     user_clk_out, // actually is user_clk2
	output reg user_reset_out,
	output reg user_lnk_up,

	input                                      tx_cfg_gnt,
	input                                      rx_np_ok,
	input                                      rx_np_req,
	input                                      cfg_turnoff_ok,
	input                                      cfg_trn_pending,
	input                                      cfg_pm_halt_aspm_l0s,
	input                                      cfg_pm_halt_aspm_l1,
	input                                      cfg_pm_force_state_en,
	input    [1:0]                             cfg_pm_force_state,
	input    [63:0]                            cfg_dsn,
	input                                      cfg_pm_wake,
	// AXI TX
	input   [64-1:0]                 s_axis_tx_tdata,
	input                                      s_axis_tx_tvalid,
	output                                     s_axis_tx_tready,
	input   [8-1:0]                   s_axis_tx_tkeep,
	input                                      s_axis_tx_tlast,
	input   [3:0]                              s_axis_tx_tuser,
	// AXI RX
	output  [64-1:0]                 m_axis_rx_tdata,
	output                                     m_axis_rx_tvalid,
	input                                      m_axis_rx_tready,
	output  [8-1:0]                   m_axis_rx_tkeep,
	output                                     m_axis_rx_tlast,
	output  [21:0]                             m_axis_rx_tuser,
	// Configuration (CFG) Interface
	// EP and RP
	output                                     tx_err_drop,
	output                                     tx_cfg_req,
	output  [5:0]                              tx_buf_av,
	output   [15:0]                            cfg_status,
	output   [15:0]                            cfg_command,
	output   [15:0]                            cfg_dstatus,
	output   [15:0]                            cfg_dcommand,
	output   [15:0]                            cfg_lstatus,
	output   [15:0]                            cfg_lcommand,
	output   [15:0]                            cfg_dcommand2,
	output   [2:0]                             cfg_pcie_link_state,
	output                                     cfg_to_turnoff,
	output   [7:0]                             cfg_bus_number,
	output   [4:0]                             cfg_device_number,
	output   [2:0]                             cfg_function_number,

	output                                     cfg_pmcsr_pme_en,
	output   [1:0]                             cfg_pmcsr_powerstate,
	output                                     cfg_pmcsr_pme_status,
	output                                     cfg_received_func_lvl_rst,
	// EP Only
	input                                       cfg_interrupt,
	output                                      cfg_interrupt_rdy,
	input                                       cfg_interrupt_assert,
	input    [7:0]                              cfg_interrupt_di,
	output   [7:0]                              cfg_interrupt_do,
	output   [2:0]                              cfg_interrupt_mmenable,
	output                                      cfg_interrupt_msienable,
	output                                      cfg_interrupt_msixenable,
	output                                      cfg_interrupt_msixfm,
	input                                       cfg_interrupt_stat,
	input    [4:0]                              cfg_pciecap_interrupt_msgnum,

	input                                       sys_clk,
	input                                       sys_rst_n
);

// Generate user_reset_out
// Once user reset output of PCIE and Phy Layer is active, de-assert reset
// Only assert reset if system reset ~~or hot reset~~ is seen.  Keep AXI backend/user application alive otherwise
// Invert active low reset to active high AXI reset
wire                 trn_lnk_up;
reg user_reset_int;
reg bridge_reset_int;
reg bridge_reset_d;
always @(posedge user_clk_out) begin
	if (!sys_rst_n) begin
		user_lnk_up <= 1'b0;
		user_reset_int <= 1'b1;
		user_reset_out <= 1'b1;
		bridge_reset_int <= 1'b1;
		bridge_reset_d <= 1'b1;
	end else begin
		user_lnk_up <= trn_lnk_up;
		user_reset_int <= 1'b0;
		user_reset_out <= user_reset_int;
		bridge_reset_int <= 1'b0;
		bridge_reset_d <= bridge_reset_int;
	end
end

reg reg_clock_locked;
always @(posedge PIPE_PCLK_IN or negedge clock_locked) begin
	if (!clock_locked) reg_clock_locked <=  1'b0;
	else reg_clock_locked <=  1'b1;
end
always @(posedge PIPE_PCLK_IN) begin
	if (!reg_clock_locked) phy_rdy_n <=  1'b0;
	else phy_rdy_n <= phystatus_rst[0:0];
end

// PIPE Interface Wires, PIPE to PCIE_2_1
reg                  phy_rdy_n;
wire                 pipe_rx0_polarity;
wire                 pipe_tx_deemph;
wire [2:0]           pipe_tx_margin;
wire                 pipe_tx_rate;
wire                 pipe_tx_rcvr_det;
wire [1:0]           pipe_tx0_char_is_k;
wire                 pipe_tx0_compliance;
wire [15:0]          pipe_tx0_data;
wire                 pipe_tx0_elec_idle;
wire [1:0]           pipe_tx0_powerdown;
wire [15:0]          cfg_vend_id        = CFG_VEND_ID;
wire [15:0]          cfg_dev_id         = CFG_DEV_ID;
wire [7:0]           cfg_rev_id         = CFG_REV_ID;
wire [15:0]          cfg_subsys_vend_id = CFG_SUBSYS_VEND_ID;
wire [15:0]          cfg_subsys_id      = CFG_SUBSYS_ID;
wire [5:0]           pl_ltssm_state;
pcie_block # (
    .PIPE_PIPELINE_STAGES                     ( PIPE_PIPELINE_STAGES ),
    .AER_BASE_PTR                             ( AER_BASE_PTR ),
    .AER_CAP_ECRC_CHECK_CAPABLE               ( AER_CAP_ECRC_CHECK_CAPABLE ),
    .AER_CAP_ECRC_GEN_CAPABLE                 ( AER_CAP_ECRC_GEN_CAPABLE ),
    .AER_CAP_ID                               ( AER_CAP_ID ),
    .AER_CAP_MULTIHEADER                      ( AER_CAP_MULTIHEADER ),
    .AER_CAP_NEXTPTR                          ( AER_CAP_NEXTPTR ),
    .AER_CAP_ON                               ( AER_CAP_ON ),
    .AER_CAP_OPTIONAL_ERR_SUPPORT             ( AER_CAP_OPTIONAL_ERR_SUPPORT ),
    .AER_CAP_PERMIT_ROOTERR_UPDATE            ( AER_CAP_PERMIT_ROOTERR_UPDATE ),
    .AER_CAP_VERSION                          ( AER_CAP_VERSION ),
    .ALLOW_X8_GEN2                            ( ALLOW_X8_GEN2 ),
    .BAR0                                     ( BAR0 ),
    .BAR1                                     ( BAR1 ),
    .BAR2                                     ( BAR2 ),
    .BAR3                                     ( BAR3 ),
    .BAR4                                     ( BAR4 ),
    .BAR5                                     ( BAR5 ),
    .C_DATA_WIDTH                             ( C_DATA_WIDTH ),
    .CAPABILITIES_PTR                         ( CAPABILITIES_PTR ),
    .CARDBUS_CIS_POINTER                      ( CARDBUS_CIS_POINTER ),
    .CFG_ECRC_ERR_CPLSTAT                     ( CFG_ECRC_ERR_CPLSTAT ),
    .CLASS_CODE                               ( CLASS_CODE ),
    .CMD_INTX_IMPLEMENTED                     ( CMD_INTX_IMPLEMENTED ),
    .CPL_TIMEOUT_DISABLE_SUPPORTED            ( CPL_TIMEOUT_DISABLE_SUPPORTED ),
    .CPL_TIMEOUT_RANGES_SUPPORTED             ( CPL_TIMEOUT_RANGES_SUPPORTED ),
    .CRM_MODULE_RSTS                          ( CRM_MODULE_RSTS ),
    .DEV_CAP_ENABLE_SLOT_PWR_LIMIT_SCALE      ( DEV_CAP_ENABLE_SLOT_PWR_LIMIT_SCALE ),
    .DEV_CAP_ENABLE_SLOT_PWR_LIMIT_VALUE      ( DEV_CAP_ENABLE_SLOT_PWR_LIMIT_VALUE ),
    .DEV_CAP_ENDPOINT_L0S_LATENCY             ( DEV_CAP_ENDPOINT_L0S_LATENCY ),
    .DEV_CAP_ENDPOINT_L1_LATENCY              ( DEV_CAP_ENDPOINT_L1_LATENCY ),
    .DEV_CAP_EXT_TAG_SUPPORTED                ( DEV_CAP_EXT_TAG_SUPPORTED ),
    .DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE     ( DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE ),
    .DEV_CAP_MAX_PAYLOAD_SUPPORTED            ( DEV_CAP_MAX_PAYLOAD_SUPPORTED ),
    .DEV_CAP_PHANTOM_FUNCTIONS_SUPPORT        ( DEV_CAP_PHANTOM_FUNCTIONS_SUPPORT ),
    .DEV_CAP_ROLE_BASED_ERROR                 ( DEV_CAP_ROLE_BASED_ERROR ),
    .DEV_CAP_RSVD_14_12                       ( DEV_CAP_RSVD_14_12 ),
    .DEV_CAP_RSVD_17_16                       ( DEV_CAP_RSVD_17_16 ),
    .DEV_CAP_RSVD_31_29                       ( DEV_CAP_RSVD_31_29 ),
    .DEV_CONTROL_AUX_POWER_SUPPORTED          ( DEV_CONTROL_AUX_POWER_SUPPORTED ),
    .DEV_CONTROL_EXT_TAG_DEFAULT              ( DEV_CONTROL_EXT_TAG_DEFAULT ),
    .DISABLE_ASPM_L1_TIMER                    ( DISABLE_ASPM_L1_TIMER ),
    .DISABLE_BAR_FILTERING                    ( DISABLE_BAR_FILTERING ),
    .DISABLE_ID_CHECK                         ( DISABLE_ID_CHECK ),
    .DISABLE_LANE_REVERSAL                    ( DISABLE_LANE_REVERSAL ),
    .DISABLE_RX_POISONED_RESP                 ( DISABLE_RX_POISONED_RESP ),
    .DISABLE_RX_TC_FILTER                     ( DISABLE_RX_TC_FILTER ),
    .DISABLE_SCRAMBLING                       ( DISABLE_SCRAMBLING ),
    .DNSTREAM_LINK_NUM                        ( DNSTREAM_LINK_NUM ),
    .DSN_BASE_PTR                             ( DSN_BASE_PTR ),
    .DSN_CAP_ID                               ( DSN_CAP_ID ),
    .DSN_CAP_NEXTPTR                          ( DSN_CAP_NEXTPTR ),
    .DSN_CAP_ON                               ( DSN_CAP_ON ),
    .DSN_CAP_VERSION                          ( DSN_CAP_VERSION ),
    .DEV_CAP2_ARI_FORWARDING_SUPPORTED        ( DEV_CAP2_ARI_FORWARDING_SUPPORTED ),
    .DEV_CAP2_ATOMICOP32_COMPLETER_SUPPORTED  ( DEV_CAP2_ATOMICOP32_COMPLETER_SUPPORTED ),
    .DEV_CAP2_ATOMICOP64_COMPLETER_SUPPORTED  ( DEV_CAP2_ATOMICOP64_COMPLETER_SUPPORTED ),
    .DEV_CAP2_ATOMICOP_ROUTING_SUPPORTED      ( DEV_CAP2_ATOMICOP_ROUTING_SUPPORTED ),
    .DEV_CAP2_CAS128_COMPLETER_SUPPORTED      ( DEV_CAP2_CAS128_COMPLETER_SUPPORTED ),
    .DEV_CAP2_ENDEND_TLP_PREFIX_SUPPORTED     ( DEV_CAP2_ENDEND_TLP_PREFIX_SUPPORTED ),
    .DEV_CAP2_EXTENDED_FMT_FIELD_SUPPORTED    ( DEV_CAP2_EXTENDED_FMT_FIELD_SUPPORTED ),
    .DEV_CAP2_LTR_MECHANISM_SUPPORTED         ( DEV_CAP2_LTR_MECHANISM_SUPPORTED ),
    .DEV_CAP2_MAX_ENDEND_TLP_PREFIXES         ( DEV_CAP2_MAX_ENDEND_TLP_PREFIXES ),
    .DEV_CAP2_NO_RO_ENABLED_PRPR_PASSING      ( DEV_CAP2_NO_RO_ENABLED_PRPR_PASSING ),
    .DEV_CAP2_TPH_COMPLETER_SUPPORTED         ( DEV_CAP2_TPH_COMPLETER_SUPPORTED ),
    .DISABLE_ERR_MSG                          ( DISABLE_ERR_MSG ),
    .DISABLE_LOCKED_FILTER                    ( DISABLE_LOCKED_FILTER ),
    .DISABLE_PPM_FILTER                       ( DISABLE_PPM_FILTER ),
    .ENDEND_TLP_PREFIX_FORWARDING_SUPPORTED   ( ENDEND_TLP_PREFIX_FORWARDING_SUPPORTED ),
    .ENABLE_MSG_ROUTE                         ( ENABLE_MSG_ROUTE ),
    .ENABLE_RX_TD_ECRC_TRIM                   ( ENABLE_RX_TD_ECRC_TRIM ),
    .ENTER_RVRY_EI_L0                         ( ENTER_RVRY_EI_L0 ),
    .EXIT_LOOPBACK_ON_EI                      ( EXIT_LOOPBACK_ON_EI ),
    .EXPANSION_ROM                            ( EXPANSION_ROM ),
    .EXT_CFG_CAP_PTR                          ( EXT_CFG_CAP_PTR ),
    .EXT_CFG_XP_CAP_PTR                       ( EXT_CFG_XP_CAP_PTR ),
    .HEADER_TYPE                              ( HEADER_TYPE ),
    .INFER_EI                                 ( INFER_EI ),
    .INTERRUPT_PIN                            ( INTERRUPT_PIN ),
    .INTERRUPT_STAT_AUTO                      ( INTERRUPT_STAT_AUTO ),
    .IS_SWITCH                                ( IS_SWITCH ),
    .LAST_CONFIG_DWORD                        ( LAST_CONFIG_DWORD ),
    .LINK_CAP_ASPM_OPTIONALITY                ( LINK_CAP_ASPM_OPTIONALITY ),
    .LINK_CAP_ASPM_SUPPORT                    ( LINK_CAP_ASPM_SUPPORT ),
    .LINK_CAP_CLOCK_POWER_MANAGEMENT          ( LINK_CAP_CLOCK_POWER_MANAGEMENT ),
    .LINK_CAP_DLL_LINK_ACTIVE_REPORTING_CAP   ( LINK_CAP_DLL_LINK_ACTIVE_REPORTING_CAP ),
    .LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1    ( LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 ),
    .LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2    ( LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 ),
    .LINK_CAP_L0S_EXIT_LATENCY_GEN1           ( LINK_CAP_L0S_EXIT_LATENCY_GEN1 ),
    .LINK_CAP_L0S_EXIT_LATENCY_GEN2           ( LINK_CAP_L0S_EXIT_LATENCY_GEN2 ),
    .LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1     ( LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 ),
    .LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2     ( LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 ),
    .LINK_CAP_L1_EXIT_LATENCY_GEN1            ( LINK_CAP_L1_EXIT_LATENCY_GEN1 ),
    .LINK_CAP_L1_EXIT_LATENCY_GEN2            ( LINK_CAP_L1_EXIT_LATENCY_GEN2 ),
    .LINK_CAP_LINK_BANDWIDTH_NOTIFICATION_CAP ( LINK_CAP_LINK_BANDWIDTH_NOTIFICATION_CAP ),
    .LINK_CAP_MAX_LINK_SPEED                  ( LINK_CAP_MAX_LINK_SPEED ),
    .LINK_CAP_MAX_LINK_WIDTH                  ( LINK_CAP_MAX_LINK_WIDTH ),
    .LINK_CAP_RSVD_23                         ( LINK_CAP_RSVD_23 ),
    .LINK_CAP_SURPRISE_DOWN_ERROR_CAPABLE     ( LINK_CAP_SURPRISE_DOWN_ERROR_CAPABLE ),
    .LINK_CONTROL_RCB                         ( LINK_CONTROL_RCB ),
    .LINK_CTRL2_DEEMPHASIS                    ( LINK_CTRL2_DEEMPHASIS ),
    .LINK_CTRL2_HW_AUTONOMOUS_SPEED_DISABLE   ( LINK_CTRL2_HW_AUTONOMOUS_SPEED_DISABLE ),
    .LINK_CTRL2_TARGET_LINK_SPEED             ( LINK_CTRL2_TARGET_LINK_SPEED ),
    .LINK_STATUS_SLOT_CLOCK_CONFIG            ( LINK_STATUS_SLOT_CLOCK_CONFIG ),
    .LL_ACK_TIMEOUT                           ( LL_ACK_TIMEOUT ),
    .LL_ACK_TIMEOUT_EN                        ( LL_ACK_TIMEOUT_EN ),
    .LL_ACK_TIMEOUT_FUNC                      ( LL_ACK_TIMEOUT_FUNC ),
    .LL_REPLAY_TIMEOUT                        ( LL_REPLAY_TIMEOUT ),
    .LL_REPLAY_TIMEOUT_EN                     ( LL_REPLAY_TIMEOUT_EN ),
    .LL_REPLAY_TIMEOUT_FUNC                   ( LL_REPLAY_TIMEOUT_FUNC ),
    .LTSSM_MAX_LINK_WIDTH                     ( LTSSM_MAX_LINK_WIDTH ),
    .MPS_FORCE                                ( MPS_FORCE),
    .MSI_BASE_PTR                             ( MSI_BASE_PTR ),
    .MSI_CAP_ID                               ( MSI_CAP_ID ),
    .MSI_CAP_MULTIMSGCAP                      ( MSI_CAP_MULTIMSGCAP ),
    .MSI_CAP_MULTIMSG_EXTENSION               ( MSI_CAP_MULTIMSG_EXTENSION ),
    .MSI_CAP_NEXTPTR                          ( MSI_CAP_NEXTPTR ),
    .MSI_CAP_ON                               ( MSI_CAP_ON ),
    .MSI_CAP_PER_VECTOR_MASKING_CAPABLE       ( MSI_CAP_PER_VECTOR_MASKING_CAPABLE ),
    .MSI_CAP_64_BIT_ADDR_CAPABLE              ( MSI_CAP_64_BIT_ADDR_CAPABLE ),
    .MSIX_BASE_PTR                            ( MSIX_BASE_PTR ),
    .MSIX_CAP_ID                              ( MSIX_CAP_ID ),
    .MSIX_CAP_NEXTPTR                         ( MSIX_CAP_NEXTPTR ),
    .MSIX_CAP_ON                              ( MSIX_CAP_ON ),
    .MSIX_CAP_PBA_BIR                         ( MSIX_CAP_PBA_BIR ),
    .MSIX_CAP_PBA_OFFSET                      ( {3'b000,MSIX_CAP_PBA_OFFSET[28:3]} ),
    .MSIX_CAP_TABLE_BIR                       ( MSIX_CAP_TABLE_BIR ),
    .MSIX_CAP_TABLE_OFFSET                    ( {3'b000,MSIX_CAP_TABLE_OFFSET[28:3]} ),
    .MSIX_CAP_TABLE_SIZE                      ( MSIX_CAP_TABLE_SIZE ),
    .N_FTS_COMCLK_GEN1                        ( N_FTS_COMCLK_GEN1 ),
    .N_FTS_COMCLK_GEN2                        ( N_FTS_COMCLK_GEN2 ),
    .N_FTS_GEN1                               ( N_FTS_GEN1 ),
    .N_FTS_GEN2                               ( N_FTS_GEN2 ),
    .PCIE_BASE_PTR                            ( PCIE_BASE_PTR ),
    .PCIE_CAP_CAPABILITY_ID                   ( PCIE_CAP_CAPABILITY_ID ),
    .PCIE_CAP_CAPABILITY_VERSION              ( PCIE_CAP_CAPABILITY_VERSION ),
    .PCIE_CAP_DEVICE_PORT_TYPE                ( PCIE_CAP_DEVICE_PORT_TYPE ),
    .PCIE_CAP_NEXTPTR                         ( PCIE_CAP_NEXTPTR ),
    .PCIE_CAP_ON                              ( PCIE_CAP_ON ),
    .PCIE_CAP_RSVD_15_14                      ( PCIE_CAP_RSVD_15_14 ),
    .PCIE_CAP_SLOT_IMPLEMENTED                ( PCIE_CAP_SLOT_IMPLEMENTED ),
    .PCIE_REVISION                            ( PCIE_REVISION ),
    .PL_AUTO_CONFIG                           ( PL_AUTO_CONFIG ),

    // synthesis translate_off
    .PL_FAST_TRAIN                            ( "TRUE" ),
    // synthesis translate_on

    .PM_ASPML0S_TIMEOUT                       ( PM_ASPML0S_TIMEOUT ),
    .PM_ASPML0S_TIMEOUT_EN                    ( PM_ASPML0S_TIMEOUT_EN ),
    .PM_ASPML0S_TIMEOUT_FUNC                  ( PM_ASPML0S_TIMEOUT_FUNC ),
    .PM_ASPM_FASTEXIT                         ( PM_ASPM_FASTEXIT ),
    .PM_BASE_PTR                              ( PM_BASE_PTR ),
    .PM_CAP_AUXCURRENT                        ( PM_CAP_AUXCURRENT ),
    .PM_CAP_D1SUPPORT                         ( PM_CAP_D1SUPPORT ),
    .PM_CAP_D2SUPPORT                         ( PM_CAP_D2SUPPORT ),
    .PM_CAP_DSI                               ( PM_CAP_DSI ),
    .PM_CAP_ID                                ( PM_CAP_ID ),
    .PM_CAP_NEXTPTR                           ( PM_CAP_NEXTPTR ),
    .PM_CAP_ON                                ( PM_CAP_ON ),
    .PM_CAP_PME_CLOCK                         ( PM_CAP_PME_CLOCK ),
    .PM_CAP_PMESUPPORT                        ( PM_CAP_PMESUPPORT ),
    .PM_CAP_RSVD_04                           ( PM_CAP_RSVD_04 ),
    .PM_CAP_VERSION                           ( PM_CAP_VERSION ),
    .PM_CSR_B2B3                              ( PM_CSR_B2B3 ),
    .PM_CSR_BPCCEN                            ( PM_CSR_BPCCEN ),
    .PM_CSR_NOSOFTRST                         ( PM_CSR_NOSOFTRST ),
    .PM_DATA0                                 ( PM_DATA0 ),
    .PM_DATA_SCALE0                           ( PM_DATA_SCALE0 ),
    .PM_MF                                    ( PM_MF ),
    .RBAR_BASE_PTR                            ( RBAR_BASE_PTR ),
    .RBAR_CAP_CONTROL_ENCODEDBAR0             ( RBAR_CAP_CONTROL_ENCODEDBAR0 ),
    .RBAR_CAP_CONTROL_ENCODEDBAR1             ( RBAR_CAP_CONTROL_ENCODEDBAR1 ),
    .RBAR_CAP_CONTROL_ENCODEDBAR2             ( RBAR_CAP_CONTROL_ENCODEDBAR2 ),
    .RBAR_CAP_CONTROL_ENCODEDBAR3             ( RBAR_CAP_CONTROL_ENCODEDBAR3 ),
    .RBAR_CAP_CONTROL_ENCODEDBAR4             ( RBAR_CAP_CONTROL_ENCODEDBAR4 ),
    .RBAR_CAP_CONTROL_ENCODEDBAR5             ( RBAR_CAP_CONTROL_ENCODEDBAR5 ),
    .RBAR_CAP_ID                              ( RBAR_CAP_ID),
    .RBAR_CAP_INDEX0                          ( RBAR_CAP_INDEX0 ),
    .RBAR_CAP_INDEX1                          ( RBAR_CAP_INDEX1 ),
    .RBAR_CAP_INDEX2                          ( RBAR_CAP_INDEX2 ),
    .RBAR_CAP_INDEX3                          ( RBAR_CAP_INDEX3 ),
    .RBAR_CAP_INDEX4                          ( RBAR_CAP_INDEX4 ),
    .RBAR_CAP_INDEX5                          ( RBAR_CAP_INDEX5 ),
    .RBAR_CAP_NEXTPTR                         ( RBAR_CAP_NEXTPTR ),
    .RBAR_CAP_ON                              ( RBAR_CAP_ON ),
    .RBAR_CAP_SUP0                            ( RBAR_CAP_SUP0 ),
    .RBAR_CAP_SUP1                            ( RBAR_CAP_SUP1 ),
    .RBAR_CAP_SUP2                            ( RBAR_CAP_SUP2 ),
    .RBAR_CAP_SUP3                            ( RBAR_CAP_SUP3 ),
    .RBAR_CAP_SUP4                            ( RBAR_CAP_SUP4 ),
    .RBAR_CAP_SUP5                            ( RBAR_CAP_SUP5 ),
    .RBAR_CAP_VERSION                         ( RBAR_CAP_VERSION ),
    .RBAR_NUM                                 ( RBAR_NUM ),
    .RECRC_CHK                                ( RECRC_CHK ),
    .RECRC_CHK_TRIM                           ( RECRC_CHK_TRIM ),
    .ROOT_CAP_CRS_SW_VISIBILITY               ( ROOT_CAP_CRS_SW_VISIBILITY ),
    .RP_AUTO_SPD                              ( RP_AUTO_SPD ),
    .RP_AUTO_SPD_LOOPCNT                      ( RP_AUTO_SPD_LOOPCNT ),
    .SELECT_DLL_IF                            ( SELECT_DLL_IF ),
    .SLOT_CAP_ATT_BUTTON_PRESENT              ( SLOT_CAP_ATT_BUTTON_PRESENT ),
    .SLOT_CAP_ATT_INDICATOR_PRESENT           ( SLOT_CAP_ATT_INDICATOR_PRESENT ),
    .SLOT_CAP_ELEC_INTERLOCK_PRESENT          ( SLOT_CAP_ELEC_INTERLOCK_PRESENT ),
    .SLOT_CAP_HOTPLUG_CAPABLE                 ( SLOT_CAP_HOTPLUG_CAPABLE ),
    .SLOT_CAP_HOTPLUG_SURPRISE                ( SLOT_CAP_HOTPLUG_SURPRISE ),
    .SLOT_CAP_MRL_SENSOR_PRESENT              ( SLOT_CAP_MRL_SENSOR_PRESENT ),
    .SLOT_CAP_NO_CMD_COMPLETED_SUPPORT        ( SLOT_CAP_NO_CMD_COMPLETED_SUPPORT ),
    .SLOT_CAP_PHYSICAL_SLOT_NUM               ( SLOT_CAP_PHYSICAL_SLOT_NUM ),
    .SLOT_CAP_POWER_CONTROLLER_PRESENT        ( SLOT_CAP_POWER_CONTROLLER_PRESENT ),
    .SLOT_CAP_POWER_INDICATOR_PRESENT         ( SLOT_CAP_POWER_INDICATOR_PRESENT ),
    .SLOT_CAP_SLOT_POWER_LIMIT_SCALE          ( SLOT_CAP_SLOT_POWER_LIMIT_SCALE ),
    .SLOT_CAP_SLOT_POWER_LIMIT_VALUE          ( SLOT_CAP_SLOT_POWER_LIMIT_VALUE ),
    .SSL_MESSAGE_AUTO                         ( SSL_MESSAGE_AUTO ),
    .TECRC_EP_INV                             ( TECRC_EP_INV ),
    .TL_RBYPASS                               ( TL_RBYPASS ),
    .TL_RX_RAM_RADDR_LATENCY                  ( TL_RX_RAM_RADDR_LATENCY ),
    .TL_RX_RAM_RDATA_LATENCY                  ( TL_RX_RAM_RDATA_LATENCY ),
    .TL_RX_RAM_WRITE_LATENCY                  ( TL_RX_RAM_WRITE_LATENCY ),
    .TL_TFC_DISABLE                           ( TL_TFC_DISABLE ),
    .TL_TX_CHECKS_DISABLE                     ( TL_TX_CHECKS_DISABLE ),
    .TL_TX_RAM_RADDR_LATENCY                  ( TL_TX_RAM_RADDR_LATENCY ),
    .TL_TX_RAM_RDATA_LATENCY                  ( TL_TX_RAM_RDATA_LATENCY ),
    .TL_TX_RAM_WRITE_LATENCY                  ( TL_TX_RAM_WRITE_LATENCY ),
    .TRN_DW                                   ( TRN_DW ),
    .TRN_NP_FC                                ( TRN_NP_FC ),
    .UPCONFIG_CAPABLE                         ( UPCONFIG_CAPABLE ),
    .UPSTREAM_FACING                          ( UPSTREAM_FACING ),
    .UR_ATOMIC                                ( UR_ATOMIC ),
    .UR_CFG1                                  ( UR_CFG1 ),
    .UR_INV_REQ                               ( UR_INV_REQ ),
    .UR_PRS_RESPONSE                          ( UR_PRS_RESPONSE ),
    .USER_CLK2_DIV2                           ( USER_CLK2_DIV2 ),
    .USER_CLK_FREQ                            ( USER_CLK_FREQ ),
    .USE_RID_PINS                             ( USE_RID_PINS ),
    .VC0_CPL_INFINITE                         ( VC0_CPL_INFINITE ),
    .VC0_RX_RAM_LIMIT                         ( VC0_RX_RAM_LIMIT ),
    .VC0_TOTAL_CREDITS_CD                     ( VC0_TOTAL_CREDITS_CD ),
    .VC0_TOTAL_CREDITS_CH                     ( VC0_TOTAL_CREDITS_CH ),
    .VC0_TOTAL_CREDITS_NPD                    ( VC0_TOTAL_CREDITS_NPD),
    .VC0_TOTAL_CREDITS_NPH                    ( VC0_TOTAL_CREDITS_NPH ),
    .VC0_TOTAL_CREDITS_PD                     ( VC0_TOTAL_CREDITS_PD ),
    .VC0_TOTAL_CREDITS_PH                     ( VC0_TOTAL_CREDITS_PH ),
    .VC0_TX_LASTPACKET                        ( VC0_TX_LASTPACKET ),
    .VC_BASE_PTR                              ( VC_BASE_PTR ),
    .VC_CAP_ID                                ( VC_CAP_ID ),
    .VC_CAP_NEXTPTR                           ( VC_CAP_NEXTPTR ),
    .VC_CAP_ON                                ( VC_CAP_ON ),
    .VC_CAP_REJECT_SNOOP_TRANSACTIONS         ( VC_CAP_REJECT_SNOOP_TRANSACTIONS ),
    .VC_CAP_VERSION                           ( VC_CAP_VERSION ),
    .VSEC_BASE_PTR                            ( VSEC_BASE_PTR ),
    .VSEC_CAP_HDR_ID                          ( VSEC_CAP_HDR_ID ),
    .VSEC_CAP_HDR_LENGTH                      ( VSEC_CAP_HDR_LENGTH ),
    .VSEC_CAP_HDR_REVISION                    ( VSEC_CAP_HDR_REVISION ),
    .VSEC_CAP_ID                              ( VSEC_CAP_ID ),
    .VSEC_CAP_IS_LINK_VISIBLE                 ( VSEC_CAP_IS_LINK_VISIBLE ),
    .VSEC_CAP_NEXTPTR                         ( VSEC_CAP_NEXTPTR ),
    .VSEC_CAP_ON                              ( VSEC_CAP_ON ),
    .VSEC_CAP_VERSION                         ( VSEC_CAP_VERSION )
    // I/O
) pcie_block_inst (
	// AXI Interface
    .user_clk_out                               ( user_clk_out ),
    .user_reset                                 ( bridge_reset_d ),
    .user_lnk_up                                ( user_lnk_up ),

    .user_rst_n                                 ( ),
    .trn_lnk_up                                 ( trn_lnk_up ),

    .tx_buf_av                                  ( tx_buf_av ),
    .tx_err_drop                                ( tx_err_drop ),
    .tx_cfg_req                                 ( tx_cfg_req ),
    .s_axis_tx_tready                           ( s_axis_tx_tready ),
    .s_axis_tx_tdata                            ( s_axis_tx_tdata ),
    .s_axis_tx_tkeep                            ( s_axis_tx_tkeep  ),
    .s_axis_tx_tuser                            ( s_axis_tx_tuser ),
    .s_axis_tx_tlast                            ( s_axis_tx_tlast ),
    .s_axis_tx_tvalid                           ( s_axis_tx_tvalid ),
    .tx_cfg_gnt                                 ( tx_cfg_gnt ),

    .m_axis_rx_tdata                            ( m_axis_rx_tdata ),
    .m_axis_rx_tkeep                            ( m_axis_rx_tkeep ),
    .m_axis_rx_tlast                            ( m_axis_rx_tlast ),
    .m_axis_rx_tvalid                           ( m_axis_rx_tvalid ),
    .m_axis_rx_tready                           ( m_axis_rx_tready ),
    .m_axis_rx_tuser                            ( m_axis_rx_tuser ),
    .rx_np_ok                                   ( rx_np_ok ),
    .rx_np_req                                  ( rx_np_req ),

    .fc_cpld                                    ( ),
    .fc_cplh                                    ( ),
    .fc_npd                                     ( ),
    .fc_nph                                     ( ),
    .fc_pd                                      ( ),
    .fc_ph                                      ( ),
    .fc_sel                                     ( 0 ),
    .cfg_turnoff_ok                             ( cfg_turnoff_ok ),
    .cfg_received_func_lvl_rst                  ( cfg_received_func_lvl_rst ),

    .cm_rst_n                                   ( 1'b1 ),
    .func_lvl_rst_n                             ( 1'b1 ),
    .lnk_clk_en                                 ( ),
    .cfg_dev_id                                 ( cfg_dev_id ),
    .cfg_vend_id                                ( cfg_vend_id ),
    .cfg_rev_id                                 ( cfg_rev_id ),
    .cfg_subsys_id                              ( cfg_subsys_id ),
    .cfg_subsys_vend_id                         ( cfg_subsys_vend_id ),
    .cfg_pciecap_interrupt_msgnum               ( cfg_pciecap_interrupt_msgnum ),

    .cfg_bridge_serr_en                         ( ),

    .cfg_command_bus_master_enable              ( ),
    .cfg_command_interrupt_disable              ( ),
    .cfg_command_io_enable                      ( ),
    .cfg_command_mem_enable                     ( ),
    .cfg_command_serr_en                        ( ),
    .cfg_dev_control_aux_power_en               ( ),
    .cfg_dev_control_corr_err_reporting_en      ( ),
    .cfg_dev_control_enable_ro                  ( ),
    .cfg_dev_control_ext_tag_en                 ( ),
    .cfg_dev_control_fatal_err_reporting_en     ( ),
    .cfg_dev_control_max_payload                ( ),
    .cfg_dev_control_max_read_req               ( ),
    .cfg_dev_control_non_fatal_reporting_en     ( ),
    .cfg_dev_control_no_snoop_en                ( ),
    .cfg_dev_control_phantom_en                 ( ),
    .cfg_dev_control_ur_err_reporting_en        ( ),
    .cfg_dev_control2_cpl_timeout_dis           ( ),
    .cfg_dev_control2_cpl_timeout_val           ( ),
    .cfg_dev_control2_ari_forward_en            ( ),
    .cfg_dev_control2_atomic_requester_en       ( ),
    .cfg_dev_control2_atomic_egress_block       ( ),
    .cfg_dev_control2_ido_req_en                ( ),
    .cfg_dev_control2_ido_cpl_en                ( ),
    .cfg_dev_control2_ltr_en                    ( ),
    .cfg_dev_control2_tlp_prefix_block          ( ),
    .cfg_dev_status_corr_err_detected           ( ),
    .cfg_dev_status_fatal_err_detected          ( ),
    .cfg_dev_status_non_fatal_err_detected      ( ),
    .cfg_dev_status_ur_detected                 ( ),

    .cfg_mgmt_do                                ( ),
    .cfg_err_aer_headerlog_set                  ( ),
    .cfg_err_aer_headerlog                      ( 128'b0 ),
    .cfg_err_cpl_rdy                            ( ),
    .cfg_interrupt_do                           ( cfg_interrupt_do ),
    .cfg_interrupt_mmenable                     ( cfg_interrupt_mmenable ),
    .cfg_interrupt_msienable                    ( cfg_interrupt_msienable ),
    .cfg_interrupt_msixenable                   ( cfg_interrupt_msixenable ),
    .cfg_interrupt_msixfm                       ( cfg_interrupt_msixfm ),
    .cfg_interrupt_rdy                          ( cfg_interrupt_rdy ),
    .cfg_link_control_rcb                       ( ),
    .cfg_link_control_aspm_control              ( ),
    .cfg_link_control_auto_bandwidth_int_en     ( ),
    .cfg_link_control_bandwidth_int_en          ( ),
    .cfg_link_control_clock_pm_en               ( ),
    .cfg_link_control_common_clock              ( ),
    .cfg_link_control_extended_sync             ( ),
    .cfg_link_control_hw_auto_width_dis         ( ),
    .cfg_link_control_link_disable              ( ),
    .cfg_link_control_retrain_link              ( ),
    .cfg_link_status_auto_bandwidth_status      ( ),
    .cfg_link_status_bandwidth_status           ( ),
    .cfg_link_status_current_speed              ( ),
    .cfg_link_status_dll_active                 ( ),
    .cfg_link_status_link_training              ( ),
    .cfg_link_status_negotiated_width           ( ),
    .cfg_msg_data                               ( ),
    .cfg_msg_received                           ( ),
    .cfg_msg_received_assert_int_a              ( ),
    .cfg_msg_received_assert_int_b              ( ),
    .cfg_msg_received_assert_int_c              ( ),
    .cfg_msg_received_assert_int_d              ( ),
    .cfg_msg_received_deassert_int_a            ( ),
    .cfg_msg_received_deassert_int_b            ( ),
    .cfg_msg_received_deassert_int_c            ( ),
    .cfg_msg_received_deassert_int_d            ( ),
    .cfg_msg_received_err_cor                   ( ),
    .cfg_msg_received_err_fatal                 ( ),
    .cfg_msg_received_err_non_fatal             ( ),
    .cfg_msg_received_pm_as_nak                 ( ),
    .cfg_msg_received_pme_to                    ( ),
    .cfg_msg_received_pme_to_ack                ( ),
    .cfg_msg_received_pm_pme                    ( ),
    .cfg_msg_received_setslotpowerlimit         ( ),
    .cfg_msg_received_unlock                    ( ),
    .cfg_to_turnoff                             ( cfg_to_turnoff ),
    .cfg_status                                 ( cfg_status ),
    .cfg_command                                ( cfg_command ),
    .cfg_dstatus                                ( cfg_dstatus ),
    .cfg_dcommand                               ( cfg_dcommand ),
    .cfg_lstatus                                ( cfg_lstatus ),
    .cfg_lcommand                               ( cfg_lcommand ),
    .cfg_dcommand2                              ( cfg_dcommand2 ),
    .cfg_pcie_link_state                        ( cfg_pcie_link_state ),
    .cfg_pmcsr_pme_en                           ( cfg_pmcsr_pme_en ),
    .cfg_pmcsr_powerstate                       ( cfg_pmcsr_powerstate ),
    .cfg_pmcsr_pme_status                       ( cfg_pmcsr_pme_status ),
    .cfg_pm_rcv_as_req_l1_n                     ( ),
    .cfg_pm_rcv_enter_l1_n                      ( ),
    .cfg_pm_rcv_enter_l23_n                     ( ),
    .cfg_pm_rcv_req_ack_n                       ( ),
    .cfg_mgmt_rd_wr_done                        ( ),
    .cfg_slot_control_electromech_il_ctl_pulse  ( ),
    .cfg_root_control_syserr_corr_err_en        ( ),
    .cfg_root_control_syserr_non_fatal_err_en   ( ),
    .cfg_root_control_syserr_fatal_err_en       ( ),
    .cfg_root_control_pme_int_en                ( ),
    .cfg_aer_ecrc_check_en                      ( ),
    .cfg_aer_ecrc_gen_en                        ( ),
    .cfg_aer_rooterr_corr_err_reporting_en      ( ),
    .cfg_aer_rooterr_non_fatal_err_reporting_en ( ),
    .cfg_aer_rooterr_fatal_err_reporting_en     ( ),
    .cfg_aer_rooterr_corr_err_received          ( ),
    .cfg_aer_rooterr_non_fatal_err_received     ( ),
    .cfg_aer_rooterr_fatal_err_received         ( ),
    .cfg_aer_interrupt_msgnum                   ( 5'b0 ),
    .cfg_transaction                            ( ),
    .cfg_transaction_addr                       ( ),
    .cfg_transaction_type                       ( ),
    .cfg_vc_tcvc_map                            ( ),
    .cfg_mgmt_byte_en_n                         ( ~4'b0 ),
    .cfg_mgmt_di                                ( 0 ),
    .cfg_dsn                                    ( cfg_dsn ),
    .cfg_mgmt_dwaddr                            ( 0 ),
    .cfg_err_acs_n                              ( 1'b1 ),
    .cfg_err_cor_n                              ( ~1'b0 ),
    .cfg_err_cpl_abort_n                        ( ~1'b0 ),
    .cfg_err_cpl_timeout_n                      ( ~1'b0 ),
    .cfg_err_cpl_unexpect_n                     ( ~1'b0 ),
    .cfg_err_ecrc_n                             ( ~1'b0 ),
    .cfg_err_locked_n                           ( ~1'b0 ),
    .cfg_err_posted_n                           ( ~1'b0 ),
    .cfg_err_tlp_cpl_header                     ( 48'b0 ),
    .cfg_err_ur_n                               ( ~1'b0 ),
    .cfg_err_malformed_n                        ( ~1'b0 ),
    .cfg_err_poisoned_n                         ( ~1'b0 ),
    .cfg_err_atomic_egress_blocked_n            ( ~1'b0 ),
    .cfg_err_mc_blocked_n                       ( ~1'b0 ),
    .cfg_err_internal_uncor_n                   ( ~1'b0 ),
    .cfg_err_internal_cor_n                     ( ~1'b0 ),
    .cfg_err_norecovery_n                       ( ~1'b0 ),

    .cfg_interrupt_assert_n                     ( ~cfg_interrupt_assert ),
    .cfg_interrupt_di                           ( cfg_interrupt_di ),
    .cfg_interrupt_n                            ( ~cfg_interrupt ),
    .cfg_interrupt_stat_n                       ( ~cfg_interrupt_stat ),
    .cfg_bus_number                             ( cfg_bus_number ),
    .cfg_device_number                          ( cfg_device_number ),
    .cfg_function_number                        ( cfg_function_number ),
    .cfg_ds_bus_number                          ( 0 ),
    .cfg_ds_device_number                       ( 0 ),
    .cfg_ds_function_number                     ( 0 ),
    .cfg_pm_send_pme_to_n                       ( 1'b1 ),
    .cfg_pm_wake_n                              ( ~cfg_pm_wake ),
    .cfg_pm_halt_aspm_l0s_n                     ( ~cfg_pm_halt_aspm_l0s ),
    .cfg_pm_halt_aspm_l1_n                      ( ~cfg_pm_halt_aspm_l1  ),
    .cfg_pm_force_state_en_n                    ( ~cfg_pm_force_state_en),
    .cfg_pm_force_state                         ( cfg_pm_force_state ),
    .cfg_force_mps                              ( 3'b0 ),
    .cfg_force_common_clock_off                 ( 1'b0 ),
    .cfg_force_extended_sync_on                 ( 1'b0 ),
    .cfg_port_number                            ( 8'b0 ),
    .cfg_mgmt_rd_en_n                           ( ~1'b0 ),
    .cfg_trn_pending                            ( cfg_trn_pending ),
    .cfg_mgmt_wr_en_n                           ( ~1'b0 ),
    .cfg_mgmt_wr_readonly_n                     ( ~1'b0 ),
    .cfg_mgmt_wr_rw1c_as_rw_n                   ( ~1'b0 ),

    .pl_initial_link_width                      ( ),
    .pl_lane_reversal_mode                      ( ),
    .pl_link_gen2_cap                           ( ),
    .pl_link_partner_gen2_supported             ( ),
    .pl_link_upcfg_cap                          ( ),
    .pl_ltssm_state                             ( pl_ltssm_state ),
    .pl_phy_lnk_up                              ( ),
    .pl_received_hot_rst                        ( ),
    .pl_rx_pm_state                             ( ),
    .pl_sel_lnk_rate                            ( ),
    .pl_sel_lnk_width                           ( ),
    .pl_tx_pm_state                             ( ),
    .pl_directed_link_auton                     ( 2'b0 ),
    .pl_directed_link_change                    ( 2'b0 ),
    .pl_directed_link_speed                     ( 2'b0 ),
    .pl_directed_link_width                     ( 2'b0 ),
    .pl_downstream_deemph_source                ( 1'b1 ), // ??? passed zero?
    .pl_upstream_prefer_deemph                  ( 1'b1 ),
    .pl_transmit_hot_rst                        ( 1'b0 ),
    .pl_directed_ltssm_new_vld                  ( 1'b0 ),
    .pl_directed_ltssm_new                      ( 6'b0 ),
    .pl_directed_ltssm_stall                    ( 1'b0 ),
    .pl_directed_change_done                    ( ),

    .phy_rdy_n                                  ( phy_rdy_n ),
    .dbg_sclr_a                                 ( ),
    .dbg_sclr_b                                 ( ),
    .dbg_sclr_c                                 ( ),
    .dbg_sclr_d                                 ( ),
    .dbg_sclr_e                                 ( ),
    .dbg_sclr_f                                 ( ),
    .dbg_sclr_g                                 ( ),
    .dbg_sclr_h                                 ( ),
    .dbg_sclr_i                                 ( ),
    .dbg_sclr_j                                 ( ),
    .dbg_sclr_k                                 ( ),

    .dbg_vec_a                                  ( ),
    .dbg_vec_b                                  ( ),
    .dbg_vec_c                                  ( ),
    .pl_dbg_vec                                 ( ),
    .trn_rdllp_data                             ( ),
    .trn_rdllp_src_rdy                          ( ),
    .dbg_mode                                   ( 2'b0 ),
    .dbg_sub_mode                               ( 1'b0 ),
    .pl_dbg_mode                                ( 3'b0 ),

    .drp_clk                                    ( 1'b1 ),
    .drp_do                                     (  ),
    .drp_rdy                                    (  ),
    .drp_addr                                   ( 9'b0 ),
    .drp_en                                     ( 1'b0 ),
    .drp_di                                     ( 16'b0 ),
    .drp_we                                     ( 1'b0 ),

    // Pipe Interface
    .pipe_clk                                   ( PIPE_PCLK_IN            ),
    .user_clk                                   ( PIPE_USERCLK1_IN            ),
    .user_clk2                                  ( PIPE_USERCLK2_IN           ),
    .pipe_rx0_polarity_gt                       ( pipe_rx0_polarity       ),
    .pipe_tx_deemph_gt                          ( pipe_tx_deemph          ),
    .pipe_tx_margin_gt                          ( pipe_tx_margin          ),
    .pipe_tx_rate_gt                            ( pipe_tx_rate            ),
    .pipe_tx_rcvr_det_gt                        ( pipe_tx_rcvr_det        ),
    .pipe_tx0_char_is_k_gt                      ( pipe_tx0_char_is_k      ),
    .pipe_tx0_compliance_gt                     ( pipe_tx0_compliance     ),
    .pipe_tx0_data_gt                           ( pipe_tx0_data           ),
    .pipe_tx0_elec_idle_gt                      ( pipe_tx0_elec_idle      ),
    .pipe_tx0_powerdown_gt                      ( pipe_tx0_powerdown      ),

    .pipe_rx0_chanisaligned_gt                  ( gt_rxchanisaligned_wire[0]  ),
    .pipe_rx0_char_is_k_gt                      ( gt_rx_data_k_wire[1:0]      ),
    .pipe_rx0_data_gt                           ( gt_rx_data_wire[15:0]           ),
    .pipe_rx0_elec_idle_gt                      ( gt_rx_elec_idle_wire[0]      ),
    .pipe_rx0_phy_status_gt                     ( gt_rx_phy_status_wire[0]     ),
    .pipe_rx0_status_gt                         ( gt_rx_status_wire[2:0]         ),
    .pipe_rx0_valid_gt                          ( gt_rx_valid_wire[0]          )
);

wire [  7:0]                       gt_rx_phy_status_wire        ;
wire [  7:0]                       gt_rxchanisaligned_wire      ;
wire [ 31:0]                       gt_rx_data_k_wire            ;
wire [255:0]                       gt_rx_data_wire              ;
wire [  7:0]                       gt_rx_elec_idle_wire         ;
wire [ 23:0]                       gt_rx_status_wire            ;
wire [  7:0]                       gt_rx_valid_wire             ;
wire [0:0]                         phystatus_rst                ;
wire                               clock_locked                 ;

// clock for pipe
pipe_clock # (
	.PCIE_USERCLK1_FREQ             ( PCIE_USERCLK1_FREQ ),
	.PCIE_USERCLK2_FREQ             ( PCIE_USERCLK2_FREQ )
) pipe_clock_i (
	.CLK_TXOUTCLK                   ( PIPE_TXOUTCLK_OUT), // Reference clock from lane 0
	.CLK_RST_N                      ( pipe_mmcm_rst_n ), // Allow system reset for error_recovery             

	.CLK_PCLK                       ( PIPE_PCLK_IN),
	.CLK_RXUSRCLK                   ( PIPE_RXUSRCLK_IN),
	.CLK_DCLK                       ( PIPE_DCLK_IN),
	.CLK_OOBCLK                     ( PIPE_OOBCLK_IN),
	.CLK_USERCLK1                   ( PIPE_USERCLK1_IN),
	.CLK_USERCLK2                   ( PIPE_USERCLK2_IN),
	.CLK_MMCM_LOCK                  ( PIPE_MMCM_LOCK_IN)
);

localparam USERCLK2_FREQ   =  (USER_CLK2_DIV2 == "FALSE") ? USER_CLK_FREQ :
										(USER_CLK_FREQ == 4) ? 3 :
										(USER_CLK_FREQ == 3) ? 2 :
										 USER_CLK_FREQ;
// GT to PIPE
pipe_wrapper # (
	.PCIE_SIM_MODE                  ( "TRUE" ),
	// synthesis translate_off
	.PCIE_SIM_SPEEDUP               ( "TRUE" ),
	// synthesis translate_on
	.PCIE_EXT_CLK                   ( PCIE_EXT_CLK ),
	.PCIE_TXBUF_EN                  ( PCIE_TXBUF_EN ),
	.PCIE_EXT_GT_COMMON             ( PCIE_EXT_GT_COMMON ),
	.EXT_CH_GT_DRP                  ( EXT_CH_GT_DRP ),
	.TX_MARGIN_FULL_0               (TX_MARGIN_FULL_0),
	.TX_MARGIN_FULL_1               (TX_MARGIN_FULL_1),
	.TX_MARGIN_FULL_2               (TX_MARGIN_FULL_2),
	.TX_MARGIN_FULL_3               (TX_MARGIN_FULL_3),
	.TX_MARGIN_FULL_4               (TX_MARGIN_FULL_4),
	.TX_MARGIN_LOW_0                (TX_MARGIN_LOW_0),
	.TX_MARGIN_LOW_1                (TX_MARGIN_LOW_1),
	.TX_MARGIN_LOW_2                (TX_MARGIN_LOW_2),
	.TX_MARGIN_LOW_3                (TX_MARGIN_LOW_3),
	.TX_MARGIN_LOW_4                (TX_MARGIN_LOW_4),
	.PCIE_ASYNC_EN                  ( PCIE_ASYNC_EN ),
	.PCIE_CHAN_BOND                 ( PCIE_CHAN_BOND ),
	.PCIE_PLL_SEL                   ( PCIE_PLL_SEL ),
	.PCIE_GT_DEVICE                 ( PCIE_GT_DEVICE ),
	.PCIE_USE_MODE                  ( PCIE_USE_MODE ),
	.PCIE_LANE                      ( LINK_CAP_MAX_LINK_WIDTH ),
	.PCIE_LPM_DFE                   ( "LPM" ),
	.PCIE_LINK_SPEED                ( 3 ),
	.PCIE_TX_EIDLE_ASSERT_DELAY     ( 3'd2 ),
	.PCIE_OOBCLK_MODE               ( 1 ),
	.PCIE_REFCLK_FREQ               ( REF_CLK_FREQ ),
	.PCIE_USERCLK1_FREQ             ( USER_CLK_FREQ +1 ),
	.PCIE_USERCLK2_FREQ             ( USERCLK2_FREQ +1 )
) pipe_wrapper_i (
	//---------- PIPE Clock & Reset Ports ------------------
	.PIPE_CLK                        ( sys_clk ),
	.PIPE_RESET_N                    ( sys_rst_n ),
	//.PIPE_PCLK                       ( pipe_clk ),
	//---------- PIPE TX Data Ports ------------------
	.PIPE_TXDATA                    ( pipe_tx0_data ),
	.PIPE_TXDATAK                   ( pipe_tx0_char_is_k ),

	.PIPE_TXP                       ( pci_exp_txp[0:0] ),
	.PIPE_TXN                       ( pci_exp_txn[0:0] ),
	//---------- PIPE RX Data Ports ------------------
	.PIPE_RXP                       ( pci_exp_rxp[0:0] ),
	.PIPE_RXN                       ( pci_exp_rxn[0:0] ),

	.PIPE_RXDATA                    ( gt_rx_data_wire[31:0] ),
	.PIPE_RXDATAK                   ( gt_rx_data_k_wire[3:0] ),
	//---------- PIPE Command Ports ------------------
	.PIPE_TXDETECTRX                ( pipe_tx_rcvr_det ),
	.PIPE_TXELECIDLE                ( pipe_tx0_elec_idle ),
	.PIPE_TXCOMPLIANCE              ( pipe_tx0_compliance ),
	.PIPE_RXPOLARITY                ( pipe_rx0_polarity ),
	.PIPE_POWERDOWN                 ( pipe_tx0_powerdown ),
	.PIPE_RATE                      ( {1'b0,pipe_tx_rate} ),
	//---------- PIPE Electrical Command Ports ------------------
	.PIPE_TXMARGIN                  ( pipe_tx_margin[2:0] ),
	.PIPE_TXSWING                   ( 0 ),
	.PIPE_TXDEEMPH                  ( {(LINK_CAP_MAX_LINK_WIDTH){pipe_tx_deemph}}),
	//---------- PIPE Status Ports -------------------
	.PIPE_RXVALID                   ( gt_rx_valid_wire[0:0] ),
	.PIPE_PHYSTATUS                 ( gt_rx_phy_status_wire[0:0] ),
	.PIPE_PHYSTATUS_RST             ( phystatus_rst ),
	.PIPE_RXELECIDLE                ( gt_rx_elec_idle_wire[0:0] ),
	.PIPE_EYESCANDATAERROR          ( ),
	.PIPE_RXSTATUS                  ( gt_rx_status_wire[2:0] ),
	//---------- PIPE User Ports ---------------------------
	.PIPE_MMCM_RST_N                ( pipe_mmcm_rst_n ),        // Async      | Async

	.PIPE_PCLK_LOCK                 ( clock_locked ),

	.PIPE_RXCHANISALIGNED           ( gt_rxchanisaligned_wire[LINK_CAP_MAX_LINK_WIDTH-1:0] ),
	//---------- External Clock Ports ---------------------------
	.PIPE_PCLK_IN                   ( PIPE_PCLK_IN ),
	.PIPE_RXUSRCLK_IN               ( PIPE_RXUSRCLK_IN ),

	.PIPE_DCLK_IN                   ( PIPE_DCLK_IN ),
	.PIPE_OOBCLK_IN                 ( PIPE_OOBCLK_IN ),
	.PIPE_MMCM_LOCK_IN              ( PIPE_MMCM_LOCK_IN ),

	.PIPE_TXOUTCLK_OUT              ( PIPE_TXOUTCLK_OUT )
);
//wire                 user_clk;
//wire                 user_clk2;
//wire                 pipe_clk;
//assign user_clk = PIPE_USERCLK1_IN;
//assign user_clk2 = PIPE_USERCLK2_IN;
//assign pipe_clk = PIPE_PCLK_IN;
endmodule
