Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZJARaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZJARaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZJARaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:30:08 -0400
Received: from monster.nessie.de ([84.200.20.120]:40423 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZJARaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:30:07 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 13:30:06 EDT
From: Michael Roth <mroth@nessie.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Roth <mroth@nessie.de>
Subject: [PATCH] Kconfig: Remove useless and sometimes wrong comments
Date: Thu,  1 Oct 2009 19:11:58 +0200
Message-Id: <1254417118-29744-1-git-send-email-mroth@nessie.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally, some excessive newlines removed.

Signed-off-by: Michael Roth <mroth@nessie.de>
---
 arch/arm/mach-s3c2400/Kconfig |    6 ------
 arch/arm/mach-s3c2410/Kconfig |    2 --
 arch/arm/mach-s3c2412/Kconfig |    4 ----
 arch/arm/mach-s3c2440/Kconfig |    3 ---
 arch/arm/mach-s3c2442/Kconfig |    4 ----
 arch/arm/mach-s3c2443/Kconfig |    2 --
 arch/arm/mach-s3c6400/Kconfig |    2 --
 arch/arm/mach-s3c6410/Kconfig |    2 --
 arch/arm/mach-s5pc100/Kconfig |    2 --
 arch/arm/plat-s3c/Kconfig     |    2 --
 arch/arm/plat-s3c24xx/Kconfig |    2 --
 arch/arm/plat-s3c64xx/Kconfig |    2 --
 arch/arm/plat-s5pc1xx/Kconfig |    2 --
 drivers/Kconfig               |    2 --
 drivers/isdn/act2000/Kconfig  |    4 ----
 drivers/isdn/capi/Kconfig     |    4 ----
 drivers/isdn/hysdn/Kconfig    |    4 ----
 drivers/isdn/icn/Kconfig      |    4 ----
 drivers/isdn/pcbit/Kconfig    |    4 ----
 drivers/isdn/sc/Kconfig       |    4 ----
 drivers/mtd/chips/Kconfig     |    3 ---
 drivers/mtd/devices/Kconfig   |    3 ---
 drivers/mtd/lpddr/Kconfig     |    3 ---
 drivers/mtd/maps/Kconfig      |    2 --
 drivers/mtd/nand/Kconfig      |    2 --
 drivers/mtd/onenand/Kconfig   |    4 ----
 drivers/mtd/ubi/Kconfig       |    2 --
 drivers/platform/Kconfig      |    2 --
 samples/Kconfig               |    3 ---
 sound/Kconfig                 |    4 ----
 sound/oss/Kconfig             |    2 --
 31 files changed, 0 insertions(+), 91 deletions(-)

diff --git a/arch/arm/mach-s3c2400/Kconfig b/arch/arm/mach-s3c2400/Kconfig
index deab072..fdd8f5e 100644
--- a/arch/arm/mach-s3c2400/Kconfig
+++ b/arch/arm/mach-s3c2400/Kconfig
@@ -1,13 +1,7 @@
-# arch/arm/mach-s3c2400/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
 
-
-
 menu "S3C2400 Machines"
 
-
 endmenu
-
diff --git a/arch/arm/mach-s3c2410/Kconfig b/arch/arm/mach-s3c2410/Kconfig
index 3d4e9da..7fcbdb9 100644
--- a/arch/arm/mach-s3c2410/Kconfig
+++ b/arch/arm/mach-s3c2410/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c2410/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
diff --git a/arch/arm/mach-s3c2412/Kconfig b/arch/arm/mach-s3c2412/Kconfig
index c2bdc46..9a8c065 100644
--- a/arch/arm/mach-s3c2412/Kconfig
+++ b/arch/arm/mach-s3c2412/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c2412/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
@@ -90,6 +88,4 @@ config MACH_VSTMS
 	help
 	  Say Y here if you are using an VSTMS board
 
-
 endmenu
-
diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index d7bba91..16f5238 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c2440/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
@@ -108,4 +106,3 @@ config MACH_MINI2440
 	  available via various sources. It can come with a 3.5" or 7" touch LCD.
 
 endmenu
-
diff --git a/arch/arm/mach-s3c2442/Kconfig b/arch/arm/mach-s3c2442/Kconfig
index 103e913..8d38118 100644
--- a/arch/arm/mach-s3c2442/Kconfig
+++ b/arch/arm/mach-s3c2442/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c2442/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
@@ -36,6 +34,4 @@ config MACH_NEO1973_GTA02
 	help
 	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM Phone
 
-
 endmenu
-
diff --git a/arch/arm/mach-s3c2443/Kconfig b/arch/arm/mach-s3c2443/Kconfig
index 212141b..4314c44 100644
--- a/arch/arm/mach-s3c2443/Kconfig
+++ b/arch/arm/mach-s3c2443/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c2443/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
diff --git a/arch/arm/mach-s3c6400/Kconfig b/arch/arm/mach-s3c6400/Kconfig
index 770b720..a250bf6 100644
--- a/arch/arm/mach-s3c6400/Kconfig
+++ b/arch/arm/mach-s3c6400/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c6400/Kconfig
-#
 # Copyright 2008 Openmoko, Inc.
 #	Simtec Electronics, Ben Dooks <ben@simtec.co.uk>
 #
diff --git a/arch/arm/mach-s3c6410/Kconfig b/arch/arm/mach-s3c6410/Kconfig
index 53fc3ff..b8c0332 100644
--- a/arch/arm/mach-s3c6410/Kconfig
+++ b/arch/arm/mach-s3c6410/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s3c6410/Kconfig
-#
 # Copyright 2008 Openmoko, Inc.
 # Copyright 2008 Simtec Electronics
 #
diff --git a/arch/arm/mach-s5pc100/Kconfig b/arch/arm/mach-s5pc100/Kconfig
index b1a4ba5..0793b9b 100644
--- a/arch/arm/mach-s5pc100/Kconfig
+++ b/arch/arm/mach-s5pc100/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/mach-s5pc100/Kconfig
-#
 # Copyright 2009 Samsung Electronics Co.
 #	Byungho Min <bhmin@samsung.com>
 #
diff --git a/arch/arm/plat-s3c/Kconfig b/arch/arm/plat-s3c/Kconfig
index 8931c5f..ed20966 100644
--- a/arch/arm/plat-s3c/Kconfig
+++ b/arch/arm/plat-s3c/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/plat-s3c/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
diff --git a/arch/arm/plat-s3c24xx/Kconfig b/arch/arm/plat-s3c24xx/Kconfig
index 9c7aca4..c057e2d 100644
--- a/arch/arm/plat-s3c24xx/Kconfig
+++ b/arch/arm/plat-s3c24xx/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/plat-s3c24xx/Kconfig
-#
 # Copyright 2007 Simtec Electronics
 #
 # Licensed under GPLv2
diff --git a/arch/arm/plat-s3c64xx/Kconfig b/arch/arm/plat-s3c64xx/Kconfig
index bcfa778..e6da87a 100644
--- a/arch/arm/plat-s3c64xx/Kconfig
+++ b/arch/arm/plat-s3c64xx/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/plat-s3c64xx/Kconfig
-#
 # Copyright 2008 Openmoko, Inc.
 # Copyright 2008 Simtec Electronics
 #	Ben Dooks <ben@simtec.co.uk>
diff --git a/arch/arm/plat-s5pc1xx/Kconfig b/arch/arm/plat-s5pc1xx/Kconfig
index a8a711c..b15f2d2 100644
--- a/arch/arm/plat-s5pc1xx/Kconfig
+++ b/arch/arm/plat-s5pc1xx/Kconfig
@@ -1,5 +1,3 @@
-# arch/arm/plat-s5pc1xx/Kconfig
-#
 # Copyright 2009 Samsung Electronics Co.
 #	Byungho Min <bhmin@samsung.com>
 #
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..26e434a 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -1,5 +1,3 @@
-# drivers/Kconfig
-
 menu "Device Drivers"
 
 source "drivers/base/Kconfig"
diff --git a/drivers/isdn/act2000/Kconfig b/drivers/isdn/act2000/Kconfig
index 3fc1a54..fa2673f 100644
--- a/drivers/isdn/act2000/Kconfig
+++ b/drivers/isdn/act2000/Kconfig
@@ -1,6 +1,3 @@
-#
-# Config.in for IBM Active 2000 ISDN driver
-#
 config ISDN_DRV_ACT2000
 	tristate "IBM Active 2000 support"
 	depends on ISA
@@ -10,4 +7,3 @@ config ISDN_DRV_ACT2000
 	  into the card using a utility which is part of the latest
 	  isdn4k-utils package. Please read the file
 	  <file:Documentation/isdn/README.act2000> for more information.
-
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index e1afd60..b2a0475 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -1,6 +1,3 @@
-#
-# Config.in for the CAPI subsystem
-#
 config ISDN_DRV_AVMB1_VERBOSE_REASON
 	bool "Verbose reason code reporting"
 	default y
@@ -59,4 +56,3 @@ config ISDN_CAPI_CAPIDRV
 	  the legacy isdn4linux link layer.  If you have a card which is
 	  supported by a CAPI driver, but still want to use old features like
 	  ippp interfaces or ttyI emulation, say Y/M here.
-
diff --git a/drivers/isdn/hysdn/Kconfig b/drivers/isdn/hysdn/Kconfig
index c9e4231..e86bc65 100644
--- a/drivers/isdn/hysdn/Kconfig
+++ b/drivers/isdn/hysdn/Kconfig
@@ -1,6 +1,3 @@
-#
-# Config.in for HYSDN ISDN driver
-#
 config HYSDN
 	tristate "Hypercope HYSDN cards (Champ, Ergo, Metro) support (module only)"
 	depends on m && PROC_FS && PCI
@@ -15,4 +12,3 @@ config HYSDN_CAPI
 	depends on HYSDN && ISDN_CAPI
 	help
 	  Say Y here if you like to use Hypercope's CAPI 2.0 interface.
-
diff --git a/drivers/isdn/icn/Kconfig b/drivers/isdn/icn/Kconfig
index 89d15ee..4534f21 100644
--- a/drivers/isdn/icn/Kconfig
+++ b/drivers/isdn/icn/Kconfig
@@ -1,6 +1,3 @@
-#
-# Config.in for ICN ISDN driver
-#
 config ISDN_DRV_ICN
 	tristate "ICN 2B and 4B support"
 	depends on ISA
@@ -13,4 +10,3 @@ config ISDN_DRV_ICN
 	  separately.  See <file:Documentation/isdn/README> and
 	  <file:Documentation/isdn/README.icn> for more
 	  information.
-
diff --git a/drivers/isdn/pcbit/Kconfig b/drivers/isdn/pcbit/Kconfig
index ffba6ec..e9b2dd8 100644
--- a/drivers/isdn/pcbit/Kconfig
+++ b/drivers/isdn/pcbit/Kconfig
@@ -1,6 +1,3 @@
-#
-# Config.in for PCBIT ISDN driver
-#
 config ISDN_DRV_PCBIT
 	tristate "PCBIT-D support"
 	depends on ISA && (BROKEN || X86)
@@ -11,4 +8,3 @@ config ISDN_DRV_PCBIT
 	  the card using a utility which is distributed separately.  See
 	  <file:Documentation/isdn/README> and
 	  <file:Documentation/isdn/README.pcbit> for more information.
-
diff --git a/drivers/isdn/sc/Kconfig b/drivers/isdn/sc/Kconfig
index e6510ca..7469863 100644
--- a/drivers/isdn/sc/Kconfig
+++ b/drivers/isdn/sc/Kconfig
@@ -1,6 +1,3 @@
-#
-# Config.in for Spellcaster ISDN driver
-#
 config ISDN_DRV_SC
 	tristate "Spellcaster support"
 	depends on ISA
@@ -9,4 +6,3 @@ config ISDN_DRV_SC
 	  driver currently builds only in a modularized version.
 	  To build it, choose M here: the module will be called sc.
 	  See <file:Documentation/isdn/README.sc> for more information.
-
diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index 9408099..35c6a23 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -1,5 +1,3 @@
-# drivers/mtd/chips/Kconfig
-
 menu "RAM/ROM/Flash chip drivers"
 	depends on MTD!=n
 
@@ -242,4 +240,3 @@ config MTD_XIP
 	  then say N.
 
 endmenu
-
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index c222514..35081ce 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -1,5 +1,3 @@
-# drivers/mtd/maps/Kconfig
-
 menu "Self-contained MTD device drivers"
 	depends on MTD!=n
 
@@ -308,4 +306,3 @@ config MTD_DOCPROBE_55AA
 	  you have managed to wipe the first block.
 
 endmenu
-
diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
index 5a401d8..265f969 100644
--- a/drivers/mtd/lpddr/Kconfig
+++ b/drivers/mtd/lpddr/Kconfig
@@ -1,5 +1,3 @@
-# drivers/mtd/chips/Kconfig
-
 menu "LPDDR flash memory drivers"
 	depends on MTD!=n
 
@@ -20,4 +18,3 @@ config MTD_QINFO_PROBE
 	    families of devices. This serves similar purpose of CFI on legacy
 	    Flash products
 endmenu
-
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 841e085..ead070a 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -1,5 +1,3 @@
-# drivers/mtd/maps/Kconfig
-
 menu "Mapping drivers for chip access"
 	depends on MTD!=n
 
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 2fda0b6..6264bf1 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -1,5 +1,3 @@
-# drivers/mtd/nand/Kconfig
-
 menuconfig MTD_NAND
 	tristate "NAND Device Support"
 	depends on MTD
diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
index a38f580..3a9f157 100644
--- a/drivers/mtd/onenand/Kconfig
+++ b/drivers/mtd/onenand/Kconfig
@@ -1,7 +1,3 @@
-#
-# linux/drivers/mtd/onenand/Kconfig
-#
-
 menuconfig MTD_ONENAND
 	tristate "OneNAND Device Support"
 	depends on MTD
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index b1cd7a1..0a8c7ea 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -1,5 +1,3 @@
-# drivers/mtd/ubi/Kconfig
-
 menu "UBI - Unsorted block images"
 	depends on MTD
 
diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
index 9652c3f..8390dca 100644
--- a/drivers/platform/Kconfig
+++ b/drivers/platform/Kconfig
@@ -1,5 +1,3 @@
-# drivers/platform/Kconfig
-
 if X86
 source "drivers/platform/x86/Kconfig"
 endif
diff --git a/samples/Kconfig b/samples/Kconfig
index b92bde3..04be681 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -1,5 +1,3 @@
-# samples/Kconfig
-
 menuconfig SAMPLES
 	bool "Sample kernel code"
 	help
@@ -41,4 +39,3 @@ config SAMPLE_KRETPROBES
 	depends on SAMPLE_KPROBES && KRETPROBES
 
 endif # SAMPLES
-
diff --git a/sound/Kconfig b/sound/Kconfig
index 439e15c..4b5365a 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -1,6 +1,3 @@
-# sound/Config.in
-#
-
 menuconfig SOUND
 	tristate "Sound card support"
 	depends on HAS_IOMEM
@@ -136,4 +133,3 @@ config AC97_BUS
 	  sound subsystem and other function drivers completely unrelated to
 	  sound although they're sharing the AC97 bus. Concerned drivers
 	  should "select" this.
-
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index bcf2a06..ea0b1ae 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -1,5 +1,3 @@
-# drivers/sound/Config.in
-#
 # 18 Apr 1998, Michael Elizabeth Chastain, <mailto:mec@shout.net>
 # More hacking for modularisation.
 #
-- 
1.6.3.3

