Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZHFO1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZHFO1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZHFO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:27:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4034 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZHFO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:27:08 -0400
Subject: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
 sections
From: Joe Perches <joe@perches.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Cc: David John <davidjon@xenontk.org>, Pavel Machek <pavel@ucw.cz>,
       Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20090806133349.GF27773@flint.arm.linux.org.uk>
References: <mailman.3653.1249217530.31043.linux-arm-kernel@lists.arm.linux.org.uk>
	 <20090804100051.GA17106@elf.ucw.cz>
	 <20090804223922.GD18365@flint.arm.linux.org.uk>
	 <20090806125751.7d0253ce@nij0285> <20090806113104.GK31370@elf.ucw.cz>
	 <20090806120826.GC27773@flint.arm.linux.org.uk>
	 <4A7ACC8D.7030706@xenontk.org>
	 <20090806124048.GD27773@flint.arm.linux.org.uk>
	 <1249563730.10297.13.camel@Joe-Laptop.home>
	 <20090806133349.GF27773@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 07:23:34 -0700
Message-Id: <1249568614.10297.20.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 14:33 +0100, Russell King wrote:
> On Thu, Aug 06, 2009 at 06:02:10AM -0700, Joe Perches wrote:
> > I suspect a vger based ARM list would not require you to "run" it.
> There is already a vger based ARM list.  I see no signs of people
> moving over to it.  I summise that is because most people don't
> have a problem, and most people are happy with the existing lists
> as they stand.  Could it be that it's only a minority who are
> having issues.  I don't know.

Perhaps there is too little exposure of the
linux-arm@vger.kernel.org mailing list.

This might help.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..63e3179 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -498,6 +498,7 @@ F:	arch/arm/include/asm/floppy.h
 ARM PORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
@@ -509,6 +510,7 @@ F:	drivers/mmc/host/mmci.*
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-ixp23xx/
 F:	arch/arm/mach-ixp23xx/include/mach/
@@ -516,43 +518,51 @@ F:	arch/arm/mach-ixp23xx/include/mach/
 ARM/ADS SPHERE MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/AFEB9260 MACHINE SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/AJECO 1ARM MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 M:	Andrew Victor <linux@maxim.org.za>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://maxim.org.za/at91_26.html
 S:	Maintained
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/CORGI MACHINE SUPPORT
@@ -562,6 +572,7 @@ S:	Maintained
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 T:	git git://gitorious.org/linux-gemini/mainline.git
 S:	Maintained
 F:	arch/arm/mach-gemini/
@@ -569,6 +580,7 @@ F:	arch/arm/mach-gemini/
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/mach-ebsa110/
@@ -587,12 +599,14 @@ F:	arch/arm/mach-pxa/ezx.c
 ARM/FARADAY FA526 PORT
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/include/asm/hardware/dec21285.h
@@ -601,16 +615,19 @@ F:	arch/arm/mach-footbridge/
 ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/GUMSTIX MACHINE SUPPORT
 M:	Steve Sakoman <sakoman@gmail.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/H4700 (HP IPAQ HX4700) MACHINE SUPPORT
@@ -631,54 +648,64 @@ ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Supported
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Supported
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Supported
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Supported
 
 ARM/INTEL IXP2000 ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/INTEL IXP23XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Supported
 
 ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/LOGICPD PXA270 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/MAGICIAN MACHINE SUPPORT
@@ -688,6 +715,7 @@ S:	Maintained
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 F:	arch/arm/mach-pxa/mioa701.c
 S:	Maintained
 
@@ -729,17 +757,20 @@ S:	Maintained
 ARM/PT DIGITAL BOARD PORT
 M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/RISCPC ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/common/time-acorn.c
@@ -759,6 +790,7 @@ S:	Maintained
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-s3c/
@@ -767,6 +799,7 @@ F:	arch/arm/plat-s3c24xx/
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
@@ -774,6 +807,7 @@ F:	arch/arm/mach-s3c2410/
 ARM/S3C2440 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
@@ -781,6 +815,7 @@ F:	arch/arm/mach-s3c2440/
 ARM/S3C2442 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2442/
@@ -788,6 +823,7 @@ F:	arch/arm/mach-s3c2442/
 ARM/S3C2443 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
@@ -795,6 +831,7 @@ F:	arch/arm/mach-s3c2443/
 ARM/S3C6400 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6400/
@@ -802,6 +839,7 @@ F:	arch/arm/mach-s3c6400/
 ARM/S3C6410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
@@ -809,22 +847,26 @@ F:	arch/arm/mach-s3c6410/
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/THECUS N2100 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 
 ARM/NUVOTON W90X900 ARM ARCHITECTURE
 M:	Wan ZongShun <mcuos.com@gmail.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.mcuos.com
 S:	Maintained
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
@@ -924,6 +966,7 @@ F:	include/linux/atm*
 ATMEL AT91 MCI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
@@ -1502,6 +1545,7 @@ F:	drivers/infiniband/hw/cxgb3/
 CYBERPRO FB DRIVER
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
@@ -2047,6 +2091,7 @@ FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
 F:	drivers/video/imxfb.c
@@ -3391,6 +3436,7 @@ F:	include/linux/meye.h
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 M:	Pavel Pisa <ppisa@pikron.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
@@ -4093,6 +4139,7 @@ PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
@@ -4106,12 +4153,14 @@ PXA168 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Jason Chagas <jason.chagas@marvell.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
 PXA910 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
@@ -4353,6 +4402,7 @@ F:	net/iucv/
 S3C24XX SD/MMC Driver
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
@@ -4548,6 +4598,7 @@ SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/


