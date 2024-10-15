
# 100 MHz PCIe ref clk, via IBUFDS
set_property PACKAGE_PIN F10 [get_ports {sys_clk_p}]
set_property PACKAGE_PIN E10 [get_ports {sys_clk_n}]

set_property PACKAGE_PIN D11 [get_ports {pci_exp_rxp}]
set_property PACKAGE_PIN C11 [get_ports {pci_exp_rxn}]
set_property PACKAGE_PIN D5 [get_ports {pci_exp_txp}]
set_property PACKAGE_PIN C5 [get_ports {pci_exp_txn}]

set_property PACKAGE_PIN J20 [get_ports {sys_rst_n}]
set_property PULLUP true [get_ports {sys_rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_rst_n}]

#set_property LOC IBUFDS_GTE2_X0Y3 [get_cells {refclk_ibuf}]

create_clock -name sys_clk -period 10 [get_ports sys_clk_p]

create_clock -name pcie_7x_0_sys_clk -period 10 [get_ports sys_clk]
# 100/125/250 MHz

create_clock -name pcie_7x_0_pclk -period 8 [get_ports pipe_pclk_in]
# 125/250 MHz

create_clock -name pcie_7x_0_rxusrclk -period 8 [get_ports pipe_rxusrclk_in]
# 125/250 MHz 

create_clock -name pcie_7x_0_dclk -period 8 [get_ports pipe_dclk_in]
# 125 MHz

create_clock -name pcie_7x_0_usrclk1 -period 16 [get_ports pipe_userclk1_in]
create_clock -name pcie_7x_0_usrclk2 -period 16 [get_ports pipe_userclk2_in]

create_clock -name pcie_7x_0_oobclk -period 8 [get_ports pipe_oobclk_in]
# 50 MHz , 125/250 MHz

set_false_path -from [get_ports sys_rst_n]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~PLPHYLNKUPN} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ * }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~PLRECEIVEDHOTRST} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ * }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~RXELECIDLE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~TXPHINITDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~TXPHALIGNDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~TXDLYSRESETDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~RXDLYSRESETDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~RXPHALIGNDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~RXCDRLOCK} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~CFGMSGRECEIVEDPMETO} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ * }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~PLL0LOCK} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~RXPMARESETDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~RXSYNCDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]
set_false_path -through [get_pins -filter {REF_PIN_NAME=~TXSYNCDONE} -of_objects [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ IO.gt.* }]]

