## pcie_7x

PCIe Endpoint on Xilinx 7-Series FPGAs using the PCIE_2_1 hard block and GTP transceivers. 

#### Structure

`src/pipe_clock.v` generates all the clocks. 

```
                          +-------------+
(PCIe refclk) sys_clk_p>--| IBUFDS_GTE2 |
100 MHz       sys_clk_n>--|             |--> sys_clk --> Goes to GTPE2_COMMON
                          +-------------+
                         
(from GTPE2_CHANNEL) +------+                    BUFG
TXOUTCLK ---|>-------| MMCM |-->125 MHz-----------|>---+--DCLK (dynamic reconfig)
100 MHz    BUFG      |      |                   BUFGCTRL
                     |      |-->125 MHz-Gen1------+\___+--RXUSRCLK (clk for RX data)                             
                     |      |-->250 MHz-Gen2------+/   +--OOBCLK (out of bond)
                     |      |                          +--PCLK (main PCIe logic)
                     |      |-->user1* 
                     |      |-->user2* 
                     +------+
                                   *usually 62.5 MHz/125 MHz for Gen1/Gen2
```

`src/pipe_wrapper.v` contains the GTP transceiver. It's connected to the PCIE_2_1 `src/pcie_block.v` via the [PIPE interface](https://en.wikipedia.org/wiki/PCI_Express#Physical_layer). PCIE_2_1 handles from upper physical layer, data link layer, up to transaction layer. 

```
 To User Design                                                         To PCIe Lane
                     +---------------+  PIPE interface +---------------+ TX pair
AXIS TX/RX  +------+ |  PCIE_2_1     |-------/---------| GTPE2_CHANNEL |------/-----
=/==========| TRN2 |=|  Hard Block   |                 |               |------/-----
=/==========| AXIS |=|               |              +--|               | RX pair
            +------+ |               |              |  +---------------+ CLK pair
-/-------------------|               |              |+--| GTPE2_COMMON |------/-----
Configs              +---------------+              ||  |              |
                     |  RX   |  TX   |              ||  +--------------+
                     | BRAMS | BRAMS |              ||
                     +---------------+             +-------+
Reset                                              | Reset |
---------------------------------------------------|       |
                                                   +-------+
```

For PCIE_2_1 parameters and port definitions, please refer to [UG477](https://docs.amd.com/v/u/en-US/ug477_7Series_IntBlock_PCIe). 

#### Supported Boards

Alinx AC7100B SoM, Wavelet uSDR

#### Funding

This project is funded through [NGI0 Entrust](https://nlnet.nl/entrust), a fund established by [NLnet](https://nlnet.nl) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu) program. Learn more at the [NLnet project page](https://nlnet.nl/project/PTP-timingcard-gateware).

[<img src="https://nlnet.nl/logo/banner.png" alt="NLnet foundation logo" width="20%" />](https://nlnet.nl) [<img src="https://nlnet.nl/image/logos/NGI0_tag.svg" alt="NGI Zero Logo" width="20%" />](https://nlnet.nl/entrust)
