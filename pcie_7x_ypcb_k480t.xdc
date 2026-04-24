# for LC YPCB Kintex 480T, xc7k480tffg1156-2
# 100 MHz PCIe ref clk, via IBUFDS
set_property PACKAGE_PIN J8 [get_ports {sys_clk_p}]
set_property PACKAGE_PIN J7 [get_ports {sys_clk_n}]

# GT Lanes
set_property PACKAGE_PIN H6 [get_ports {pci_exp_rxp}]
set_property PACKAGE_PIN H5 [get_ports {pci_exp_rxn}]
set_property PACKAGE_PIN F2 [get_ports {pci_exp_txp}]
set_property PACKAGE_PIN F1 [get_ports {pci_exp_txn}]

# Reset
set_property PACKAGE_PIN Y28 [get_ports {sys_rst_n}]
set_property PULLUP true [get_ports {sys_rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_rst_n}]

# Single end 50 MHz clk
set_property PACKAGE_PIN AA28 [get_ports {clk_50}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk_50}]

# Debug LEDs
# yellow
set_property PACKAGE_PIN N30 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
# green
set_property PACKAGE_PIN M30 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
# red
set_property PACKAGE_PIN P30 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

# Clocks for Vivado
create_clock -name clk_50 -period 20 [get_nets clk_50]
create_clock -name pcie_100mhz_refin -period 10 [get_nets pcie_7x_top_aximm_i/sys_clk]
create_clock -name pcie_100mhz_txout -period 10 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/PIPE_TXOUTCLK_OUT]
create_clock -name pcie_125mhz_d_rxusr_oob_p -period 8 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/clk_125mhz]
create_clock -name pcie_250mhz_gen2 -period 4 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/clk_250mhz]
create_clock -name pcie_62d5mhz_user1_user2 -period 16 [get_nets pcie_7x_top_aximm_i/pcie_7x_i/in_module_mmcm.pipe_clock_i/userclk1]
