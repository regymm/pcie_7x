// SPDX-License-Identifier: GPL-3.0-or-later
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/interrupt.h>
#include <linux/io.h>

#define DRIVER_NAME "pcie_7x_msi"
#define PCI_VENDOR_ID_XILINX  0x10ee
#define PCI_DEVICE_ID_CUSTOM  0x9999

struct pcie_7x_dev {
    struct pci_dev *pdev;
    int irq;
    void __iomem *bar0;
};

static irqreturn_t pcie_7x_msi_handler(int irq, void *dev_id)
{
    struct pcie_7x_dev *pcie_dev = (struct pcie_7x_dev *)dev_id;
    u32 bar0_value;

    // Read from BAR0 (offset 0x0)
    u64 start_ns, end_ns;
    start_ns = ktime_get_ns();
    bar0_value = ioread32(pcie_dev->bar0);
    end_ns = ktime_get_ns();
    // 62.5 MHz FPGA counter clock, 16 ns per count
    dev_info(&pcie_dev->pdev->dev, "MSI handled! Read BAR0[0x0]: 0x%08x, delay %d ns, ioread32 %llu ns\n", bar0_value, (bar0_value & 0x1FFFFFF)*16, (end_ns - start_ns));

    return IRQ_HANDLED;
}

static int pcie_7x_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
    struct pcie_7x_dev *pcie_dev;
    int err;

    dev_info(&pdev->dev, "Probing %s driver\n", DRIVER_NAME);

    // Enable PCI device
    err = pci_enable_device(pdev);
    if (err) {
        dev_err(&pdev->dev, "Failed to enable PCI device\n");
        return err;
    }

    // Enable bus mastering (setpci -s xx:00.0 04.w=6)
    pci_set_master(pdev);

    // Allocate driver struct
    pcie_dev = devm_kzalloc(&pdev->dev, sizeof(*pcie_dev), GFP_KERNEL);
    if (!pcie_dev) {
        err = -ENOMEM;
        goto err_disable_device;
    }
    pcie_dev->pdev = pdev;
    pci_set_drvdata(pdev, pcie_dev);

    // Map BAR0 into kernel address space
    pcie_dev->bar0 = pci_iomap(pdev, 0, 0);
    if (!pcie_dev->bar0) {
        dev_err(&pdev->dev, "Failed to map BAR0\n");
        err = -ENOMEM;
        goto err_disable_device;
    }

    // Request MSI interrupt
    err = pci_enable_msi(pdev);
    if (err) {
        dev_err(&pdev->dev, "Failed to enable MSI\n");
        goto err_unmap_bar0;
    }

    pcie_dev->irq = pdev->irq;

    // Request IRQ and register handler
    err = request_irq(pcie_dev->irq, pcie_7x_msi_handler, 0, DRIVER_NAME, pcie_dev);
    if (err) {
        dev_err(&pdev->dev, "Failed to request IRQ\n");
        goto err_disable_msi;
    }

    dev_info(&pdev->dev, "PCIe MSI + BAR0 Driver Loaded successfully!\n");
    return 0;

err_disable_msi:
    pci_disable_msi(pdev);
err_unmap_bar0:
    pci_iounmap(pdev, pcie_dev->bar0);
err_disable_device:
    pci_disable_device(pdev);
    return err;
}

static void pcie_7x_remove(struct pci_dev *pdev)
{
    struct pcie_7x_dev *pcie_dev = pci_get_drvdata(pdev);

    if (pcie_dev) {
        free_irq(pcie_dev->irq, pcie_dev);
        pci_disable_msi(pdev);
        if (pcie_dev->bar0)
            pci_iounmap(pdev, pcie_dev->bar0);
    }

    pci_disable_device(pdev);
    dev_info(&pdev->dev, "PCIe MSI + BAR0 Driver Unloaded\n");
}

static const struct pci_device_id pcie_7x_id_table[] = {
    { PCI_DEVICE(PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_CUSTOM) },
    { 0, }
};
MODULE_DEVICE_TABLE(pci, pcie_7x_id_table);

static struct pci_driver pcie_7x_driver = {
    .name = DRIVER_NAME,
    .id_table = pcie_7x_id_table,
    .probe = pcie_7x_probe,
    .remove = pcie_7x_remove,
};

module_pci_driver(pcie_7x_driver);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("regymm");
MODULE_DESCRIPTION("Xilinx 7-Series PCIe Demo Driver Using MSI + BAR0");
MODULE_VERSION("1.0");

