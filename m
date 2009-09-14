Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZINHZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZINHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZINHZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:25:28 -0400
Received: from relais.videotron.ca ([24.201.245.36]:62885 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZINHZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:25:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 14 Sep 2009 03:25:28 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Nicolas Pitre has a new email address
Message-id: <alpine.LFD.2.00.0909140314180.22285@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to problems at cam.org, my nico@cam.org email address is no longer
valid.  FRom now on, nico@fluxnic.net should be used instead.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
---

This is a simple mechanical eviction of nico@cam.org from the tree.  
This means some old and probably obsolete documentation files are 
updated as well, although they rather need to be deleted entirely or the 
like.  But that's for another day.

diff --git a/CREDITS b/CREDITS
index 1a41bf4..72b4878 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2800,7 +2800,7 @@ D: Starter of Linux1394 effort
 S: ask per mail for current address
 
 N: Nicolas Pitre
-E: nico@cam.org
+E: nico@fluxnic.net
 D: StrongARM SA1100 support integrator & hacker
 D: Xscale PXA architecture
 D: unified SMC 91C9x/91C11x ethernet driver (smc91x)
diff --git a/Documentation/arm/SA1100/ADSBitsy b/Documentation/arm/SA1100/ADSBitsy
index ab47c38..7197a9e 100644
--- a/Documentation/arm/SA1100/ADSBitsy
+++ b/Documentation/arm/SA1100/ADSBitsy
@@ -40,4 +40,4 @@ Notes:
   mode, the timing is off so the image is corrupted.  This will be
   fixed soon.
 
-Any contribution can be sent to nico@cam.org and will be greatly welcome!
+Any contribution can be sent to nico@fluxnic.net and will be greatly welcome!
diff --git a/Documentation/arm/SA1100/Assabet b/Documentation/arm/SA1100/Assabet
index 78bc1c1..91f7ce7 100644
--- a/Documentation/arm/SA1100/Assabet
+++ b/Documentation/arm/SA1100/Assabet
@@ -240,7 +240,7 @@ Then, rebooting the Assabet is just a matter of waiting for the login prompt.
 
 
 Nicolas Pitre
-nico@cam.org
+nico@fluxnic.net
 June 12, 2001
 
 
diff --git a/Documentation/arm/SA1100/Brutus b/Documentation/arm/SA1100/Brutus
index 2254c8f..b1cfd40 100644
--- a/Documentation/arm/SA1100/Brutus
+++ b/Documentation/arm/SA1100/Brutus
@@ -60,7 +60,7 @@ little modifications.
 
 Any contribution is welcome.
 
-Please send patches to nico@cam.org
+Please send patches to nico@fluxnic.net
 
 Have Fun !
 
diff --git a/Documentation/arm/SA1100/GraphicsClient b/Documentation/arm/SA1100/GraphicsClient
index 8fa7e80..6c9c4f5 100644
--- a/Documentation/arm/SA1100/GraphicsClient
+++ b/Documentation/arm/SA1100/GraphicsClient
@@ -4,7 +4,7 @@ For more details, contact Applied Data Systems or see
 http://www.applieddata.net/products.html
 
 The original Linux support for this product has been provided by 
-Nicolas Pitre <nico@cam.org>. Continued development work by
+Nicolas Pitre <nico@fluxnic.net>. Continued development work by
 Woojung Huh <whuh@applieddata.net>
 
 It's currently possible to mount a root filesystem via NFS providing a
@@ -94,5 +94,5 @@ Notes:
   mode, the timing is off so the image is corrupted.  This will be
   fixed soon.
 
-Any contribution can be sent to nico@cam.org and will be greatly welcome!
+Any contribution can be sent to nico@fluxnic.net and will be greatly welcome!
 
diff --git a/Documentation/arm/SA1100/GraphicsMaster b/Documentation/arm/SA1100/GraphicsMaster
index dd28745..ee7c659 100644
--- a/Documentation/arm/SA1100/GraphicsMaster
+++ b/Documentation/arm/SA1100/GraphicsMaster
@@ -4,7 +4,7 @@ For more details, contact Applied Data Systems or see
 http://www.applieddata.net/products.html
 
 The original Linux support for this product has been provided by
-Nicolas Pitre <nico@cam.org>. Continued development work by
+Nicolas Pitre <nico@fluxnic.net>. Continued development work by
 Woojung Huh <whuh@applieddata.net>
 
 Use 'make graphicsmaster_config' before any 'make config'.
@@ -50,4 +50,4 @@ Notes:
   mode, the timing is off so the image is corrupted.  This will be
   fixed soon.
 
-Any contribution can be sent to nico@cam.org and will be greatly welcome!
+Any contribution can be sent to nico@fluxnic.net and will be greatly welcome!
diff --git a/Documentation/arm/SA1100/Victor b/Documentation/arm/SA1100/Victor
index 01e81fc..f938a29 100644
--- a/Documentation/arm/SA1100/Victor
+++ b/Documentation/arm/SA1100/Victor
@@ -9,7 +9,7 @@ Of course Victor is using Linux as its main operating system.
 The Victor implementation for Linux is maintained by Nicolas Pitre:
 
 	nico@visuaide.com
-	nico@cam.org
+	nico@fluxnic.net
 
 For any comments, please feel free to contact me through the above
 addresses.
diff --git a/MAINTAINERS b/MAINTAINERS
index 989ff11..cca5457 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3280,7 +3280,7 @@ F:	drivers/net/mv643xx_eth.*
 F:	include/linux/mv643xx.h
 
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
-M:	Nicolas Pitre <nico@cam.org>
+M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Maintained
 
 MARVELL YUKON / SYSKONNECT DRIVER
@@ -4640,7 +4640,7 @@ F:	include/linux/sl?b*.h
 F:	mm/sl?b.c
 
 SMC91x ETHERNET DRIVER
-M:	Nicolas Pitre <nico@cam.org>
+M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Maintained
 F:	drivers/net/smc91x.*
 
diff --git a/arch/arm/boot/compressed/head-sa1100.S b/arch/arm/boot/compressed/head-sa1100.S
index 4c8c0e4..6179d94 100644
--- a/arch/arm/boot/compressed/head-sa1100.S
+++ b/arch/arm/boot/compressed/head-sa1100.S
@@ -1,7 +1,7 @@
 /* 
  * linux/arch/arm/boot/compressed/head-sa1100.S
  * 
- * Copyright (C) 1999 Nicolas Pitre <nico@cam.org>
+ * Copyright (C) 1999 Nicolas Pitre <nico@fluxnic.net>
  * 
  * SA1100 specific tweaks.  This is merged into head.S by the linker.
  *
diff --git a/arch/arm/lib/lib1funcs.S b/arch/arm/lib/lib1funcs.S
index 67964bc..6dc0648 100644
--- a/arch/arm/lib/lib1funcs.S
+++ b/arch/arm/lib/lib1funcs.S
@@ -1,7 +1,7 @@
 /*
  * linux/arch/arm/lib/lib1funcs.S: Optimized ARM division routines
  *
- * Author: Nicolas Pitre <nico@cam.org>
+ * Author: Nicolas Pitre <nico@fluxnic.net>
  *   - contributed to gcc-3.4 on Sep 30, 2003
  *   - adapted for the Linux kernel on Oct 2, 2003
  */
diff --git a/arch/arm/lib/sha1.S b/arch/arm/lib/sha1.S
index a16fb20..3cf227a 100644
--- a/arch/arm/lib/sha1.S
+++ b/arch/arm/lib/sha1.S
@@ -3,7 +3,7 @@
  *
  *  SHA transform optimized for ARM
  *
- *  Copyright:	(C) 2005 by Nicolas Pitre <nico@cam.org>
+ *  Copyright:	(C) 2005 by Nicolas Pitre <nico@fluxnic.net>
  *  Created:	September 17, 2005
  *
  *  This program is free software; you can redistribute it and/or modify
diff --git a/arch/arm/mach-sa1100/include/mach/assabet.h b/arch/arm/mach-sa1100/include/mach/assabet.h
index 3959b20..28c2cf5 100644
--- a/arch/arm/mach-sa1100/include/mach/assabet.h
+++ b/arch/arm/mach-sa1100/include/mach/assabet.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-sa1100/include/mach/assabet.h
  *
- * Created 2000/06/05 by Nicolas Pitre <nico@cam.org>
+ * Created 2000/06/05 by Nicolas Pitre <nico@fluxnic.net>
  *
  * This file contains the hardware specific definitions for Assabet
  * Only include this file from SA1100-specific files.
diff --git a/arch/arm/mach-sa1100/include/mach/hardware.h b/arch/arm/mach-sa1100/include/mach/hardware.h
index 6071182..99f5856 100644
--- a/arch/arm/mach-sa1100/include/mach/hardware.h
+++ b/arch/arm/mach-sa1100/include/mach/hardware.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-sa1100/include/mach/hardware.h
  *
- * Copyright (C) 1998 Nicolas Pitre <nico@cam.org>
+ * Copyright (C) 1998 Nicolas Pitre <nico@fluxnic.net>
  *
  * This file contains the hardware definitions for SA1100 architecture
  *
diff --git a/arch/arm/mach-sa1100/include/mach/memory.h b/arch/arm/mach-sa1100/include/mach/memory.h
index e9f8eed..d5277f9 100644
--- a/arch/arm/mach-sa1100/include/mach/memory.h
+++ b/arch/arm/mach-sa1100/include/mach/memory.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-sa1100/include/mach/memory.h
  *
- * Copyright (C) 1999-2000 Nicolas Pitre <nico@cam.org>
+ * Copyright (C) 1999-2000 Nicolas Pitre <nico@fluxnic.net>
  */
 
 #ifndef __ASM_ARCH_MEMORY_H
diff --git a/arch/arm/mach-sa1100/include/mach/neponset.h b/arch/arm/mach-sa1100/include/mach/neponset.h
index d3f044f..ffe2bc4 100644
--- a/arch/arm/mach-sa1100/include/mach/neponset.h
+++ b/arch/arm/mach-sa1100/include/mach/neponset.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-sa1100/include/mach/neponset.h
  *
- * Created 2000/06/05 by Nicolas Pitre <nico@cam.org>
+ * Created 2000/06/05 by Nicolas Pitre <nico@fluxnic.net>
  *
  * This file contains the hardware specific definitions for Assabet
  * Only include this file from SA1100-specific files.
diff --git a/arch/arm/mach-sa1100/include/mach/system.h b/arch/arm/mach-sa1100/include/mach/system.h
index 942b153..ba9da9f 100644
--- a/arch/arm/mach-sa1100/include/mach/system.h
+++ b/arch/arm/mach-sa1100/include/mach/system.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-sa1100/include/mach/system.h
  *
- * Copyright (c) 1999 Nicolas Pitre <nico@cam.org>
+ * Copyright (c) 1999 Nicolas Pitre <nico@fluxnic.net>
  */
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-sa1100/include/mach/uncompress.h b/arch/arm/mach-sa1100/include/mach/uncompress.h
index 714160b..6cb39dd 100644
--- a/arch/arm/mach-sa1100/include/mach/uncompress.h
+++ b/arch/arm/mach-sa1100/include/mach/uncompress.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-sa1100/include/mach/uncompress.h
  *
- * (C) 1999 Nicolas Pitre <nico@cam.org>
+ * (C) 1999 Nicolas Pitre <nico@fluxnic.net>
  *
  * Reorganised to be machine independent.
  */
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index 111cce6..c83fdc8 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -15,7 +15,7 @@
  * 			Save more value for the resume function! Support
  * 			Bitsy/Assabet/Freebird board
  *
- * 2001-08-29:	Nicolas Pitre <nico@cam.org>
+ * 2001-08-29:	Nicolas Pitre <nico@fluxnic.net>
  * 			Cleaned up, pushed platform dependent stuff
  * 			in the platform specific files.
  *
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 711c029..95d92e8 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1998 Deborah Wallach.
  * Twiddles  (C) 1999 Hugo Fiennes <hugo@empeg.com>
  *
- * 2000/03/29 (C) Nicolas Pitre <nico@cam.org>
+ * 2000/03/29 (C) Nicolas Pitre <nico@fluxnic.net>
  *	Rewritten: big cleanup, much simpler, better HZ accuracy.
  *
  */
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 0cce37b..4233942 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -17,7 +17,7 @@
  *
  * 2001 Sep 08:
  *	Completely revisited, many important fixes
- *	Nicolas Pitre <nico@cam.org>
+ *	Nicolas Pitre <nico@fluxnic.net>
  */
 
 #include <linux/linkage.h>
diff --git a/arch/arm/plat-iop/setup.c b/arch/arm/plat-iop/setup.c
index 9e573e7..bade586 100644
--- a/arch/arm/plat-iop/setup.c
+++ b/arch/arm/plat-iop/setup.c
@@ -1,7 +1,7 @@
 /*
  * arch/arm/plat-iop/setup.c
  *
- * Author: Nicolas Pitre <nico@cam.org>
+ * Author: Nicolas Pitre <nico@fluxnic.net>
  * Copyright (C) 2001 MontaVista Software, Inc.
  * Copyright (C) 2004 Intel Corporation.
  *
diff --git a/arch/arm/plat-omap/include/mach/system.h b/arch/arm/plat-omap/include/mach/system.h
index 1060e34..ed8ec74 100644
--- a/arch/arm/plat-omap/include/mach/system.h
+++ b/arch/arm/plat-omap/include/mach/system.h
@@ -1,6 +1,6 @@
 /*
  * Copied from arch/arm/mach-sa1100/include/mach/system.h
- * Copyright (c) 1999 Nicolas Pitre <nico@cam.org>
+ * Copyright (c) 1999 Nicolas Pitre <nico@fluxnic.net>
  */
 #ifndef __ASM_ARCH_SYSTEM_H
 #define __ASM_ARCH_SYSTEM_H
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 0d2fc64..1a22254 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -8,7 +8,7 @@
  *
  * Based on a previous implementations by Kevin O'Connor
  * <kevin_at_koconnor.net> and Alex Osborne <bobofdoom@gmail.com> and
- * on some suggestions by Nicolas Pitre <nico@cam.org>.
+ * on some suggestions by Nicolas Pitre <nico@fluxnic.net>.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 8664fee..e7563a9 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -5,7 +5,7 @@
  * (C) 2000 Red Hat. GPL'd
  *
  *
- * 10/10/2000	Nicolas Pitre <nico@cam.org>
+ * 10/10/2000	Nicolas Pitre <nico@fluxnic.net>
  * 	- completely revamped method functions so they are aware and
  * 	  independent of the flash geometry (buswidth, interleave, etc.)
  * 	- scalability vs code size is completely set at compile-time
diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
index 6c740f3..0667a67 100644
--- a/drivers/mtd/chips/cfi_cmdset_0020.c
+++ b/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -4,7 +4,7 @@
  *
  * (C) 2000 Red Hat. GPL'd
  *
- * 10/10/2000	Nicolas Pitre <nico@cam.org>
+ * 10/10/2000	Nicolas Pitre <nico@fluxnic.net>
  * 	- completely revamped method functions so they are aware and
  * 	  independent of the flash geometry (buswidth, interleave, etc.)
  * 	- scalability vs code size is completely set at compile-time
diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
index 365c77b..a7c808b 100644
--- a/drivers/mtd/maps/bfin-async-flash.c
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -6,7 +6,7 @@
  * for example.  All board-specific configuration goes in your
  * board resources file.
  *
- * Copyright 2000 Nicolas Pitre <nico@cam.org>
+ * Copyright 2000 Nicolas Pitre <nico@fluxnic.net>
  * Copyright 2005-2008 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
diff --git a/drivers/mtd/maps/ceiva.c b/drivers/mtd/maps/ceiva.c
index 60e68bd..d41f347 100644
--- a/drivers/mtd/maps/ceiva.c
+++ b/drivers/mtd/maps/ceiva.c
@@ -9,7 +9,7 @@
  * Based on: sa1100-flash.c, which has the following copyright:
  * Flash memory access on SA11x0 based devices
  *
- * (C) 2000 Nicolas Pitre <nico@cam.org>
+ * (C) 2000 Nicolas Pitre <nico@fluxnic.net>
  *
  */
 
diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
index 42969fe..b3cb3a1 100644
--- a/drivers/mtd/maps/dc21285.c
+++ b/drivers/mtd/maps/dc21285.c
@@ -1,7 +1,7 @@
 /*
  * MTD map driver for flash on the DC21285 (the StrongARM-110 companion chip)
  *
- * (C) 2000  Nicolas Pitre <nico@cam.org>
+ * (C) 2000  Nicolas Pitre <nico@fluxnic.net>
  *
  * This code is GPL
  */
@@ -249,5 +249,5 @@ module_exit(cleanup_dc21285);
 
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Nicolas Pitre <nico@cam.org>");
+MODULE_AUTHOR("Nicolas Pitre <nico@fluxnic.net>");
 MODULE_DESCRIPTION("MTD map driver for DC21285 boards");
diff --git a/drivers/mtd/maps/ipaq-flash.c b/drivers/mtd/maps/ipaq-flash.c
index 748c85f..76708e7 100644
--- a/drivers/mtd/maps/ipaq-flash.c
+++ b/drivers/mtd/maps/ipaq-flash.c
@@ -1,7 +1,7 @@
 /*
  * Flash memory access on iPAQ Handhelds (either SA1100 or PXA250 based)
  *
- * (C) 2000 Nicolas Pitre <nico@cam.org>
+ * (C) 2000 Nicolas Pitre <nico@fluxnic.net>
  * (C) 2002 Hewlett-Packard Company <jamey.hicks@hp.com>
  * (C) 2003 Christian Pellegrin <chri@ascensit.com>, <chri@infis.univ.ts.it>: concatenation of multiple flashes
  */
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 643aa06..74fa075 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -175,5 +175,5 @@ module_init(init_pxa2xx_flash);
 module_exit(cleanup_pxa2xx_flash);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Nicolas Pitre <nico@cam.org>");
+MODULE_AUTHOR("Nicolas Pitre <nico@fluxnic.net>");
 MODULE_DESCRIPTION("MTD map driver for Intel XScale PXA2xx");
diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
index c6210f5..fdb97f3 100644
--- a/drivers/mtd/maps/sa1100-flash.c
+++ b/drivers/mtd/maps/sa1100-flash.c
@@ -1,7 +1,7 @@
 /*
  * Flash memory access on SA11x0 based devices
  *
- * (C) 2000 Nicolas Pitre <nico@cam.org>
+ * (C) 2000 Nicolas Pitre <nico@fluxnic.net>
  */
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 77db5ce..2d70295 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -1,7 +1,7 @@
 /*
  * Direct MTD block device access
  *
- * (C) 2000-2003 Nicolas Pitre <nico@cam.org>
+ * (C) 2000-2003 Nicolas Pitre <nico@fluxnic.net>
  * (C) 1999-2003 David Woodhouse <dwmw2@infradead.org>
  */
 
@@ -403,5 +403,5 @@ module_exit(cleanup_mtdblock);
 
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Nicolas Pitre <nico@cam.org> et al.");
+MODULE_AUTHOR("Nicolas Pitre <nico@fluxnic.net> et al.");
 MODULE_DESCRIPTION("Caching read/erase/writeback block device emulation access to MTD devices");
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 349fcbe..742504e 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -1,7 +1,7 @@
 /*
  * Simple MTD partitioning layer
  *
- * (C) 2000 Nicolas Pitre <nico@cam.org>
+ * (C) 2000 Nicolas Pitre <nico@fluxnic.net>
  *
  * This code is GPL
  *
diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index 7567f51..ee32024 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -35,7 +35,7 @@
  *
  * contributors:
  * 	Daris A Nevil <dnevil@snmc.com>
- *      Nicolas Pitre <nico@cam.org>
+ *      Nicolas Pitre <nico@fluxnic.net>
  *	Russell King <rmk@arm.linux.org.uk>
  *
  * History:
@@ -58,7 +58,7 @@
  *   22/09/04  Nicolas Pitre      big update (see commit log for details)
  */
 static const char version[] =
-	"smc91x.c: v1.1, sep 22 2004 by Nicolas Pitre <nico@cam.org>\n";
+	"smc91x.c: v1.1, sep 22 2004 by Nicolas Pitre <nico@fluxnic.net>\n";
 
 /* Debugging level */
 #ifndef SMC_DEBUG
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 57a159f..784b631 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -28,7 +28,7 @@
  . Authors
  .	Erik Stahlman		<erik@vt.edu>
  .	Daris A Nevil		<dnevil@snmc.com>
- .	Nicolas Pitre 		<nico@cam.org>
+ .	Nicolas Pitre 		<nico@fluxnic.net>
  .
  ---------------------------------------------------------------------------*/
 #ifndef _SMC91X_H_
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 4f247e4..021b292 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -9,7 +9,7 @@
  *
  * Modifications from:
  *   CIH <cih@coventive.com>
- *   Nicolas Pitre <nico@cam.org>
+ *   Nicolas Pitre <nico@fluxnic.net>
  *   Andrew Christian <andrew.christian@hp.com>
  *
  * Converted to the RTC subsystem and Driver Model
diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index 10ddad8..cdaa873 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -66,7 +66,7 @@
  *	- FrameBuffer memory is now allocated at run-time when the
  *	  driver is initialized.    
  *
- * 2000/04/10: Nicolas Pitre <nico@cam.org>
+ * 2000/04/10: Nicolas Pitre <nico@fluxnic.net>
  *	- Big cleanup for dynamic selection of machine type at run time.
  *
  * 2000/07/19: Jamey Hicks <jamey@crl.dec.com>
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index b70313d..274b619 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -1,7 +1,7 @@
 /*
  * MTD partitioning layer definitions
  *
- * (C) 2000 Nicolas Pitre <nico@cam.org>
+ * (C) 2000 Nicolas Pitre <nico@fluxnic.net>
  *
  * This code is GPL
  */
diff --git a/lib/inflate.c b/lib/inflate.c
index 1a8e8a9..d102559 100644
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -7,7 +7,7 @@
  * Adapted for booting Linux by Hannu Savolainen 1993
  * based on gzip-1.0.3 
  *
- * Nicolas Pitre <nico@cam.org>, 1999/04/14 :
+ * Nicolas Pitre <nico@fluxnic.net>, 1999/04/14 :
  *   Little mods for all variable to reside either into rodata or bss segments
  *   by marking constant variables with 'const' and initializing all the others
  *   at run-time only.  This allows for the kernel uncompressor to run
