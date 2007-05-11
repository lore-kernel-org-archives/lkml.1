Return-Path: <linux-kernel-owner+w=401wt.eu-S966629AbXEKTqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966629AbXEKTqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763521AbXEKTmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:42:35 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45955 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763511AbXEKTmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:42:31 -0400
Message-ID: <4644C721.501@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:42:25 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/mips/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/mips/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/mips/arc/memory.c                       |    4 ++--
 arch/mips/au1000/common/dbdma.c              |    6 +++---
 arch/mips/au1000/common/time.c               |    2 +-
 arch/mips/au1000/db1x00/board_setup.c        |    4 ++--
 arch/mips/au1000/mtx-1/board_setup.c         |    2 +-
 arch/mips/au1000/pb1200/board_setup.c        |    2 +-
 arch/mips/au1000/pb1550/board_setup.c        |    2 +-
 arch/mips/cobalt/setup.c                     |    4 ++--
 arch/mips/ddb5xxx/common/prom.c              |    4 ++--
 arch/mips/ddb5xxx/ddb5477/lcd44780.c         |    2 +-
 arch/mips/ddb5xxx/ddb5477/setup.c            |    2 +-
 arch/mips/emma2rh/markeins/irq.c             |    2 +-
 arch/mips/gt64120/momenco_ocelot/setup.c     |    4 ++--
 arch/mips/jazz/jazzdma.c                     |    2 +-
 arch/mips/jmr3927/rbhma3100/kgdb_io.c        |    2 +-
 arch/mips/kernel/binfmt_elfn32.c             |    2 +-
 arch/mips/kernel/cpu-bugs64.c                |    2 +-
 arch/mips/kernel/gdb-stub.c                  |    2 +-
 arch/mips/kernel/irixelf.c                   |    2 +-
 arch/mips/kernel/kspd.c                      |    2 +-
 arch/mips/kernel/linux32.c                   |    2 +-
 arch/mips/kernel/module.c                    |    2 +-
 arch/mips/kernel/process.c                   |    4 ++--
 arch/mips/kernel/semaphore.c                 |    2 +-
 arch/mips/kernel/setup.c                     |    4 ++--
 arch/mips/kernel/smtc.c                      |    4 ++--
 arch/mips/kernel/traps.c                     |    2 +-
 arch/mips/kernel/vpe.c                       |    2 +-
 arch/mips/math-emu/cp1emu.c                  |    2 +-
 arch/mips/math-emu/dp_mul.c                  |    2 +-
 arch/mips/math-emu/dsemul.c                  |    2 +-
 arch/mips/math-emu/sp_mul.c                  |    2 +-
 arch/mips/mips-boards/generic/time.c         |    4 ++--
 arch/mips/mips-boards/sim/sim_time.c         |    4 ++--
 arch/mips/mm/c-r4k.c                         |    4 ++--
 arch/mips/mm/c-sb1.c                         |    2 +-
 arch/mips/mm/c-tx39.c                        |    2 +-
 arch/mips/mm/sc-ip22.c                       |    2 +-
 arch/mips/mm/tlbex.c                         |    6 +++---
 arch/mips/oprofile/op_impl.h                 |    2 +-
 arch/mips/pci/fixup-emma2rh.c                |    2 +-
 arch/mips/pci/ops-bridge.c                   |    2 +-
 arch/mips/pci/pci-bcm1480.c                  |    2 +-
 arch/mips/pci/pci-ddb5477.c                  |    2 +-
 arch/mips/pci/pci-excite.c                   |    2 +-
 arch/mips/pci/pci-ip27.c                     |    2 +-
 arch/mips/pci/pci-ocelot-g.c                 |    2 +-
 arch/mips/pmc-sierra/yosemite/i2c-yosemite.h |    2 +-
 arch/mips/pmc-sierra/yosemite/smp.c          |    2 +-
 arch/mips/sgi-ip27/ip27-hubio.c              |    2 +-
 arch/mips/sibyte/sb1250/irq.c                |    2 +-
 arch/mips/sni/pcimt.c                        |    2 +-
 arch/mips/tx4927/common/tx4927_irq.c         |    4 ++--
 arch/mips/tx4938/common/prom.c               |    2 +-
 arch/mips/vr41xx/common/cmu.c                |    2 +-
 55 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/arch/mips/arc/memory.c b/arch/mips/arc/memory.c
index 83d1579..a12c356 100644
--- a/arch/mips/arc/memory.c
+++ b/arch/mips/arc/memory.c
@@ -9,7 +9,7 @@
  * PROM library functions for acquiring/using memory descriptors given to us
  * from the ARCS firmware.  This is only used when CONFIG_ARC_MEMORY is set
  * because on some machines like SGI IP27 the ARC memory configuration data
- * completly bogus and alternate easier to use mechanisms are available.
+ * completely bogus and alternate easier to use mechanisms are available.
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -27,7 +27,7 @@
 #undef DEBUG
 
 /*
- * For ARC firmware memory functions the unit of meassuring memory is always
+ * For ARC firmware memory functions the unit of measuring memory is always
  * a 4k page of memory
  */
 #define ARC_PAGE_SHIFT	12
