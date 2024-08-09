```diff
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 2e7f529ec5a65..c0279fd5153ec 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -47,6 +47,7 @@ DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
  */
 extern u64 __cpu_logical_map[NR_CPUS];
 extern u64 cpu_logical_map(int cpu);
+extern u64 wzy_ts_1, wzy_ts_2;

 static inline void set_cpu_logical_map(int cpu, u64 hwid)
 {
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 186a186733dc8..7923cfcf833bb 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -136,6 +136,24 @@ SYM_CODE_START_LOCAL(preserve_boot_args)
        b       __inval_dcache_area             // tail call
 SYM_CODE_END(preserve_boot_args)

+.macro wzy_get_ts1
+    adr_l x3, wzy_ts_1
+    mrs   x4, cntvct_el0
+    str   x4, [x3]
+    dmb   sy
+    dc    ivac, x3
+.endm
+
+.macro wzy_get_ts2
+    adr_l x3, wzy_ts_2
+    mrs   x4, cntvct_el0
+    str   x4, [x3]
+    dmb   sy
+    dc    ivac, x3
+.endm
+
+
+
 /*
  * Macro to create a table entry to the next page.
  *
@@ -735,6 +753,13 @@ SYM_FUNC_START(secondary_entry)
        b       secondary_startup
 SYM_FUNC_END(secondary_entry)

+SYM_DATA_START(wzy_ts_1)
+       .quad 0
+SYM_DATA_END(wzy_ts_1)
+SYM_DATA_START(wzy_ts_2)
+       .quad 0
+SYM_DATA_END(wzy_ts_2)
+
 SYM_FUNC_START_LOCAL(secondary_startup)
        /*
         * Common entry point for secondary CPUs.
@@ -819,8 +844,10 @@ SYM_FUNC_START(__enable_mmu)
        offset_ttbr1 x1, x3
        msr     ttbr1_el1, x1                   // load TTBR1
        isb
+    wzy_get_ts1
        msr     sctlr_el1, x0
        isb
+    wzy_get_ts2
        /*
         * Invalidate the local I-cache so that any instructions fetched
         * speculatively from the PoC are discarded, since they may have
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 47b807a0a968f..5b35159e15a5f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -247,6 +247,8 @@ asmlinkage notrace void secondary_start_kernel(void)
                ops->cpu_postboot();

+       pr_info("wzy %lld\n", wzy_ts_2 - wzy_ts_1);
+
        /*
         * Log the CPU info before it is marked online and might get read.
         */
```
