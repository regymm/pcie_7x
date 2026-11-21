// SPDX-License-Identifier: GPL-2.0
#include <linux/module.h>
#include <linux/init.h>
#include <linux/pci.h>
#include <linux/serial_8250.h>
#include <linux/serial_reg.h>
#include <linux/io.h>

#define DRV_NAME "fpga_uart"
#define MAX_MSI_VECTORS 32
#define UART_NR 1  // Number of UARTs your board supports

static struct uart_8250_port fpga_ports;

static const struct pci_device_id fpga_uart_pci_tbl[] = {
	// Replace with your Vendor and Device ID
	{ PCI_DEVICE(0x10ee, 0x9999) },
	{ PCI_DEVICE(0x10ee, 0x0481) },
	{ 0, }
};
MODULE_DEVICE_TABLE(pci, fpga_uart_pci_tbl);

static int fpga_uart_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
	int ret;
	void __iomem *base;
	resource_size_t start, len;
	struct uart_8250_port *port;

	ret = pci_enable_device(pdev);
	if (ret)
		return ret;

	ret = pci_request_regions(pdev, DRV_NAME);
	if (ret)
		goto err_disable_device;

	pci_set_master(pdev);

	ret = pci_alloc_irq_vectors(pdev, 1, MAX_MSI_VECTORS, PCI_IRQ_MSI);
	if (ret < 0)
		goto err_release_regions;

	start = pci_resource_start(pdev, 0);
	len = pci_resource_len(pdev, 0);

	base = pci_iomap(pdev, 0, len);
	if (!base) {
		ret = -ENOMEM;
		goto err_free_irq;
	}

	port = &fpga_ports;
	memset(port, 0, sizeof(*port));

	port->port.iotype = UPIO_MEM32;
	port->port.mapbase = start;
	port->port.membase = base;
	port->port.irq = pci_irq_vector(pdev, 0); // 0 works for RPi with only one MSI vector
	/*port->port.irq = 0;*/
	/*if (!port->port.irq) {*/
		/*ret = port->port.irq;*/
		/*goto err_free_irq;*/
	/*}*/
	port->port.regshift = 2;
	/*port->port.iobase = 0;*/
	port->port.uartclk = 62500000;
	port->port.flags = UPF_FIXED_TYPE | UPF_IOREMAP | UPF_NO_THRE_TEST;
	/*port->port.flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP;*/
	/*port->port.line = -1;*/
	port->port.type = PORT_16550A;
	port->port.dev = &pdev->dev;

	ret = serial8250_register_8250_port(port);
	if (ret < 0) {
		goto err_free_uart_irq;
	}

	port->port.line = ret; // store the assigned line number
	pci_set_drvdata(pdev, port);

	dev_info(&pdev->dev, "FPGA UART registered on line %d\n", ret);

	return 0;

err_free_uart_irq:
	pci_iounmap(pdev, base);
	/*free_irq(port->port.irq, pdev);*/
err_free_irq:
	pci_free_irq_vectors(pdev);
err_release_regions:
	pci_release_regions(pdev);
err_disable_device:
	pci_disable_device(pdev);
	return ret;
}

static void fpga_uart_remove(struct pci_dev *pdev)
{
	struct uart_8250_port *port = pci_get_drvdata(pdev);

	serial8250_unregister_port(port->port.line);

	/*free_irq(port->port.irq, pdev);*/
	pci_free_irq_vectors(pdev);
	/*pci_iounmap(pdev, port->port.membase);*/
	pci_release_regions(pdev);
	pci_disable_device(pdev);

	dev_info(&pdev->dev, "FPGA UART removed\n");
}

static struct pci_driver fpga_uart_driver = {
	.name = DRV_NAME,
	.id_table = fpga_uart_pci_tbl,
	.probe = fpga_uart_probe,
	.remove = fpga_uart_remove,
};

module_pci_driver(fpga_uart_driver);

MODULE_DESCRIPTION("Custom FPGA PCIe 16550A UART Driver");
MODULE_AUTHOR("regymm");
MODULE_LICENSE("GPL");