diff --git a/arch/mips/au1000/common/dbdma.c b/arch/mips/au1000/common/dbdma.c
index 626de44..9550981 100644
--- a/arch/mips/au1000/common/dbdma.c
+++ b/arch/mips/au1000/common/dbdma.c
@@ -240,7 +240,7 @@ au1xxx_dbdma_chan_alloc(u32 srcid, u32 destid,
 	chan_tab_t	*ctp;
 	au1x_dma_chan_t *cp;
 
-	/* We do the intialization on the first channel allocation.
+	/* We do the initialization on the first channel allocation.
 	 * We have to wait because of the interrupt handler initialization
 	 * which can't be done successfully during board set up.
 	 */
@@ -551,7 +551,7 @@ au1xxx_dbdma_ring_alloc(u32 chanid, int entries)
 		dp++;
 	}
 
-	/* Make last descrptor point to the first.
+	/* Make last descriptor point to the first.
 	*/
 	dp--;
 	dp->dscr_nxtptr = DSCR_NXTPTR(virt_to_phys(ctp->chan_desc_base));
@@ -976,7 +976,7 @@ au1xxx_dbdma_put_dscr(u32 chanid, au1x_ddma_desc_t *dscr )
 	dp->dscr_source1 = dscr->dscr_source1;
 	dp->dscr_cmd1 = dscr->dscr_cmd1;
 	nbytes = dscr->dscr_cmd1;
-	/* Allow the caller to specifiy if an interrupt is generated */
+	/* Allow the caller to specify if an interrupt is generated */
 	dp->dscr_cmd0 &= ~DSCR_CMD0_IE;
 	dp->dscr_cmd0 |= dscr->dscr_cmd0 | DSCR_CMD0_V;
 	ctp->chan_ptr->ddma_dbell = 0;
diff --git a/arch/mips/au1000/common/time.c b/arch/mips/au1000/common/time.c
index fa1c62f..ff7e99e 100644
--- a/arch/mips/au1000/common/time.c
+++ b/arch/mips/au1000/common/time.c
@@ -215,7 +215,7 @@ wakeup_counter0_set(int ticks)
  * counter, if it exists.  If we don't have an accurate processor
  * speed, all of the peripherals that derive their clocks based on
  * this advertised speed will introduce error and sometimes not work
- * properly.  This function is futher convoluted to still allow configurations
+ * properly.  This function is further convoluted to still allow configurations
  * to do that in case they have really, really old silicon with a
  * write-only PLL register, that we need the 32KHz when power management
  * "wait" is enabled, and we need to detect if the 32KHz isn't present
diff --git a/arch/mips/au1000/db1x00/board_setup.c b/arch/mips/au1000/db1x00/board_setup.c
index 8b08edb..1d04a79 100644
--- a/arch/mips/au1000/db1x00/board_setup.c
+++ b/arch/mips/au1000/db1x00/board_setup.c
@@ -80,10 +80,10 @@ void __init board_setup(void)
 	/* set GPIO[210:208] instead of SSI_0 */
 	pin_func = au_readl(SYS_PINFUNC) | (u32)(1);
 
-	/* set GPIO[215:211] for LED's */
+	/* set GPIO[215:211] for LEDs */
 	pin_func |= (u32)((5<<2));
 
-	/* set GPIO[214:213] for more LED's */
+	/* set GPIO[214:213] for more LEDs */
 	pin_func |= (u32)((5<<12));
 
 	/* set GPIO[207:200] instead of PCMCIA/LCD */
