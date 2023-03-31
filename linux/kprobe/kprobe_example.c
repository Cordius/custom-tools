#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kprobes.h>
#include <linux/pci.h>

static struct kprobe kp;

static int handler_pre(struct kprobe *p, struct pt_regs *regs)
{
    struct pci_dev *dev = (struct pci_dev *)regs->di;
    dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
    pr_info("pci_dev_reset_slot_function called with %x\n", dev->device & 0xffc0);
    return 0;
}

static int __init kprobe_init(void)
{
    kp.pre_handler = handler_pre;
    kp.symbol_name = "pci_dev_reset_slot_function";
    register_kprobe(&kp);
    pr_info("kprobe registered\n");
    return 0;
}

static void __exit kprobe_exit(void)
{
    unregister_kprobe(&kp);
    pr_info("kprobe unregistered\n");
}

module_init(kprobe_init);
module_exit(kprobe_exit);

MODULE_LICENSE("GPL");
