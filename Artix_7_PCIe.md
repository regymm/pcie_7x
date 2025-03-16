## pcie_7x Usage Guide

#### Boards

pcie_7x supports PCIe Gen1/Gen2 x1, on AMD/Xilinx Artix 7 FPGAs with GTP transceivers. 

Depends on the chip speed grade, Gen2 may not be supported, like the xc7a100tfgg484-1 has GTP only up to 3.75Gbps, while Gen2 requires 5Gbps. I found this fact less documented. 

#### Constraints

Since GT locations are mostly fixed, it might be even easier than constraining an ordinary design -- just the REFCLK(P/N), RX(P/N), TX(P/N), and recommended RESET#. 

Boards with transceivers usually have differential oscillators, but GT REFCLK is usually selected to be the 100 MHz coming from PCIe Root Complex (PCIe gold finger). 

#### Build bitstream with Vivado or openXC7

**GUI flow**

It's just adding all the Verilog files, constraints, and set the top! 

**Makefile flow**

Maybe the first step to stay away from proprietary tools is to use the Makefile flow! 

[caas-wizard](https://github.com/FPGAOL-CE/caas-wizard) can be used to generate Makefiles (Makefiles are also in Git repo). 

**For openXC7** the [open-source toolchain for Xilinx 7-Series FPGAs](https://github.com/openXC7): 

To use openXC7 without local setup, pre-built Docker images can be used: `docker pull regymm/openxc7`


```
# Makefile gen
path/to/caasw.py --overwrite mfgen --makefile Makefile.alinx_100t.openxc7 alinx_100t.caas.conf .
path/to/caasw.py --overwrite mfgen --makefile Makefile.alinx_100t_msi.openxc7 alinx_100t_msi.caas.conf .
path/to/caasw.py --overwrite mfgen --makefile Makefile.usdr_35t.openxc7 usdr_35t.caas.conf .

# Build
docker run -it --rm -v .:/mnt regymm/openxc7 make -C /mnt -f Makefile.alinx_100t.openxc7 && mv build build.alinx_100t.openxc7
docker run -it --rm -v .:/mnt regymm/openxc7 make -C /mnt -f Makefile.alinx_100t_msi.openxc7 && mv build build.alinx_100t_msi.openxc7
docker run -it --rm -v .:/mnt regymm/openxc7 make -C /mnt -f Makefile.usdr_35t.openxc7 && mv build build.usdr_35t.openxc7
```

**For Vivado**: 

`source /opt/Xilinx/Vivado/2019.1/settings64.sh` 

```
# Makefile gen
path/to/caasw.py --backend vivado --overwrite mfgen --makefile Makefile.alinx_100t.vivado alinx_100t.caas.conf .
path/to/caasw.py --backend vivado --overwrite mfgen --makefile Makefile.alinx_100t_msi.vivado alinx_100t_msi.caas.conf .
path/to/caasw.py --backend vivado --overwrite mfgen --makefile Makefile.usdr_35t.vivado usdr_35t.caas.conf .

# Build 
make -f Makefile.alinx_100t.vivado && mv build build.alinx_100t.vivado
make -f Makefile.alinx_100t_msi.vivado && mv build build.alinx_100t_msi.vivado
make -f Makefile.usdr_35t.vivado && mv build build.usdr_35t.vivado
```

`build/top.bit` will be the bitstream, and `build/top.log` will contain the log. 

#### Test: BAR memory access

A quick test can utilize the PCIe remove and rescan. E.g. when host computer starts, the default bitstream in flash is loaded: 

```
$ lspci -s 26:00.0     
26:00.0 Memory controller: Meta Platforms, Inc. Device 0400
```

Remove it:

```
$ echo 1 > /sys/bus/pci/devices/0000:26:00.0/remove
```

Program new bitstream, and rescan:

```
echo 1 > /sys/bus/pci/rescan
```

The new device may show up. If it doesn't, do a reboot to properly reset and re-enumerate (the safe way, especially when changing BAR size, etc). Bitstream will remain loaded during reboot. 

```
$ lspci -s 26:00.0       
26:00.0 Memory controller: Xilinx Corporation Device 9999
```

Then, if a chunk of memory is connected to the endpoint, like the `pcie_7x_aximm` example, it can be accessed from PC. 

To do this, first enable the device: 

```
$ setpci -s 26:00.0 COMMAND=0x02
```

[pcimem](https://github.com/billfarrow/pcimem) can be used to access BAR memories easily from the command line. 

```
$ ./pcimem -d 25:00.0 -a 0x0000 -s 4096 -R 0 -r | hexdump # 4 KB BAR
Starting transfer on PCI device 25:00.0, resource 0:
	Address: 0x0
	Size: 4096 bytes
	Access size: 4 bytes
	File: stdout
	PCI -> HOST
0000000 3412 7856 3412 7856 3412 7856 3412 7856
*
0001000
```

The preset value in `axil_minimum.v`, 0x12345678 (beaware of endian), is read out. 

Write into BAR memory: 

```
$ ./pcimem -d 25:00.0 -a 0x000 -s 8 -R 0 -w | hexdump
Starting transfer on PCI device 25:00.0, resource 0:
	Address: 0x0
	Size: 8 bytes
	Access size: 4 bytes
	File: stdin
	HOST -> PCI
abcdefgh
```

Read back again: 

```
$ ./pcimem -d 25:00.0 -a 0x0000 -s 4096 -R 0 -r | hexdump
Starting transfer on PCI device 25:00.0, resource 0:
	Address: 0x0
	Size: 4096 bytes
	Access size: 4 bytes
	File: stdout
	PCI -> HOST
0000000 6261 6463 6665 6867 3412 7856 3412 7856
0000010 3412 7856 3412 7856 3412 7856 3412 7856
*
0000400 6261 6463 6665 6867 3412 7856 3412 7856
0000410 3412 7856 3412 7856 3412 7856 3412 7856
*
0000800 6261 6463 6665 6867 3412 7856 3412 7856
0000810 3412 7856 3412 7856 3412 7856 3412 7856
*
0000c00 6261 6463 6665 6867 3412 7856 3412 7856
0000c10 3412 7856 3412 7856 3412 7856 3412 7856
*
0001000
```

We can see the `6261 6463 6665 6867` is written to memory. The repeated value is because `[31:0]mem[255:0]` has 256 elements, thus repeats at higher memory addresses. 

And we can't read outside the BAR memory: 

```
$ ./pcimem -d 25:00.0 -a 0x0000 -s 4100 -R 0 -r | hexdump
Starting transfer on PCI device 25:00.0, resource 0:
	Address: 0x0
	Size: 4100 bytes
	Access size: 4 bytes
	File: stdout
	PCI -> HOST
0000000 3412 7856 3412 7856 3412 7856 3412 7856
*
Read outside resource space, stopping
0001000
```

#### Debug

LEDs on board can be used to show status (there's Vivado ILA, which is not available on openXC7). When things doesn't work, troubleshooting can be done in this order: 

- [ ] Check if design works in **simulation**. 
- [ ] Check if design works with **code boot without JTAG connected** / host PC **reboot**. 
- [ ] Check if design works in PCIe **Gen1** mode. 
- [ ] Check if **reset** is asserted then de-asserted on real hardware. 
- [ ] Check if **clock** output is valid on real hardware. 
- [ ] Check if **GT** initialization `[4:0]gt_reset_fsm` proceeds correctly. 
- [ ] Check if **training** `[5:0]pl_ltssm_state` proceeds correctly according to UG477. 
- [ ] Check if **link up** `user_link_up` is asserted. Check if `user_link_up` is up **momentarily**, if host PC keeps resetting. 
- [ ] Check if PCIE_2_1 Block **Ram**/Distributed Ram has correct size and is working. 

As long as the PCIe device can be shown in `lspci`, debugging becomes slightly easier. 