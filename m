Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbXLQTlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbXLQTlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXLQTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:52 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2968 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760875AbXLQTbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:37 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH] include/asm-sh/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:19 -0800
Message-Id: <1197919875-5288-20-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-sh/hd64461.h   |   28 ++++++++++++++--------------
 include/asm-sh/microdev.h  |    4 ++--
 include/asm-sh/voyagergx.h |    2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/asm-sh/hd64461.h b/include/asm-sh/hd64461.h
index 342ca55..8c1353b 100644
--- a/include/asm-sh/hd64461.h
+++ b/include/asm-sh/hd64461.h
@@ -46,10 +46,10 @@
 /* CPU Data Bus Control Register */
 #define	HD64461_SCPUCR		(CONFIG_HD64461_IOBASE + 0x04)
 
-/* Base Adress Register */
+/* Base Address Register */
 #define	HD64461_LCDCBAR		(CONFIG_HD64461_IOBASE + 0x1000)
 
-/* Line increment adress */
+/* Line increment address */
 #define	HD64461_LCDCLOR		(CONFIG_HD64461_IOBASE + 0x1002)
 
 /* Controls LCD controller */
@@ -80,9 +80,9 @@
 #define	HD64461_LDR3		(CONFIG_HD64461_IOBASE + 0x101e)
 
 /* Palette Registers */
-#define	HD64461_CPTWAR		(CONFIG_HD64461_IOBASE + 0x1030)	/* Color Palette Write Adress Register */
+#define	HD64461_CPTWAR		(CONFIG_HD64461_IOBASE + 0x1030)	/* Color Palette Write Address Register */
 #define	HD64461_CPTWDR		(CONFIG_HD64461_IOBASE + 0x1032)	/* Color Palette Write Data Register */
-#define	HD64461_CPTRAR		(CONFIG_HD64461_IOBASE + 0x1034)	/* Color Palette Read Adress Register */
+#define	HD64461_CPTRAR		(CONFIG_HD64461_IOBASE + 0x1034)	/* Color Palette Read Address Register */
 #define	HD64461_CPTRDR		(CONFIG_HD64461_IOBASE + 0x1036)	/* Color Palette Read Data Register */
 
 #define	HD64461_GRDOR		(CONFIG_HD64461_IOBASE + 0x1040)	/* Display Resolution Offset Register */
@@ -97,8 +97,8 @@
 #define	HD64461_GRCFGR_COLORDEPTH8	0x01	/* Sets Colordepth 8 for Accelerator */
 
 /* Line Drawing Registers */
-#define	HD64461_LNSARH		(CONFIG_HD64461_IOBASE + 0x1046)	/* Line Start Adress Register (H) */
-#define	HD64461_LNSARL		(CONFIG_HD64461_IOBASE + 0x1048)	/* Line Start Adress Register (L) */
+#define	HD64461_LNSARH		(CONFIG_HD64461_IOBASE + 0x1046)	/* Line Start Address Register (H) */
+#define	HD64461_LNSARL		(CONFIG_HD64461_IOBASE + 0x1048)	/* Line Start Address Register (L) */
 #define	HD64461_LNAXLR		(CONFIG_HD64461_IOBASE + 0x104a)	/* Axis Pixel Length Register */
 #define	HD64461_LNDGR		(CONFIG_HD64461_IOBASE + 0x104c)	/* Diagonal Register */
 #define	HD64461_LNAXR		(CONFIG_HD64461_IOBASE + 0x104e)	/* Axial Register */
@@ -106,16 +106,16 @@
 #define	HD64461_LNMDR		(CONFIG_HD64461_IOBASE + 0x1052)	/* Line Mode Register */
 
 /* BitBLT Registers */
-#define	HD64461_BBTSSARH	(CONFIG_HD64461_IOBASE + 0x1054)	/* Source Start Adress Register (H) */
-#define	HD64461_BBTSSARL	(CONFIG_HD64461_IOBASE + 0x1056)	/* Source Start Adress Register (L) */
-#define	HD64461_BBTDSARH	(CONFIG_HD64461_IOBASE + 0x1058)	/* Destination Start Adress Register (H) */
-#define	HD64461_BBTDSARL	(CONFIG_HD64461_IOBASE + 0x105a)	/* Destination Start Adress Register (L) */
+#define	HD64461_BBTSSARH	(CONFIG_HD64461_IOBASE + 0x1054)	/* Source Start Address Register (H) */
+#define	HD64461_BBTSSARL	(CONFIG_HD64461_IOBASE + 0x1056)	/* Source Start Address Register (L) */
+#define	HD64461_BBTDSARH	(CONFIG_HD64461_IOBASE + 0x1058)	/* Destination Start Address Register (H) */
+#define	HD64461_BBTDSARL	(CONFIG_HD64461_IOBASE + 0x105a)	/* Destination Start Address Register (L) */
 #define	HD64461_BBTDWR		(CONFIG_HD64461_IOBASE + 0x105c)	/* Destination Block Width Register */
 #define	HD64461_BBTDHR		(CONFIG_HD64461_IOBASE + 0x105e)	/* Destination Block Height Register */
