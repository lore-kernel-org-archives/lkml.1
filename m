Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbZIPQJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbZIPQJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbZIPQJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:09:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1200 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbZIPQJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:09:45 -0400
Subject: [PATCH] MAINTAINERS: Move ARM lists to infradead
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Sep 2009 09:09:48 -0700
Message-Id: <1253117388.2567.17.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9117b65..d5a14ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -497,7 +497,7 @@ F:	arch/arm/include/asm/floppy.h
 
 ARM PORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
@@ -508,36 +508,36 @@ F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ixp23xx/
 F:	arch/arm/mach-ixp23xx/include/mach/
 
 ARM/ADS SPHERE MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/AFEB9260 MACHINE SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/AJECO 1ARM MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 M:	Andrew Victor <linux@maxim.org.za>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://maxim.org.za/at91_26.html
 S:	Maintained
 
 ARM/BCMRING ARM ARCHITECTURE
 M:	Leo Chen <leochen@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-bcmring
 
@@ -554,25 +554,25 @@ F:	drivers/mtd/nand/nand_bcm_umi.h
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
 M:	Ryan Mallon <ryan@bluewatersys.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ep93xx/
 F:	arch/arm/mach-ep93xx/include/mach/
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CORGI MACHINE SUPPORT
@@ -581,14 +581,14 @@ S:	Maintained
 
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://gitorious.org/linux-gemini/mainline.git
 S:	Maintained
 F:	arch/arm/mach-gemini/
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/mach-ebsa110/
@@ -606,13 +606,13 @@ F:	arch/arm/mach-pxa/ezx.c
 
 ARM/FARADAY FA526 PORT
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/include/asm/hardware/dec21285.h
@@ -620,17 +620,17 @@ F:	arch/arm/mach-footbridge/
 
 ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/GUMSTIX MACHINE SUPPORT
 M:	Steve Sakoman <sakoman@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/H4700 (HP IPAQ HX4700) MACHINE SUPPORT
@@ -650,55 +650,55 @@ F:	arch/arm/mach-sa1100/include/mach/jornada720.h
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IXP2000 ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IXP23XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/LOGICPD PXA270 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/MAGICIAN MACHINE SUPPORT
@@ -708,7 +708,7 @@ S:	Maintained
 ARM/Marvell Loki/Kirkwood/MV78xx0/Orion SOC support
 M:	Lennert Buytenhek <buytenh@marvell.com>
 M:	Nicolas Pitre <nico@marvell.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.marvell.com/orion
 S:	Maintained
 F:	arch/arm/mach-loki/
@@ -719,7 +719,7 @@ F:	arch/arm/plat-orion/
 
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 F:	arch/arm/mach-pxa/mioa701.c
 S:	Maintained
 
@@ -760,18 +760,18 @@ S:	Maintained
 
 ARM/PT DIGITAL BOARD PORT
 M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/RISCPC ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/common/time-acorn.c
@@ -790,7 +790,7 @@ S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-s3c/
@@ -798,65 +798,65 @@ F:	arch/arm/plat-s3c24xx/
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
 ARM/S3C2440 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
 
 ARM/S3C2442 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2442/
 
 ARM/S3C2443 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
 ARM/S3C6400 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6400/
 
 ARM/S3C6410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/THECUS N2100 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/NUVOTON W90X900 ARM ARCHITECTURE
 M:	Wan ZongShun <mcuos.com@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.mcuos.com
 S:	Maintained
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
@@ -957,7 +957,7 @@ F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
@@ -1535,7 +1535,7 @@ F:	drivers/infiniband/hw/cxgb3/
 
 CYBERPRO FB DRIVER
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
@@ -2080,7 +2080,7 @@ F:	drivers/i2c/busses/i2c-cpm.c
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
 F:	drivers/video/imxfb.c
@@ -3441,7 +3441,7 @@ F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 M:	Pavel Pisa <ppisa@pikron.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
@@ -4160,7 +4160,7 @@ F:	drivers/media/video/pvrusb2/
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
@@ -4173,13 +4173,13 @@ F:	sound/soc/pxa
 PXA168 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Jason Chagas <jason.chagas@marvell.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
 PXA910 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
@@ -4420,7 +4420,7 @@ F:	net/iucv/
 
 S3C24XX SD/MMC Driver
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
@@ -4616,7 +4616,7 @@ F:	drivers/misc/sgi-xp/
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/


