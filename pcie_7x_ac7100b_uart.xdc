# for AC7100B and TimeCard, xc7a100tffg484-1
# 100 MHz PCIe ref clk, via IBUFDS
set_property PACKAGE_PIN F10 [get_ports sys_clk_p]
set_property PACKAGE_PIN E10 [get_ports sys_clk_n]

# GT Lanes
set_property PACKAGE_PIN C11 [get_ports pci_exp_rxn]
set_property PACKAGE_PIN D11 [get_ports pci_exp_rxp]
set_property PACKAGE_PIN C5 [get_ports pci_exp_txn]
set_property PACKAGE_PIN D5 [get_ports pci_exp_txp]

# Reset
set_property PACKAGE_PIN J20 [get_ports sys_rst_n]
set_property PULLTYPE PULLUP [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

# Debug LEDs
set_property PACKAGE_PIN B13 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN C13 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN D14 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN D15 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

# SMA for RX/TX
set_property PACKAGE_PIN Y11 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN W12 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

# Buf enable N for SMAs
set_property PACKAGE_PIN H15 [get_ports sma1inN]
set_property IOSTANDARD LVCMOS33 [get_ports sma1inN]
set_property PACKAGE_PIN H14 [get_ports sma2outN]
set_property IOSTANDARD LVCMOS33 [get_ports sma2outN]


# Clocks for Vivado
create_clock -period 10.000 -name pcie_100mhz_refin [get_nets sys_clk]
create_clock -name pcie_100mhz_txout -period 10 [get_nets pcie_7x_i/pipe_clock_i/PIPE_TXOUTCLK_OUT]
create_clock -name pcie_125mhz_d_rxusr_oob_p -period 8 [get_nets pcie_7x_i/pipe_clock_i/clk_125mhz]
create_clock -name pcie_250mhz_gen2 -period 4 [get_nets pcie_7x_i/pipe_clock_i/clk_250mhz]
create_clock -name pcie_62d5mhz_user1_user2 -period 16 [get_nets pcie_7x_i/pipe_clock_i/userclk1]




#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list pcie_7x_i/in_module_mmcm.pipe_clock_i/userclk1_i1.usrclk1_i1_0]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 30 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {axil2mm_inst/s_axi_araddr[2]} {axil2mm_inst/s_axi_araddr[3]} {axil2mm_inst/s_axi_araddr[4]} {axil2mm_inst/s_axi_araddr[5]} {axil2mm_inst/s_axi_araddr[6]} {axil2mm_inst/s_axi_araddr[7]} {axil2mm_inst/s_axi_araddr[8]} {axil2mm_inst/s_axi_araddr[9]} {axil2mm_inst/s_axi_araddr[10]} {axil2mm_inst/s_axi_araddr[11]} {axil2mm_inst/s_axi_araddr[12]} {axil2mm_inst/s_axi_araddr[13]} {axil2mm_inst/s_axi_araddr[14]} {axil2mm_inst/s_axi_araddr[15]} {axil2mm_inst/s_axi_araddr[16]} {axil2mm_inst/s_axi_araddr[17]} {axil2mm_inst/s_axi_araddr[18]} {axil2mm_inst/s_axi_araddr[19]} {axil2mm_inst/s_axi_araddr[20]} {axil2mm_inst/s_axi_araddr[21]} {axil2mm_inst/s_axi_araddr[22]} {axil2mm_inst/s_axi_araddr[23]} {axil2mm_inst/s_axi_araddr[24]} {axil2mm_inst/s_axi_araddr[25]} {axil2mm_inst/s_axi_araddr[26]} {axil2mm_inst/s_axi_araddr[27]} {axil2mm_inst/s_axi_araddr[28]} {axil2mm_inst/s_axi_araddr[29]} {axil2mm_inst/s_axi_araddr[30]} {axil2mm_inst/s_axi_araddr[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 2 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {axil2mm_inst/s_axi_bresp[0]} {axil2mm_inst/s_axi_bresp[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 2 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {axil2mm_inst/s_axi_rresp[0]} {axil2mm_inst/s_axi_rresp[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 32 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {axil2mm_inst/s_axi_wdata[0]} {axil2mm_inst/s_axi_wdata[1]} {axil2mm_inst/s_axi_wdata[2]} {axil2mm_inst/s_axi_wdata[3]} {axil2mm_inst/s_axi_wdata[4]} {axil2mm_inst/s_axi_wdata[5]} {axil2mm_inst/s_axi_wdata[6]} {axil2mm_inst/s_axi_wdata[7]} {axil2mm_inst/s_axi_wdata[8]} {axil2mm_inst/s_axi_wdata[9]} {axil2mm_inst/s_axi_wdata[10]} {axil2mm_inst/s_axi_wdata[11]} {axil2mm_inst/s_axi_wdata[12]} {axil2mm_inst/s_axi_wdata[13]} {axil2mm_inst/s_axi_wdata[14]} {axil2mm_inst/s_axi_wdata[15]} {axil2mm_inst/s_axi_wdata[16]} {axil2mm_inst/s_axi_wdata[17]} {axil2mm_inst/s_axi_wdata[18]} {axil2mm_inst/s_axi_wdata[19]} {axil2mm_inst/s_axi_wdata[20]} {axil2mm_inst/s_axi_wdata[21]} {axil2mm_inst/s_axi_wdata[22]} {axil2mm_inst/s_axi_wdata[23]} {axil2mm_inst/s_axi_wdata[24]} {axil2mm_inst/s_axi_wdata[25]} {axil2mm_inst/s_axi_wdata[26]} {axil2mm_inst/s_axi_wdata[27]} {axil2mm_inst/s_axi_wdata[28]} {axil2mm_inst/s_axi_wdata[29]} {axil2mm_inst/s_axi_wdata[30]} {axil2mm_inst/s_axi_wdata[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 32 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list {axil2mm_inst/s_axi_rdata[0]} {axil2mm_inst/s_axi_rdata[1]} {axil2mm_inst/s_axi_rdata[2]} {axil2mm_inst/s_axi_rdata[3]} {axil2mm_inst/s_axi_rdata[4]} {axil2mm_inst/s_axi_rdata[5]} {axil2mm_inst/s_axi_rdata[6]} {axil2mm_inst/s_axi_rdata[7]} {axil2mm_inst/s_axi_rdata[8]} {axil2mm_inst/s_axi_rdata[9]} {axil2mm_inst/s_axi_rdata[10]} {axil2mm_inst/s_axi_rdata[11]} {axil2mm_inst/s_axi_rdata[12]} {axil2mm_inst/s_axi_rdata[13]} {axil2mm_inst/s_axi_rdata[14]} {axil2mm_inst/s_axi_rdata[15]} {axil2mm_inst/s_axi_rdata[16]} {axil2mm_inst/s_axi_rdata[17]} {axil2mm_inst/s_axi_rdata[18]} {axil2mm_inst/s_axi_rdata[19]} {axil2mm_inst/s_axi_rdata[20]} {axil2mm_inst/s_axi_rdata[21]} {axil2mm_inst/s_axi_rdata[22]} {axil2mm_inst/s_axi_rdata[23]} {axil2mm_inst/s_axi_rdata[24]} {axil2mm_inst/s_axi_rdata[25]} {axil2mm_inst/s_axi_rdata[26]} {axil2mm_inst/s_axi_rdata[27]} {axil2mm_inst/s_axi_rdata[28]} {axil2mm_inst/s_axi_rdata[29]} {axil2mm_inst/s_axi_rdata[30]} {axil2mm_inst/s_axi_rdata[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 3 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list {uart16550_inst/a[0]} {uart16550_inst/a[1]} {uart16550_inst/a[2]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 4 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list {uart16550_inst/bitpos_rx[0]} {uart16550_inst/bitpos_rx[1]} {uart16550_inst/bitpos_rx[2]} {uart16550_inst/bitpos_rx[3]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 24 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list {uart16550_inst/d[0]} {uart16550_inst/d[1]} {uart16550_inst/d[2]} {uart16550_inst/d[3]} {uart16550_inst/d[4]} {uart16550_inst/d[5]} {uart16550_inst/d[6]} {uart16550_inst/d[7]} {uart16550_inst/d[8]} {uart16550_inst/d[9]} {uart16550_inst/d[10]} {uart16550_inst/d[11]} {uart16550_inst/d[12]} {uart16550_inst/d[13]} {uart16550_inst/d[14]} {uart16550_inst/d[15]} {uart16550_inst/d[16]} {uart16550_inst/d[17]} {uart16550_inst/d[18]} {uart16550_inst/d[19]} {uart16550_inst/d[20]} {uart16550_inst/d[21]} {uart16550_inst/d[22]} {uart16550_inst/d[23]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 8 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list {uart16550_inst/rbr[0]} {uart16550_inst/rbr[1]} {uart16550_inst/rbr[2]} {uart16550_inst/rbr[3]} {uart16550_inst/rbr[4]} {uart16550_inst/rbr[5]} {uart16550_inst/rbr[6]} {uart16550_inst/rbr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
#set_property port_width 8 [get_debug_ports u_ila_0/probe9]
#connect_debug_port u_ila_0/probe9 [get_nets [list {uart16550_inst/spr[0]} {uart16550_inst/spr[1]} {uart16550_inst/spr[2]} {uart16550_inst/spr[3]} {uart16550_inst/spr[4]} {uart16550_inst/spr[5]} {uart16550_inst/spr[6]} {uart16550_inst/spr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
#set_property port_width 8 [get_debug_ports u_ila_0/probe10]
#connect_debug_port u_ila_0/probe10 [get_nets [list {uart16550_inst/msr[0]} {uart16550_inst/msr[1]} {uart16550_inst/msr[2]} {uart16550_inst/msr[3]} {uart16550_inst/msr[4]} {uart16550_inst/msr[5]} {uart16550_inst/msr[6]} {uart16550_inst/msr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
#set_property port_width 8 [get_debug_ports u_ila_0/probe11]
#connect_debug_port u_ila_0/probe11 [get_nets [list {uart16550_inst/fcr[0]} {uart16550_inst/fcr[1]} {uart16550_inst/fcr[2]} {uart16550_inst/fcr[3]} {uart16550_inst/fcr[4]} {uart16550_inst/fcr[5]} {uart16550_inst/fcr[6]} {uart16550_inst/fcr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
#set_property port_width 8 [get_debug_ports u_ila_0/probe12]
#connect_debug_port u_ila_0/probe12 [get_nets [list {uart16550_inst/ier[0]} {uart16550_inst/ier[1]} {uart16550_inst/ier[2]} {uart16550_inst/ier[3]} {uart16550_inst/ier[4]} {uart16550_inst/ier[5]} {uart16550_inst/ier[6]} {uart16550_inst/ier[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
#set_property port_width 8 [get_debug_ports u_ila_0/probe13]
#connect_debug_port u_ila_0/probe13 [get_nets [list {uart16550_inst/mcr[0]} {uart16550_inst/mcr[1]} {uart16550_inst/mcr[2]} {uart16550_inst/mcr[3]} {uart16550_inst/mcr[4]} {uart16550_inst/mcr[5]} {uart16550_inst/mcr[6]} {uart16550_inst/mcr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
#set_property port_width 8 [get_debug_ports u_ila_0/probe14]
#connect_debug_port u_ila_0/probe14 [get_nets [list {uart16550_inst/dlm[0]} {uart16550_inst/dlm[1]} {uart16550_inst/dlm[2]} {uart16550_inst/dlm[3]} {uart16550_inst/dlm[4]} {uart16550_inst/dlm[5]} {uart16550_inst/dlm[6]} {uart16550_inst/dlm[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
#set_property port_width 16 [get_debug_ports u_ila_0/probe15]
#connect_debug_port u_ila_0/probe15 [get_nets [list {uart16550_inst/rx_count[0]} {uart16550_inst/rx_count[1]} {uart16550_inst/rx_count[2]} {uart16550_inst/rx_count[3]} {uart16550_inst/rx_count[4]} {uart16550_inst/rx_count[5]} {uart16550_inst/rx_count[6]} {uart16550_inst/rx_count[7]} {uart16550_inst/rx_count[8]} {uart16550_inst/rx_count[9]} {uart16550_inst/rx_count[10]} {uart16550_inst/rx_count[11]} {uart16550_inst/rx_count[12]} {uart16550_inst/rx_count[13]} {uart16550_inst/rx_count[14]} {uart16550_inst/rx_count[15]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
#set_property port_width 8 [get_debug_ports u_ila_0/probe16]
#connect_debug_port u_ila_0/probe16 [get_nets [list {uart16550_inst/rx_fifo_data[0]} {uart16550_inst/rx_fifo_data[1]} {uart16550_inst/rx_fifo_data[2]} {uart16550_inst/rx_fifo_data[3]} {uart16550_inst/rx_fifo_data[4]} {uart16550_inst/rx_fifo_data[5]} {uart16550_inst/rx_fifo_data[6]} {uart16550_inst/rx_fifo_data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
#set_property port_width 8 [get_debug_ports u_ila_0/probe17]
#connect_debug_port u_ila_0/probe17 [get_nets [list {uart16550_inst/lsr[0]} {uart16550_inst/lsr[1]} {uart16550_inst/lsr[2]} {uart16550_inst/lsr[3]} {uart16550_inst/lsr[4]} {uart16550_inst/lsr[5]} {uart16550_inst/lsr[6]} {uart16550_inst/lsr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
#set_property port_width 8 [get_debug_ports u_ila_0/probe18]
#connect_debug_port u_ila_0/probe18 [get_nets [list {uart16550_inst/lcr[0]} {uart16550_inst/lcr[1]} {uart16550_inst/lcr[2]} {uart16550_inst/lcr[3]} {uart16550_inst/lcr[4]} {uart16550_inst/lcr[5]} {uart16550_inst/lcr[6]} {uart16550_inst/lcr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
#set_property port_width 8 [get_debug_ports u_ila_0/probe19]
#connect_debug_port u_ila_0/probe19 [get_nets [list {uart16550_inst/iir[0]} {uart16550_inst/iir[1]} {uart16550_inst/iir[2]} {uart16550_inst/iir[3]} {uart16550_inst/iir[4]} {uart16550_inst/iir[5]} {uart16550_inst/iir[6]} {uart16550_inst/iir[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
#set_property port_width 16 [get_debug_ports u_ila_0/probe20]
#connect_debug_port u_ila_0/probe20 [get_nets [list {uart16550_inst/sample[0]} {uart16550_inst/sample[1]} {uart16550_inst/sample[2]} {uart16550_inst/sample[3]} {uart16550_inst/sample[4]} {uart16550_inst/sample[5]} {uart16550_inst/sample[6]} {uart16550_inst/sample[7]} {uart16550_inst/sample[8]} {uart16550_inst/sample[9]} {uart16550_inst/sample[10]} {uart16550_inst/sample[11]} {uart16550_inst/sample[12]} {uart16550_inst/sample[13]} {uart16550_inst/sample[14]} {uart16550_inst/sample[15]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
#set_property port_width 2 [get_debug_ports u_ila_0/probe21]
#connect_debug_port u_ila_0/probe21 [get_nets [list {uart16550_inst/state_rx[0]} {uart16550_inst/state_rx[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
#set_property port_width 8 [get_debug_ports u_ila_0/probe22]
#connect_debug_port u_ila_0/probe22 [get_nets [list {uart16550_inst/dll[0]} {uart16550_inst/dll[1]} {uart16550_inst/dll[2]} {uart16550_inst/dll[3]} {uart16550_inst/dll[4]} {uart16550_inst/dll[5]} {uart16550_inst/dll[6]} {uart16550_inst/dll[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
#set_property port_width 8 [get_debug_ports u_ila_0/probe23]
#connect_debug_port u_ila_0/probe23 [get_nets [list {uart16550_inst/data[0]} {uart16550_inst/data[1]} {uart16550_inst/data[2]} {uart16550_inst/data[3]} {uart16550_inst/data[4]} {uart16550_inst/data[5]} {uart16550_inst/data[6]} {uart16550_inst/data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
#set_property port_width 32 [get_debug_ports u_ila_0/probe24]
#connect_debug_port u_ila_0/probe24 [get_nets [list {uart16550_inst/spo[0]} {uart16550_inst/spo[1]} {uart16550_inst/spo[2]} {uart16550_inst/spo[3]} {uart16550_inst/spo[4]} {uart16550_inst/spo[5]} {uart16550_inst/spo[6]} {uart16550_inst/spo[7]} {uart16550_inst/spo[8]} {uart16550_inst/spo[9]} {uart16550_inst/spo[10]} {uart16550_inst/spo[11]} {uart16550_inst/spo[12]} {uart16550_inst/spo[13]} {uart16550_inst/spo[14]} {uart16550_inst/spo[15]} {uart16550_inst/spo[16]} {uart16550_inst/spo[17]} {uart16550_inst/spo[18]} {uart16550_inst/spo[19]} {uart16550_inst/spo[20]} {uart16550_inst/spo[21]} {uart16550_inst/spo[22]} {uart16550_inst/spo[23]} {uart16550_inst/spo[24]} {uart16550_inst/spo[25]} {uart16550_inst/spo[26]} {uart16550_inst/spo[27]} {uart16550_inst/spo[28]} {uart16550_inst/spo[29]} {uart16550_inst/spo[30]} {uart16550_inst/spo[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
#set_property port_width 4 [get_debug_ports u_ila_0/probe25]
#connect_debug_port u_ila_0/probe25 [get_nets [list {uart16550_inst/rx_filled[0]} {uart16550_inst/rx_filled[1]} {uart16550_inst/rx_filled[2]} {uart16550_inst/rx_filled[3]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
#set_property port_width 8 [get_debug_ports u_ila_0/probe26]
#connect_debug_port u_ila_0/probe26 [get_nets [list {uart16550_inst/tmp_rx[0]} {uart16550_inst/tmp_rx[1]} {uart16550_inst/tmp_rx[2]} {uart16550_inst/tmp_rx[3]} {uart16550_inst/tmp_rx[4]} {uart16550_inst/tmp_rx[5]} {uart16550_inst/tmp_rx[6]} {uart16550_inst/tmp_rx[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
#set_property port_width 8 [get_debug_ports u_ila_0/probe27]
#connect_debug_port u_ila_0/probe27 [get_nets [list {uart16550_inst/thr[0]} {uart16550_inst/thr[1]} {uart16550_inst/thr[2]} {uart16550_inst/thr[3]} {uart16550_inst/thr[4]} {uart16550_inst/thr[5]} {uart16550_inst/thr[6]} {uart16550_inst/thr[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
#set_property port_width 8 [get_debug_ports u_ila_0/probe28]
#connect_debug_port u_ila_0/probe28 [get_nets [list {uart16550_inst/tx_fifo_data[0]} {uart16550_inst/tx_fifo_data[1]} {uart16550_inst/tx_fifo_data[2]} {uart16550_inst/tx_fifo_data[3]} {uart16550_inst/tx_fifo_data[4]} {uart16550_inst/tx_fifo_data[5]} {uart16550_inst/tx_fifo_data[6]} {uart16550_inst/tx_fifo_data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
#set_property port_width 30 [get_debug_ports u_ila_0/probe29]
#connect_debug_port u_ila_0/probe29 [get_nets [list {axil2mm_inst/s_axi_awaddr[2]} {axil2mm_inst/s_axi_awaddr[3]} {axil2mm_inst/s_axi_awaddr[4]} {axil2mm_inst/s_axi_awaddr[5]} {axil2mm_inst/s_axi_awaddr[6]} {axil2mm_inst/s_axi_awaddr[7]} {axil2mm_inst/s_axi_awaddr[8]} {axil2mm_inst/s_axi_awaddr[9]} {axil2mm_inst/s_axi_awaddr[10]} {axil2mm_inst/s_axi_awaddr[11]} {axil2mm_inst/s_axi_awaddr[12]} {axil2mm_inst/s_axi_awaddr[13]} {axil2mm_inst/s_axi_awaddr[14]} {axil2mm_inst/s_axi_awaddr[15]} {axil2mm_inst/s_axi_awaddr[16]} {axil2mm_inst/s_axi_awaddr[17]} {axil2mm_inst/s_axi_awaddr[18]} {axil2mm_inst/s_axi_awaddr[19]} {axil2mm_inst/s_axi_awaddr[20]} {axil2mm_inst/s_axi_awaddr[21]} {axil2mm_inst/s_axi_awaddr[22]} {axil2mm_inst/s_axi_awaddr[23]} {axil2mm_inst/s_axi_awaddr[24]} {axil2mm_inst/s_axi_awaddr[25]} {axil2mm_inst/s_axi_awaddr[26]} {axil2mm_inst/s_axi_awaddr[27]} {axil2mm_inst/s_axi_awaddr[28]} {axil2mm_inst/s_axi_awaddr[29]} {axil2mm_inst/s_axi_awaddr[30]} {axil2mm_inst/s_axi_awaddr[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
#set_property port_width 1 [get_debug_ports u_ila_0/probe30]
#connect_debug_port u_ila_0/probe30 [get_nets [list uart16550_inst/irq]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
#set_property port_width 1 [get_debug_ports u_ila_0/probe31]
#connect_debug_port u_ila_0/probe31 [get_nets [list uart16550_inst/rd]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
#set_property port_width 1 [get_debug_ports u_ila_0/probe32]
#connect_debug_port u_ila_0/probe32 [get_nets [list uart16550_inst/ready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
#set_property port_width 1 [get_debug_ports u_ila_0/probe33]
#connect_debug_port u_ila_0/probe33 [get_nets [list uart16550_inst/rx_fifo_deq]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
#set_property port_width 1 [get_debug_ports u_ila_0/probe34]
#connect_debug_port u_ila_0/probe34 [get_nets [list uart16550_inst/rx_fifo_empty]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
#set_property port_width 1 [get_debug_ports u_ila_0/probe35]
#connect_debug_port u_ila_0/probe35 [get_nets [list uart16550_inst/rx_fifo_enq]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
#set_property port_width 1 [get_debug_ports u_ila_0/probe36]
#connect_debug_port u_ila_0/probe36 [get_nets [list uart16550_inst/rx_fifo_full]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
#set_property port_width 1 [get_debug_ports u_ila_0/probe37]
#connect_debug_port u_ila_0/probe37 [get_nets [list uart16550_inst/rx_r]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
#set_property port_width 1 [get_debug_ports u_ila_0/probe38]
#connect_debug_port u_ila_0/probe38 [get_nets [list axil2mm_inst/s_axi_arready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
#set_property port_width 1 [get_debug_ports u_ila_0/probe39]
#connect_debug_port u_ila_0/probe39 [get_nets [list axil2mm_inst/s_axi_arvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
#set_property port_width 1 [get_debug_ports u_ila_0/probe40]
#connect_debug_port u_ila_0/probe40 [get_nets [list axil2mm_inst/s_axi_awready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
#set_property port_width 1 [get_debug_ports u_ila_0/probe41]
#connect_debug_port u_ila_0/probe41 [get_nets [list axil2mm_inst/s_axi_awvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
#set_property port_width 1 [get_debug_ports u_ila_0/probe42]
#connect_debug_port u_ila_0/probe42 [get_nets [list axil2mm_inst/s_axi_bvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
#set_property port_width 1 [get_debug_ports u_ila_0/probe43]
#connect_debug_port u_ila_0/probe43 [get_nets [list axil2mm_inst/s_axi_rvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
#set_property port_width 1 [get_debug_ports u_ila_0/probe44]
#connect_debug_port u_ila_0/probe44 [get_nets [list axil2mm_inst/s_axi_wready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
#set_property port_width 1 [get_debug_ports u_ila_0/probe45]
#connect_debug_port u_ila_0/probe45 [get_nets [list axil2mm_inst/s_axi_wvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
#set_property port_width 1 [get_debug_ports u_ila_0/probe46]
#connect_debug_port u_ila_0/probe46 [get_nets [list uart16550_inst/tx_fifo_empty]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
#set_property port_width 1 [get_debug_ports u_ila_0/probe47]
#connect_debug_port u_ila_0/probe47 [get_nets [list uart16550_inst/tx_fifo_enq]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
#set_property port_width 1 [get_debug_ports u_ila_0/probe48]
#connect_debug_port u_ila_0/probe48 [get_nets [list uart16550_inst/tx_fifo_full]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
#set_property port_width 1 [get_debug_ports u_ila_0/probe49]
#connect_debug_port u_ila_0/probe49 [get_nets [list uart16550_inst/tx_r]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
#set_property port_width 1 [get_debug_ports u_ila_0/probe50]
#connect_debug_port u_ila_0/probe50 [get_nets [list uart16550_inst/txclk_en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
#set_property port_width 1 [get_debug_ports u_ila_0/probe51]
#connect_debug_port u_ila_0/probe51 [get_nets [list uart16550_inst/we]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets user_clk]
