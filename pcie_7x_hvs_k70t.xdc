create_clock -period 8.000 -name pcie_125mhz_d_rxusr_oob_p [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/clk_125mhz_BUFG]
create_clock -period 4.000 -name pcie_250mhz_gen2 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/clk_250mhz_BUFG]
# for HVS Kintex 70T, xc7k70tfbg676-1
# 100 MHz PCIe ref clk, via IBUFDS
set_property PACKAGE_PIN D6 [get_ports sys_clk_p]
set_property PACKAGE_PIN D5 [get_ports sys_clk_n]

# GT Lanes
set_property PACKAGE_PIN G3 [get_ports pci_exp_rxn]
set_property PACKAGE_PIN G4 [get_ports pci_exp_rxp]
set_property PACKAGE_PIN F1 [get_ports pci_exp_txn]
set_property PACKAGE_PIN F2 [get_ports pci_exp_txp]

# 200 MHz clk in


# Reset
#set_property PACKAGE_PIN ?? [get_ports {sys_rst_n}]
#set_property PULLUP true [get_ports {sys_rst_n}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sys_rst_n}]

# Debug LEDs
set_property PACKAGE_PIN E15 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E16 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN E17 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN E18 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

# Clocks for Vivado
create_clock -period 10.000 -name pcie_100mhz_refin [get_nets pcie_7x_top_aximm_i/sys_clk]
create_clock -period 16.000 -name pcie_62d5mhz_user1_user2 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/userclk1]

# BUFG drives GT
#set_property IS_ENABLED 0 [get_drc_checks {REQP-56}]
#set_property IS_ENABLED 0 [get_drc_checks {REQP-52}]

