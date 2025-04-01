// SPDX-License-Identifier: GPL-3.0-or-later
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/interrupt.h>
#include <linux/io.h>

#define DRIVER_NAME "pcie_7x_msi"
#define PCI_VENDOR_ID_XILINX  0x10ee
#define PCI_DEVICE_ID_CUSTOM  0x9999
#define MAX_MSI_VECTORS 32

struct pcie_7x_dev {
    struct pci_dev *pdev;
    int num_irqs;
	int irq[MAX_MSI_VECTORS];
    void __iomem *bar0;  // Mapped BAR0 base address
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
    dev_info(&pcie_dev->pdev->dev, "MSI %d handled! Read BAR0[0x0]: 0x%08x, delay %d ns, ioread32 %llu ns\n", irq, bar0_value, (bar0_value & 0x1FFFFFF)*16, (end_ns - start_ns));

    return IRQ_HANDLED;
}

static int pcie_7x_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
    struct pcie_7x_dev *pcie_dev;
    int err, i;

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
        goto err_free_pcie_dev;
    }

	// Try to allocate up to MAX_MSI_VECTORS
    // deprecated pci_enable_msi is not used
    pcie_dev->num_irqs = pci_alloc_irq_vectors(pdev, 1, MAX_MSI_VECTORS, PCI_IRQ_MSI);
	if (pcie_dev->num_irqs < 0) {
        dev_err(&pdev->dev, "Failed to allocate MSI vectors\n");
        err = pcie_dev->num_irqs;
        goto err_unmap_bar0;
    }
    dev_info(&pdev->dev, "%d MSI vectors allocated. \n", pcie_dev->num_irqs);

	// Request all available MSI interrupts
    for (i = 0; i < pcie_dev->num_irqs; i++) {
        pcie_dev->irq[i] = pci_irq_vector(pdev, i);
        err = request_irq(pcie_dev->irq[i], pcie_7x_msi_handler, 0, DRIVER_NAME, pcie_dev);
        if (err) {
            dev_err(&pdev->dev, "Failed to request IRQ %d\n", pcie_dev->irq[i]);

            // Free all previously allocated IRQs
            while (--i >= 0)
                free_irq(pcie_dev->irq[i], pcie_dev);

            goto err_free_vectors;
        }
        dev_info(&pdev->dev, "Registered handler for IRQ %d\n", pcie_dev->irq[i]);
    }

    dev_info(&pdev->dev, "PCIe Multi-Vector MSI + BAR0 Driver Loaded successfully!\n");
    return 0;

err_free_vectors:
    pci_free_irq_vectors(pdev);
err_unmap_bar0:
    pci_iounmap(pdev, pcie_dev->bar0);
err_free_pcie_dev:
    devm_kfree(&pdev->dev, pcie_dev);
err_disable_device:
    pci_disable_device(pdev);
    return err;
}

static void pcie_7x_remove(struct pci_dev *pdev)
{
    struct pcie_7x_dev *pcie_dev = pci_get_drvdata(pdev);
	int i;

    if (pcie_dev) {
		for (i = 0; i < pcie_dev->num_irqs; i++)
            free_irq(pcie_dev->irq[i], pcie_dev);
        pci_free_irq_vectors(pdev);
        if (pcie_dev->bar0)
            pci_iounmap(pdev, pcie_dev->bar0);
    }

    pci_disable_device(pdev);
    dev_info(&pdev->dev, "PCIe Multi-Vector MSI + BAR0 Driver Unloaded\n");
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
MODULE_DESCRIPTION("Xilinx 7-Series PCIe Demo Driver Using Multi-Vector MSI + BAR0");
MODULE_VERSION("1.0");

