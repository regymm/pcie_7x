# for wavelet-lab usdr, xc7a35tcpg236-2
# 100 MHz PCIe ref clk, via IBUFDS
set_property PACKAGE_PIN B8 [get_ports {sys_clk_p}]
set_property PACKAGE_PIN A8 [get_ports {sys_clk_n}]

# GT Lanes
set_property PACKAGE_PIN B6 [get_ports {pci_exp_rxp}]
set_property PACKAGE_PIN A6 [get_ports {pci_exp_rxn}]
set_property PACKAGE_PIN B2 [get_ports {pci_exp_txp}]
set_property PACKAGE_PIN A2 [get_ports {pci_exp_txn}]

# Reset
#set_property PACKAGE_PIN ?? [get_ports {sys_rst_n}]
#set_property PULLUP true [get_ports {sys_rst_n}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sys_rst_n}]

# Debug LEDs
# LED2V5 on usdr
set_property PACKAGE_PIN G3 [get_ports {led[0]}] 
set_property IOSTANDARD LVCMOS25 [get_ports {led[0]}]
# GPLED0
set_property PACKAGE_PIN N2 [get_ports {led[1]}] 
set_property IOSTANDARD LVCMOS25 [get_ports {led[1]}]
# GPLED1
set_property PACKAGE_PIN P1 [get_ports {led[2]}] 
set_property IOSTANDARD LVCMOS25 [get_ports {led[2]}]

# Clocks for Vivado
create_clock -name pcie_100mhz_refin -period 10 [get_nets pcie_7x_top_aximm_i/sys_clk]
create_clock -name pcie_100mhz_txout -period 10 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/pipe_clock_i/PIPE_TXOUTCLK_OUT]
create_clock -name pcie_125mhz_d_rxusr_oob_p -period 8 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/pipe_clock_i/clk_125mhz]
create_clock -name pcie_250mhz_gen2 -period 4 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/pipe_clock_i/clk_250mhz]
create_clock -name pcie_62d5mhz_user1_user2 -period 16 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/pipe_clock_i/userclk1]