-#define	HD64461_BBTPARH		(CONFIG_HD64461_IOBASE + 0x1060)	/* Pattern Start Adress Register (H) */
-#define	HD64461_BBTPARL		(CONFIG_HD64461_IOBASE + 0x1062)	/* Pattern Start Adress Register (L) */
-#define	HD64461_BBTMARH		(CONFIG_HD64461_IOBASE + 0x1064)	/* Mask Start Adress Register (H) */
-#define	HD64461_BBTMARL		(CONFIG_HD64461_IOBASE + 0x1066)	/* Mask Start Adress Register (L) */
+#define	HD64461_BBTPARH		(CONFIG_HD64461_IOBASE + 0x1060)	/* Pattern Start Address Register (H) */
+#define	HD64461_BBTPARL		(CONFIG_HD64461_IOBASE + 0x1062)	/* Pattern Start Address Register (L) */
+#define	HD64461_BBTMARH		(CONFIG_HD64461_IOBASE + 0x1064)	/* Mask Start Address Register (H) */
+#define	HD64461_BBTMARL		(CONFIG_HD64461_IOBASE + 0x1066)	/* Mask Start Address Register (L) */
 #define	HD64461_BBTROPR		(CONFIG_HD64461_IOBASE + 0x1068)	/* ROP Register */
 #define	HD64461_BBTMDR		(CONFIG_HD64461_IOBASE + 0x106a)	/* BitBLT Mode Register */
 
diff --git a/include/asm-sh/microdev.h b/include/asm-sh/microdev.h
index 018332a..1aed158 100644
--- a/include/asm-sh/microdev.h
+++ b/include/asm-sh/microdev.h
@@ -17,7 +17,7 @@ extern void microdev_print_fpga_intc_status(void);
 /*
  * The following are useful macros for manipulating the interrupt
  * controller (INTC) on the CPU-board FPGA.  should be noted that there
- * is an INTC on the FPGA, and a seperate INTC on the SH4-202 core -
+ * is an INTC on the FPGA, and a separate INTC on the SH4-202 core -
  * these are two different things, both of which need to be prorammed to
  * correctly route - unfortunately, they have the same name and
  * abbreviations!
@@ -25,7 +25,7 @@ extern void microdev_print_fpga_intc_status(void);
 #define	MICRODEV_FPGA_INTC_BASE		0xa6110000ul				/* INTC base address on CPU-board FPGA */
 #define	MICRODEV_FPGA_INTENB_REG	(MICRODEV_FPGA_INTC_BASE+0ul)		/* Interrupt Enable Register on INTC on CPU-board FPGA */
 #define	MICRODEV_FPGA_INTDSB_REG	(MICRODEV_FPGA_INTC_BASE+8ul)		/* Interrupt Disable Register on INTC on CPU-board FPGA */
-#define	MICRODEV_FPGA_INTC_MASK(n)	(1ul<<(n))				/* Interupt mask to enable/disable INTC in CPU-board FPGA */
+#define	MICRODEV_FPGA_INTC_MASK(n)	(1ul<<(n))				/* Interrupt mask to enable/disable INTC in CPU-board FPGA */
 #define	MICRODEV_FPGA_INTPRI_REG(n)	(MICRODEV_FPGA_INTC_BASE+0x10+((n)/8)*8)/* Interrupt Priority Register on INTC on CPU-board FPGA */
 #define	MICRODEV_FPGA_INTPRI_LEVEL(n,x)	((x)<<(((n)%8)*4))			/* MICRODEV_FPGA_INTPRI_LEVEL(int_number, int_level) */
 #define	MICRODEV_FPGA_INTPRI_MASK(n)	(MICRODEV_FPGA_INTPRI_LEVEL((n),0xful))	/* Interrupt Priority Mask on INTC on CPU-board FPGA */
diff --git a/include/asm-sh/voyagergx.h b/include/asm-sh/voyagergx.h
index d825596..45b4547 100644
--- a/include/asm-sh/voyagergx.h
+++ b/include/asm-sh/voyagergx.h
@@ -213,7 +213,7 @@
 /* ----- Power mode 1 clock register -------------------------- */
 #define POWER_MODE1_CLOCK		(0x00004C + VOYAGER_BASE)
 
-/* ----- Power mode controll register ------------------------- */
+/* ----- Power mode control register ------------------------- */
 #define POWER_MODE_CTRL			(0x000054 + VOYAGER_BASE)
 
 /* ----- Miscellaneous Timing register ------------------------ */
-- 
1.5.3.7.949.g2221a6