diff --git a/arch/mips/au1000/mtx-1/board_setup.c b/arch/mips/au1000/mtx-1/board_setup.c
index 7bc5af8..2e268e8 100644
--- a/arch/mips/au1000/mtx-1/board_setup.c
+++ b/arch/mips/au1000/mtx-1/board_setup.c
@@ -99,7 +99,7 @@ mtx1_pci_idsel(unsigned int devsel, int assert)
 #endif
 
        if (assert && devsel != 0) {
-               // supress signal to cardbus
+               // suppress signal to cardbus
                au_writel( 0x00000002, SYS_OUTPUTCLR ); // set EXT_IO3 OFF
        }
        else {
diff --git a/arch/mips/au1000/pb1200/board_setup.c b/arch/mips/au1000/pb1200/board_setup.c
index 043302b..ec94c4f 100644
--- a/arch/mips/au1000/pb1200/board_setup.c
+++ b/arch/mips/au1000/pb1200/board_setup.c
@@ -69,7 +69,7 @@ void __init board_setup(void)
 	u32 pin_func;
 
 #if 0
-	/* Enable PSC1 SYNC for AC97.  Normaly done in audio driver,
+	/* Enable PSC1 SYNC for AC97.  Normally done in audio driver,
 	 * but it is board specific code, so put it here.
 	 */
 	pin_func = au_readl(SYS_PINFUNC);
diff --git a/arch/mips/au1000/pb1550/board_setup.c b/arch/mips/au1000/pb1550/board_setup.c
index 05fd27d..77038f2 100644
--- a/arch/mips/au1000/pb1550/board_setup.c
+++ b/arch/mips/au1000/pb1550/board_setup.c
@@ -54,7 +54,7 @@ void __init board_setup(void)
 {
 	u32 pin_func;
 
-	/* Enable PSC1 SYNC for AC97.  Normaly done in audio driver,
+	/* Enable PSC1 SYNC for AC97.  Normally done in audio driver,
 	 * but it is board specific code, so put it here.
 	 */
 	pin_func = au_readl(SYS_PINFUNC);
diff --git a/arch/mips/cobalt/setup.c b/arch/mips/cobalt/setup.c
index d0dd817..338aa20 100644
--- a/arch/mips/cobalt/setup.c
+++ b/arch/mips/cobalt/setup.c
@@ -63,8 +63,8 @@ void __init plat_timer_setup(struct irqaction *irq)
 
 /*
  * Cobalt doesn't have PS/2 keyboard/mouse interfaces,
- * keyboard conntroller is never used.
- * Also PCI-ISA bridge DMA contoroller is never used.
+ * keyboard controller is never used.
+ * Also PCI-ISA bridge DMA controller is never used.
  */
 static struct resource cobalt_reserved_resources[] = {
 	{	/* dma1 */
diff --git a/arch/mips/ddb5xxx/common/prom.c b/arch/mips/ddb5xxx/common/prom.c
index 54a857b..05ab6b0 100644
--- a/arch/mips/ddb5xxx/common/prom.c
+++ b/arch/mips/ddb5xxx/common/prom.c
@@ -83,7 +83,7 @@ void ddb5477_runtime_detection(void)
            around just after that.
          */
 
-	/* We can only use the PCI bus to distinquish between
+	/* We can only use the PCI bus to distinguish between
 	   the Rockhopper and RockhopperII backplanes and this must
 	   wait until ddb5477_board_init() in setup.c after the 5477
 	   is initialized.  So, until then handle
@@ -105,7 +105,7 @@ void ddb5477_runtime_detection(void)
                 *test_offset = TESTVAL2;
                 if (*test_offset != TESTVAL2) {
                         /* OK, we couldn't set this value either, so it must
-                           definately be a BSB_VR0300 */
+                           definitely be a BSB_VR0300 */
 			mips_machtype = MACH_NEC_ROCKHOPPER;
                 } else {
                         /* We could change the value twice, so it must be
diff --git a/arch/mips/ddb5xxx/ddb5477/lcd44780.c b/arch/mips/ddb5xxx/ddb5477/lcd44780.c
index 9510b9a..6fd9e88 100644
--- a/arch/mips/ddb5xxx/ddb5477/lcd44780.c
+++ b/arch/mips/ddb5xxx/ddb5477/lcd44780.c
@@ -71,7 +71,7 @@ void lcd44780_puts(const char* s)
 		}
 		if (pos == 16) {
 		  /* We have filled all 16 character positions, so stop
-		     outputing data */
+		     outputting data */
 		  break;
 		}
 	}
diff --git a/arch/mips/ddb5xxx/ddb5477/setup.c b/arch/mips/ddb5xxx/ddb5477/setup.c
index f0cc0e8..23c730c 100644
--- a/arch/mips/ddb5xxx/ddb5477/setup.c
+++ b/arch/mips/ddb5xxx/ddb5477/setup.c
@@ -350,7 +350,7 @@ static void __init ddb5477_board_init(void)
 
 		/*
 		 * positive decode (bit6 -0)
-		 * enable IDE controler interrupt (bit 4 -1)
+		 * enable IDE controller interrupt (bit 4 -1)
 		 * setup SIRQ to point to IRQ 14 (bit 3:0 - 1101)
 		 */
 		pci_write_config_byte(&dev_m1533, 0x44, 0x1d);
diff --git a/arch/mips/emma2rh/markeins/irq.c b/arch/mips/emma2rh/markeins/irq.c
index 6bcf6a0..dd50753 100644
--- a/arch/mips/emma2rh/markeins/irq.c
+++ b/arch/mips/emma2rh/markeins/irq.c
@@ -93,7 +93,7 @@ void __init arch_init_irq(void)
 	/* disable interrupt */
 	reg = emma2rh_in32(EMMA2RH_GPIO_INT_MASK);
 	emma2rh_out32(EMMA2RH_GPIO_INT_MASK, reg & ~GPIO_PCI);
-	/* level triggerd */
+	/* level triggered */
 	reg = emma2rh_in32(EMMA2RH_GPIO_INT_MODE);
 	emma2rh_out32(EMMA2RH_GPIO_INT_MODE, reg | GPIO_PCI);
 	reg = emma2rh_in32(EMMA2RH_GPIO_INT_CND_A);
diff --git a/arch/mips/gt64120/momenco_ocelot/setup.c b/arch/mips/gt64120/momenco_ocelot/setup.c
index 98b6fb3..73528ee 100644
--- a/arch/mips/gt64120/momenco_ocelot/setup.c
+++ b/arch/mips/gt64120/momenco_ocelot/setup.c
@@ -187,7 +187,7 @@ void __init plat_mem_setup(void)
 	GT_WRITE(GT_PCI0M1LD_OFS, 0x36000000 >> 21);
 
 	/* For the initial programming, we assume 512MB configuration */
-	/* Relocate the CPU's view of the RAM... */
+	/* Relocate the CPUs view of the RAM... */
 	GT_WRITE(GT_SCS10LD_OFS, 0);
 	GT_WRITE(GT_SCS10HD_OFS, 0x0fe00000 >> 21);
 	GT_WRITE(GT_SCS32LD_OFS, 0x10000000 >> 21);
@@ -239,7 +239,7 @@ void __init plat_mem_setup(void)
 	switch(tmpword &3) {
 	case 3:
 		/* 512MiB */
-		/* Decoders are allready set -- just add the
+		/* Decoders are already set -- just add the
 		 * appropriate region */
 		add_memory_region( 0x40<<20,  0xC0<<20, BOOT_MEM_RAM);
 		add_memory_region(0x100<<20, 0x100<<20, BOOT_MEM_RAM);
diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index e8e0ffb..a186963 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -177,7 +177,7 @@ EXPORT_SYMBOL(vdma_alloc);
 /*
  * Free previously allocated dma translation pages
  * Note that this does NOT change the translation table,
- * it just marks the free'd pages as unused!
+ * it just marks the freed pages as unused!
  */
 int vdma_free(unsigned long laddr)
 {
diff --git a/arch/mips/jmr3927/rbhma3100/kgdb_io.c b/arch/mips/jmr3927/rbhma3100/kgdb_io.c
index 2604f2c..264e99e 100644
--- a/arch/mips/jmr3927/rbhma3100/kgdb_io.c
+++ b/arch/mips/jmr3927/rbhma3100/kgdb_io.c
@@ -70,7 +70,7 @@ unsigned char getDebugChar(void)
 		debugInit(38400);
 	}
 
-	/* diable RX int. */
+	/* disable RX int. */
 	dicr = tx3927_sioptr(0)->dicr;
 	tx3927_sioptr(0)->dicr = 0;
 
diff --git a/arch/mips/kernel/binfmt_elfn32.c b/arch/mips/kernel/binfmt_elfn32.c
index 9b34238..77db347 100644
--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -98,7 +98,7 @@ static __inline__ void
 jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 {
 	/*
-	 * Convert jiffies to nanoseconds and seperate with
+	 * Convert jiffies to nanoseconds and separate with
 	 * one divide.
 	 */
 	u64 nsec = (u64)jiffies * TICK_NSEC;
diff --git a/arch/mips/kernel/cpu-bugs64.c b/arch/mips/kernel/cpu-bugs64.c
index c09337b..29435fe 100644
--- a/arch/mips/kernel/cpu-bugs64.c
+++ b/arch/mips/kernel/cpu-bugs64.c
@@ -64,7 +64,7 @@ static inline void mult_sh_align_mod(long *v1, long *v2, long *w,
 		: "0" (5), "1" (8), "2" (5));
 	align_mod(align, mod);
 	/*
-	 * The trailing nop is needed to fullfill the two-instruction
+	 * The trailing nop is needed to fulfill the two-instruction
 	 * requirement between reading hi/lo and staring a mult/div.
 	 * Leaving it out may cause gas insert a nop itself breaking
 	 * the desired alignment of the next chunk.
diff --git a/arch/mips/kernel/gdb-stub.c b/arch/mips/kernel/gdb-stub.c
index 7bc8820..c9d9c14 100644
--- a/arch/mips/kernel/gdb-stub.c
+++ b/arch/mips/kernel/gdb-stub.c
@@ -116,7 +116,7 @@
  *    (gdb) target remote /dev/ttyS1
  *    ...at this point you are connected to
  *       the remote target and can use gdb
- *       in the normal fasion. Setting
+ *       in the normal fashion. Setting
  *       breakpoints, single stepping,
  *       printing variables, etc.
  */
diff --git a/arch/mips/kernel/irixelf.c b/arch/mips/kernel/irixelf.c
index 403d96f..03cc100 100644
--- a/arch/mips/kernel/irixelf.c
+++ b/arch/mips/kernel/irixelf.c
@@ -421,7 +421,7 @@ static int verify_binary(struct elfhdr *ehp, struct linux_binprm *bprm)
 	/* XXX Don't support N32 or 64bit binaries yet because they can
 	 * XXX and do execute 64 bit instructions and expect all registers
 	 * XXX to be 64 bit as well.  We need to make the kernel save
-	 * XXX all registers as 64bits on cpu's capable of this at
+	 * XXX all registers as 64bits on CPUs capable of this at
 	 * XXX exception time plus frob the XTLB exception vector.
 	 */
 	if ((ehp->e_flags & EF_MIPS_ABI2))
diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index c658001..953898c 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -222,7 +222,7 @@ void sp_work_handle_request(void)
 		}
 	}
 
-	/* Run the syscall at the priviledge of the user who loaded the
+	/* Run the syscall at the privilege of the user who loaded the
 	   SP program */
 
 	if (vpe_getuid(SP_VPE))
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 37849ed..842ce03 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -383,7 +383,7 @@ sys32_ipc (u32 call, int first, int second, int third, u32 ptr, u32 fifth)
 #ifdef CONFIG_MIPS32_N32
 asmlinkage long sysn32_semctl(int semid, int semnum, int cmd, u32 arg)
 {
-	/* compat_sys_semctl expects a pointer to union semun */
+	/* compat_sys_semctl expects a pointer to union semnum */
 	u32 __user *uptr = compat_alloc_user_space(sizeof(u32));
 	if (put_user(arg, uptr))
 		return -EFAULT;
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index cb08014..e7ed0ac 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -381,7 +381,7 @@ const struct exception_table_entry *search_module_dbetables(unsigned long addr)
 	return e;
 }
 
-/* Put in dbe list if neccessary. */
+/* Put in dbe list if necessary. */
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 6bdfb5a..07688de 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -311,7 +311,7 @@ static int get_frame_info(struct mips_frame_info *info)
 		return 0;
 	if (info->pc_offset < 0) /* leaf */
 		return 1;
-	/* prologue seems boggus... */
+	/* prologue seems bogus... */
 err:
 	return -1;
 }
@@ -397,7 +397,7 @@ unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
 	if (!kallsyms_lookup_size_offset(pc, &size, &ofs))
 		return 0;
 	/*
-	 * Return ra if an exception occured at the first instruction
+	 * Return ra if an exception occurred at the first instruction
 	 */
 	if (unlikely(ofs == 0)) {
 		pc = *ra;
diff --git a/arch/mips/kernel/semaphore.c b/arch/mips/kernel/semaphore.c
index 1265358..b363604 100644
--- a/arch/mips/kernel/semaphore.c
+++ b/arch/mips/kernel/semaphore.c
@@ -33,7 +33,7 @@
  *	return old_count;
  *
  * On machines without lld/scd we need a spinlock to make the manipulation of
- * sem->count and sem->waking atomic.  Scalability isn't an issue because
+ * sem->count and sem->waking atomic.  Scalibility isn't an issue because
  * this lock is used on UP only so it's just an empty variable.
  */
 static inline int __sem_update_count(struct semaphore *sem, int incr)
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 4975da0..5bfbc01 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -395,13 +395,13 @@ static void __init bootmem_init(void)
 #endif	/* CONFIG_SGI_IP27 */
 
 /*
- * arch_mem_init - initialize memory managment subsystem
+ * arch_mem_init - initialize memory management subsystem
  *
  *  o plat_mem_setup() detects the memory configuration and will record detected
  *    memory areas using add_memory_region.
  *
  * At this stage the memory configuration of the system is known to the
- * kernel but generic memory managment system is still entirely uninitialized.
+ * kernel but generic memory management system is still entirely uninitialized.
  *
  *  o bootmem_init()
  *  o sparse_init()
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index b361edb..cca40e7 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -64,7 +64,7 @@ asiduse smtc_live_asid[MAX_SMTC_TLBS][MAX_SMTC_ASIDS];
 unsigned int ipi_timer_latch[NR_CPUS];
 
 /*
- * Number of InterProcessor Interupt (IPI) message buffers to allocate
+ * Number of InterProcessor Interrupt (IPI) message buffers to allocate
  */
 
 #define IPIBUF_PER_CPU 4
@@ -1284,7 +1284,7 @@ void smtc_flush_tlb_asid(unsigned long asid)
 		if ((ehi & ASID_MASK) == asid) {
 		    /*
 		     * Invalidate only entries with specified ASID,
-		     * makiing sure all entries differ.
+		     * making sure all entries differ.
 		     */
 		    write_c0_entryhi(CKSEG0 + (entry << (PAGE_SHIFT + 1)));
 		    write_c0_entrylo0(0);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index ff45a4b..c29dbc7 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1433,7 +1433,7 @@ void __init trap_init(void)
 
 	/*
 	 * Copy the generic exception handlers to their final destination.
-	 * This will be overriden later as suitable for a particular
+	 * This will be overridden later as suitable for a particular
 	 * configuration.
 	 */
 	set_handler(0x180, &except_vec3_generic, 0x80);
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index c9ee9d2..affa2b7 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -19,7 +19,7 @@
  * VPE support module
  *
  * Provides support for loading a MIPS SP program on VPE1.
- * The SP enviroment is rather simple, no tlb's.  It needs to be relocatable
+ * The SP environment is rather simple, no tlb's.  It needs to be relocatable
  * (or partially linked). You should initialise your stack in the startup
  * code. This loader looks for the symbol __start and sets up
  * execution to resume from there. The MIPS SDE kit contains suitable examples.
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index 80531b3..266020a 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -741,7 +741,7 @@ static int fpux_emu(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 		if (MIPSInst_FUNC(ir) != pfetch_op) {
 			return SIGILL;
 		}
-		/* ignore prefx operation */
+		/* ignore prefix operation */
 		break;
 
 	default:
diff --git a/arch/mips/math-emu/dp_mul.c b/arch/mips/math-emu/dp_mul.c
index f237390..ba2f9d0 100644
--- a/arch/mips/math-emu/dp_mul.c
+++ b/arch/mips/math-emu/dp_mul.c
@@ -117,7 +117,7 @@ ieee754dp ieee754dp_mul(ieee754dp x, ieee754dp y)
 		xm <<= 64 - (DP_MBITS + 1);
 		ym <<= 64 - (DP_MBITS + 1);
 
-		/* multiply 32bits xm,ym to give high 32bits rm with stickness
+		/* multiply 32bits xm,ym to give high 32bits rm with stickiness
 		 */
 
 		/* 32 * 32 => 64 */
diff --git a/arch/mips/math-emu/dsemul.c b/arch/mips/math-emu/dsemul.c
index ea6ba72..78f5609 100644
--- a/arch/mips/math-emu/dsemul.c
+++ b/arch/mips/math-emu/dsemul.c
@@ -35,7 +35,7 @@
  * According to the spec:
  * 1) it shouldnt be a branch :-)
  * 2) it can be a COP instruction :-(
- * 3) if we are tring to run a protected memory space we must take
+ * 3) if we are trying to run a protected memory space we must take
  *    special care on memory access instructions :-(
  */
 
diff --git a/arch/mips/math-emu/sp_mul.c b/arch/mips/math-emu/sp_mul.c
index 3f070f8..b610aad 100644
--- a/arch/mips/math-emu/sp_mul.c
+++ b/arch/mips/math-emu/sp_mul.c
@@ -118,7 +118,7 @@ ieee754sp ieee754sp_mul(ieee754sp x, ieee754sp y)
 		xm <<= 32 - (SP_MBITS + 1);
 		ym <<= 32 - (SP_MBITS + 1);
 
-		/* multiply 32bits xm,ym to give high 32bits rm with stickness
+		/* multiply 32bits xm,ym to give high 32bits rm with stickiness
 		 */
 		{
 			unsigned short lxm = xm & 0xffff;
diff --git a/arch/mips/mips-boards/generic/time.c b/arch/mips/mips-boards/generic/time.c
index df2a2bd..238c195 100644
--- a/arch/mips/mips-boards/generic/time.c
+++ b/arch/mips/mips-boards/generic/time.c
@@ -175,7 +175,7 @@ irqreturn_t mips_timer_interrupt(int irq, void *dev_id)
 		/*
 		 * FIXME: need to cope with counter underflow.
 		 * More support needs to be added to kernel/time for
-		 * counter/timer interrupts on multiple CPU's
+		 * counter/timer interrupts on multiple CPUs
 		 */
 		write_c0_compare(read_c0_count() + (mips_hpt_frequency/HZ));
 
@@ -289,7 +289,7 @@ void __init plat_timer_setup(struct irqaction *irq)
 
 #ifdef CONFIG_SMP
 	/* irq_desc(riptor) is a global resource, when the interrupt overlaps
-	   on seperate cpu's the first one tries to handle the second interrupt.
+	   on separate CPUs the first one tries to handle the second interrupt.
 	   The effect is that the int remains disabled on the second cpu.
 	   Mark the interrupt with IRQ_PER_CPU to avoid any confusion */
 	irq_desc[mips_cpu_timer_irq].status |= IRQ_PER_CPU;
diff --git a/arch/mips/mips-boards/sim/sim_time.c b/arch/mips/mips-boards/sim/sim_time.c
index d3a21c7..3f382b4 100644
--- a/arch/mips/mips-boards/sim/sim_time.c
+++ b/arch/mips/mips-boards/sim/sim_time.c
@@ -44,7 +44,7 @@ irqreturn_t sim_timer_interrupt(int irq, void *dev_id)
 		/*
 		 * FIXME: need to cope with counter underflow.
 		 * More support needs to be added to kernel/time for
-		 * counter/timer interrupts on multiple CPU's
+		 * counter/timer interrupts on multiple CPUs
 		 */
 		write_c0_compare (read_c0_count() + ( mips_hpt_frequency/HZ));
 	}
@@ -193,7 +193,7 @@ void __init plat_timer_setup(struct irqaction *irq)
 
 #ifdef CONFIG_SMP
 	/* irq_desc(riptor) is a global resource, when the interrupt overlaps
-	   on seperate cpu's the first one tries to handle the second interrupt.
+	   on separate CPUs the first one tries to handle the second interrupt.
 	   The effect is that the int remains disabled on the second cpu.
 	   Mark the interrupt with IRQ_PER_CPU to avoid any confusion */
 	irq_desc[mips_cpu_timer_irq].flags |= IRQ_PER_CPU;
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index df04a31..4c1e4df 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -426,7 +426,7 @@ static inline void local_r4k_flush_cache_page(void *args)
 	pte_t *ptep;
 
 	/*
-	 * If ownes no valid ASID yet, cannot possibly have gotten
+	 * If we have no valid ASID yet, we cannot possibly have got
 	 * this page into the cache.
 	 */
 	if (cpu_context(smp_processor_id(), mm) == 0)
@@ -1049,7 +1049,7 @@ static void __init setup_scache(void)
 	/*
 	 * Do the probing thing on R4000SC and R4400SC processors.  Other
 	 * processors don't have a S-cache that would be relevant to the
-	 * Linux memory managment.
+	 * Linux memory management.
 	 */
 	switch (c->cputype) {
 	case CPU_R4000SC:
diff --git a/arch/mips/mm/c-sb1.c b/arch/mips/mm/c-sb1.c
index 9ea460b..1475c15 100644
--- a/arch/mips/mm/c-sb1.c
+++ b/arch/mips/mm/c-sb1.c
@@ -134,7 +134,7 @@ static inline void __sb1_writeback_inv_dcache_range(unsigned long start,
 
 /*
  * Writeback and invalidate a range of the dcache.  With physical
- * addresseses, we don't have to worry about possible bit 12 aliasing.
+ * addresses, we don't have to worry about possible bit 12 aliasing.
  * XXXKW is it worth turning on KX and using hit ops with xkphys?
  */
 static inline void __sb1_writeback_inv_dcache_phys_range(unsigned long start,
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index 560a6de..feeba1b 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -166,7 +166,7 @@ static void tx39_flush_cache_page(struct vm_area_struct *vma, unsigned long page
 	pte_t *ptep;
 
 	/*
-	 * If ownes no valid ASID yet, cannot possibly have gotten
+	 * If we have no valid ASID yet, we cannot possibly have got
 	 * this page into the cache.
 	 */
 	if (cpu_context(smp_processor_id(), mm) == 0)
diff --git a/arch/mips/mm/sc-ip22.c b/arch/mips/mm/sc-ip22.c
index d236cf8..59a46a0 100644
--- a/arch/mips/mm/sc-ip22.c
+++ b/arch/mips/mm/sc-ip22.c
@@ -159,7 +159,7 @@ static inline int __init indy_sc_probe(void)
 	return 1;
 }
 
-/* XXX Check with wje if the Indy caches can differenciate between
+/* XXX Check with wje if the Indy caches can differentiate between
    writeback + invalidate and just invalidate.  */
 struct bcache_ops indy_sc_ops = {
 	.bc_enable = indy_sc_enable,
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 492c518..db45f1c 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -10,7 +10,7 @@
  * Copyright (C) 2006  Ralf Baechle (ralf@linux-mips.org)
  *
  * ... and the days got worse and worse and now you see
- * I've gone completly out of my mind.
+ * I've gone completely out of my mind.
  *
  * They're coming to take me a away haha
  * they're coming to take me a away hoho hihi haha
@@ -783,7 +783,7 @@ static void __init build_r3000_tlb_refill_handler(void)
  * The R4000 TLB handler is much more complicated. We have two
  * consecutive handler areas with 32 instructions space each.
  * Since they aren't used at the same time, we can overflow in the
- * other one.To keep things simple, we first assume linear space,
+ * other one. To keep things simple, we first assume linear space,
  * then we relocate it to the final handler layout as needed.
  */
 static __initdata u32 final_handler[64];
@@ -830,7 +830,7 @@ static __init void __attribute__((unused)) build_tlb_probe_entry(u32 **p)
 
 /*
  * Write random or indexed TLB entry, and care about the hazards from
- * the preceeding mtc0 and for the following eret.
+ * the preceding mtc0 and for the following eret.
  */
 enum tlb_write_entry { tlb_random, tlb_indexed };
 
diff --git a/arch/mips/oprofile/op_impl.h b/arch/mips/oprofile/op_impl.h
index fa6b4aa..82afd7c 100644
--- a/arch/mips/oprofile/op_impl.h
+++ b/arch/mips/oprofile/op_impl.h
@@ -25,7 +25,7 @@ struct op_counter_config {
 	unsigned long unit_mask;
 };
 
-/* Per-architecture configury and hooks.  */
+/* Per-architecture configuration and hooks.  */
 struct op_mips_model {
 	void (*reg_setup) (struct op_counter_config *);
 	void (*cpu_setup) (void * dummy);
diff --git a/arch/mips/pci/fixup-emma2rh.c b/arch/mips/pci/fixup-emma2rh.c
index 7abcfd1..fc01a48 100644
--- a/arch/mips/pci/fixup-emma2rh.c
+++ b/arch/mips/pci/fixup-emma2rh.c
@@ -1,6 +1,6 @@
 /*
  *  arch/mips/pci/fixup-emma2rh.c
- *      This file defines the PCI configration.
+ *      This file defines the PCI configuration.
  *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
diff --git a/arch/mips/pci/ops-bridge.c b/arch/mips/pci/ops-bridge.c
index 1fa0992..4d8cd68 100644
--- a/arch/mips/pci/ops-bridge.c
+++ b/arch/mips/pci/ops-bridge.c
@@ -19,7 +19,7 @@
  * Therefore we use type 0 accesses for now even though they won't work
  * correcly for PCI-to-PCI bridges.
  *
- * The function is complicated by the ultimate brokeness of the IOC3 chip
+ * The function is complicated by the ultimate brokenness of the IOC3 chip
  * which is used in SGI systems.  The IOC3 can only handle 32-bit PCI
  * accesses and does only decode parts of it's address space.
  */
diff --git a/arch/mips/pci/pci-bcm1480.c b/arch/mips/pci/pci-bcm1480.c
index d7b9e13..48b8e2e 100644
--- a/arch/mips/pci/pci-bcm1480.c
+++ b/arch/mips/pci/pci-bcm1480.c
@@ -207,7 +207,7 @@ static int __init bcm1480_pcibios_init(void)
 	PCIBIOS_MIN_IO = 0x00008000UL;
 	PCIBIOS_MIN_MEM = 0x01000000UL;
 
-	/* Set I/O resource limits. - unlimited for now to accomodate HT */
+	/* Set I/O resource limits. - unlimited for now to accommodate HT */
 	ioport_resource.end = 0xffffffffUL;
 	iomem_resource.end = 0xffffffffUL;
 
diff --git a/arch/mips/pci/pci-ddb5477.c b/arch/mips/pci/pci-ddb5477.c
index d071bc3..d4cab9c 100644
--- a/arch/mips/pci/pci-ddb5477.c
+++ b/arch/mips/pci/pci-ddb5477.c
@@ -159,7 +159,7 @@ int __init pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 
 	if (mips_machtype == MACH_NEC_ROCKHOPPERII) {
-		/* hack to distinquish overlapping slot 20s, one
+		/* hack to distinguish overlapping slot 20s, one
 		 * on bus 0 (ALI USB on the M1535 on the backplane),
 		 * and one on bus 2 (NEC USB controller on the CPU board)
 		 * Make the M1535 USB - ISA IRQ number 9.
diff --git a/arch/mips/pci/pci-excite.c b/arch/mips/pci/pci-excite.c
index 3c86c77..8a56876 100644
--- a/arch/mips/pci/pci-excite.c
+++ b/arch/mips/pci/pci-excite.c
@@ -131,7 +131,7 @@ static int __init basler_excite_pci_setup(void)
 		ocd_writel(0x00000000, bar + 0x100);
 	}
 
-	/* Finally, enable the PCI interupt */
+	/* Finally, enable the PCI interrupt */
 #if USB_IRQ > 7
 	set_c0_intcontrol(1 << USB_IRQ);
 #else
diff --git a/arch/mips/pci/pci-ip27.c b/arch/mips/pci/pci-ip27.c
index 405ce01..d64ec12 100644
--- a/arch/mips/pci/pci-ip27.c
+++ b/arch/mips/pci/pci-ip27.c
@@ -96,7 +96,7 @@ int __init bridge_probe(nasid_t nasid, int widget_id, int masterwid)
 	bridge->b_int_device = 0x0;
 
 	/*
-	 * swap pio's to pci mem and io space (big windows)
+	 * swap PIOs to pci mem and io space (big windows)
 	 */
 	bridge->b_wid_control |= BRIDGE_CTRL_IO_SWAP |
 	                         BRIDGE_CTRL_MEM_SWAP;
diff --git a/arch/mips/pci/pci-ocelot-g.c b/arch/mips/pci/pci-ocelot-g.c
index 1e34301..cffc684 100644
--- a/arch/mips/pci/pci-ocelot-g.c
+++ b/arch/mips/pci/pci-ocelot-g.c
@@ -16,7 +16,7 @@
 /*
  * We assume these address ranges have been programmed into the GT-64240 by
  * the firmware.  PMON in case of the Ocelot G does that.  Note the size of
- * the I/O range is completly stupid; I/O mappings are limited to at most
+ * the I/O range is completely stupid; I/O mappings are limited to at most
  * 256 bytes by the PCI spec and deprecated; and just to make things worse
  * apparently many devices don't decode more than 64k of I/O space.
  */
diff --git a/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h b/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
index 31c5523..66c3d37 100644
--- a/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
+++ b/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
@@ -38,7 +38,7 @@
 #define	TITAN_I2C_READ(offset) *(volatile unsigned long *)(TITAN_I2C_BASE + offset)
 
 
-/* Local constansts*/
+/* Local constansts */
 #define TITAN_I2C_MAX_FILTER            15
 #define TITAN_I2C_MAX_CLK               1023
 #define TITAN_I2C_MAX_ARBF              15
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
index 305491e..466bcbb 100644
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -136,7 +136,7 @@ void core_send_ipi(int cpu, unsigned int action)
 	 * based on the action desired. An alternative strategy
 	 * is to write to the Interrupt Set register, read the
 	 * Interrupt Status register and clear the Interrupt
-	 * Clear register. The latter is preffered.
+	 * Clear register. The latter is preferred.
 	 */
 	switch (action) {
 	case SMP_RESCHEDULE_YOURSELF:
diff --git a/arch/mips/sgi-ip27/ip27-hubio.c b/arch/mips/sgi-ip27/ip27-hubio.c
index 524b371..8a96a5e 100644
--- a/arch/mips/sgi-ip27/ip27-hubio.c
+++ b/arch/mips/sgi-ip27/ip27-hubio.c
@@ -132,7 +132,7 @@ static void hub_setup_prb(nasid_t nasid, int prbnum, int credits)
  * XXX - There is a bug in the crossbow that link reset PIOs do not
  * return write responses.  The easiest solution to this problem is to
  * leave widget 0 (xbow) in fire-and-forget mode at all times.  This
- * only affects pio's to xbow registers, which should be rare.
+ * only affects PIOs to xbow registers, which should be rare.
  **/
 static void hub_set_piomode(nasid_t nasid)
 {
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index 0e6a13c..729e61c 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -287,7 +287,7 @@ int sb1250_steal_irq(int irq)
  * On the second cpu, everything is set to IP5, which is
  * ignored, EXCEPT the mailbox interrupt.  That one is
  * set to IP[2] so it is handled.  This is needed so we
- * can do cross-cpu function calls, as requred by SMP
+ * can do cross-cpu function calls, as required by SMP
  */
 
 #define IMR_IP2_VAL	K_INT_MAP_I0
diff --git a/arch/mips/sni/pcimt.c b/arch/mips/sni/pcimt.c
index 9ee208d..6279141 100644
--- a/arch/mips/sni/pcimt.c
+++ b/arch/mips/sni/pcimt.c
@@ -211,7 +211,7 @@ static void pcimt_hwint1(void)
 		/*
 		 * Note: ASIC PCI's builtin interrupt achknowledge feature is
 		 * broken.  Using it may result in loss of some or all i8259
-		 * interupts, so don't use PCIMT_INT_ACKNOWLEDGE ...
+		 * interrupts, so don't use PCIMT_INT_ACKNOWLEDGE ...
 		 */
 		irq = i8259_irq();
 		if (unlikely(irq < 0))
diff --git a/arch/mips/tx4927/common/tx4927_irq.c b/arch/mips/tx4927/common/tx4927_irq.c
index 3d25d01..435048b 100644
--- a/arch/mips/tx4927/common/tx4927_irq.c
+++ b/arch/mips/tx4927/common/tx4927_irq.c
@@ -105,7 +105,7 @@ static const u32 tx4927_irq_debug_flag = (TX4927_IRQ_NONE
 #endif
 
 /*
- * Forwad definitions for all pic's
+ * Forward definitions for all PICs
  */
 
 static void tx4927_irq_cp0_enable(unsigned int irq);
@@ -115,7 +115,7 @@ static void tx4927_irq_pic_enable(unsigned int irq);
 static void tx4927_irq_pic_disable(unsigned int irq);
 
 /*
- * Kernel structs for all pic's
+ * Kernel structs for all PICs
  */
 
 #define TX4927_CP0_NAME "TX4927-CP0"
diff --git a/arch/mips/tx4938/common/prom.c b/arch/mips/tx4938/common/prom.c
index 3189a65..e3f9026 100644
--- a/arch/mips/tx4938/common/prom.c
+++ b/arch/mips/tx4938/common/prom.c
@@ -104,7 +104,7 @@ tx4938_process_sdccr(u64 * addr)
 	msize = (((rs * cs * mw) / (1024 * 1024)) * (bc));
 
 	/* MVMCP -- bc hard coded to 4 from table 9.3.1     */
-	/*          boad supports bc=2 but no way to detect */
+	/*          board supports bc=2 but no way to detect */
 
 	return (msize);
 }
diff --git a/arch/mips/vr41xx/common/cmu.c b/arch/mips/vr41xx/common/cmu.c
index 657c513..7981ffc 100644
--- a/arch/mips/vr41xx/common/cmu.c
+++ b/arch/mips/vr41xx/common/cmu.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2001-2002  MontaVista Software Inc.
  *    Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copuright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
-- 
1.5.0.1

-- 
Simon Arlott
