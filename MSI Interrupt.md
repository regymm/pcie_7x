## pcie_7x MSI Interrupt

#### FPGA Code

This can be rather straightforward -- the `pcie_7x_top_aximm_msi.v` and `axil_minimum_msi.v` gives an interrupt demo. In the AXI app, an increasing counter fires interrupts periodically. The counter and interrupt status can be access by a BAR register. 

#### Kernel Driver

Unlike BAR access, a kernel driver is required to handle MSI interrupts. `pcie_7x_msi` is a demo driver that handles interrupt, and measures the latency by the counter increase between the interrupt is fired and when the counter is read by Linux kernel driver. 

Build kernel driver (on Arch Linux, `linux-headers` needs to be installed):

```
$ make
make -C /lib/modules/6.13.5-arch1-1/build M=/home/petergu/pcie_7x_msi modules
make[1]: Entering directory '/usr/lib/modules/6.13.5-arch1-1/build'
make[2]: Entering directory '/home/petergu/pcie_7x_msi'
  CC [M]  pcie_7x_msi.o
  MODPOST Module.symvers
  CC [M]  pcie_7x_msi.mod.o
  LD [M]  pcie_7x_msi.ko
  BTF [M] pcie_7x_msi.ko
make[2]: Leaving directory '/home/petergu/pcie_7x_msi'
make[1]: Leaving directory '/usr/lib/modules/6.13.5-arch1-1/build'
```

Load:

```
$ insmod pcie_7x_msi.ko
```

Then, in dmesg:

```
[ 1075.528658] pcie_7x_msi 0000:25:00.0: Probing pcie_7x_msi driver
[ 1075.528839] pcie_7x_msi 0000:25:00.0: PCIe MSI + BAR0 Driver Loaded successfully!
[ 1076.315808] pcie_7x_msi 0000:25:00.0: MSI handled! Read BAR0[0x0]: 0x8000012c, delay 4800 ns, ioread32 3060 ns
[ 1077.389549] pcie_7x_msi 0000:25:00.0: MSI handled! Read BAR0[0x0]: 0x800000e2, delay 3616 ns, ioread32 2870 ns
[ 1078.463292] pcie_7x_msi 0000:25:00.0: MSI handled! Read BAR0[0x0]: 0x800000e2, delay 3616 ns, ioread32 2850 ns
[ 1079.537034] pcie_7x_msi 0000:25:00.0: MSI handled! Read BAR0[0x0]: 0x800000ea, delay 3744 ns, ioread32 2890 ns
```

Remove:

```
$ rmmod pcie_7x_msi
```

```
[ 1068.731608] pcie_7x_msi 0000:25:00.0: PCIe MSI + BAR0 Driver Unloaded
```

MSI interrupt can also be enabled by `setpci`, and is indicated in `lspci`:

```
setpci -s 25:00.0 04.w=6
setpci -s 25:00.0 4a.w=1
```

```
Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
```

Reference: [Debugging PCIe Issues using lspci and setpci](https://adaptivesupport.amd.com/s/article/1148199)

#### Reducing Latency

Usually, ~10 us latency is OK, and >100 us is very bad. 

`cat /proc/interrupts` can show which CPU handles the interrupt, then, 

`echo 1 > /sys/devices/system/cpu/cpu12/cpuidle/state2/disable` and `echo 1 > /sys/devices/system/cpu/cpu12/cpuidle/state1/disable`

reduces the latency from a initial ~460 us down to ~5 us, then ~3 us. Now, the main limiting factor is MMIO read delay. Enabling BAR memory prefetching is said to reduce latency. 

Kernel `6.13.5-arch1-1 #1 SMP PREEMPT_DYNAMIC Thu, 27 Feb 2025 18:09:44 +0000 x86_64 GNU/Linux` is used. It slightly outperforms the `linux-rt` kernel `6.10.2-rt14-arch1-5-rt #1 SMP PREEMPT_RT Sat, 08 Feb 2025 13:50:34 +0000 x86_64 GNU/Linux`. 
