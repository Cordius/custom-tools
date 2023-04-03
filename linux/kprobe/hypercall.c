#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

#include <asm/kvm_para.h>
#include <asm/msr.h>

static unsigned long num = 1000;
module_param(num, ulong, S_IRUGO | S_IWUSR);

static int test_init(void) {
    u64 t1;
    u64 t2 = 0;
    u64 val = 0;
    unsigned long i = 0;
    unsigned long count = 0;

    for (; i < num; i++) {
        t1 = rdtsc();
        kvm_hypercall0(100);
        val = (rdtsc() - t1);
        trace_printk("val:%lld\n", val);
        if (unlikely(val > 3000))
            continue;
        count++;
        t2 += val;
    }

    pr_info("num: %ld, t2:%lld, count:%ld, avg: %lld\n", num, t2, count, t2/count);
    return -1;
}

static void test_exit(void) {
    printk(KERN_INFO "Goodbye, World!\n");
}

module_init(test_init);
module_exit(test_exit);

MODULE_LICENSE("GPL");
