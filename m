Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZHUMmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZHUMmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZHUMmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:42:13 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:35258 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbZHUMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:42:12 -0400
Message-ID: <4A8E95E8.8010107@xenontk.org>
Date: Fri, 21 Aug 2009 18:11:12 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.1) Gecko/20090814 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: torvalds@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       vince@kyllikki.org, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, erikm@nl.linux.org
Subject: Re: [PATCH] ARM: Mailing lists have moved
References: <1250855566.3311.100.camel@macbook.infradead.org>
In-Reply-To: <1250855566.3311.100.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 05:22 PM, David Woodhouse wrote:
> Russell no longer wants to maintain the mailing lists, so with his
> blessing I have set up replacements at lists.infradead.org.
> 
> Erik was helping to moderate the old list, and will continue to moderate
> the new one. Vince has kindly volunteered to do so too.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Erik Mouw <mouw@nl.linux.org>
> Signed-off-by: Vincent Sanders <vince@kyllikki.org>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 60299a9..24f6134 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -497,7 +497,7 @@ F:	arch/arm/include/asm/floppy.h
>  
>  ARM PORT
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  F:	arch/arm/
> @@ -508,51 +508,51 @@ F:	drivers/mmc/host/mmci.*
>  
>  ARM/ADI ROADRUNNER MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	arch/arm/mach-ixp23xx/
>  F:	arch/arm/mach-ixp23xx/include/mach/
>  
>  ARM/ADS SPHERE MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/AFEB9260 MACHINE SUPPORT
>  M:	Sergey Lapin <slapin@ossfans.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/AJECO 1ARM MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
>  M:	Andrew Victor <linux@maxim.org.za>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://maxim.org.za/at91_26.html
>  S:	Maintained
>  
>  ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/CLKDEV SUPPORT
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  F:	arch/arm/common/clkdev.c
>  F:	arch/arm/include/asm/clkdev.h
>  
>  ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
>  M:	Mike Rapoport <mike@compulab.co.il>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/CORGI MACHINE SUPPORT
> @@ -561,14 +561,14 @@ S:	Maintained
>  
>  ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
>  M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  T:	git git://gitorious.org/linux-gemini/mainline.git
>  S:	Maintained
>  F:	arch/arm/mach-gemini/
>  
>  ARM/EBSA110 MACHINE SUPPORT
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  F:	arch/arm/mach-ebsa110/
> @@ -586,13 +586,13 @@ F:	arch/arm/mach-pxa/ezx.c
>  
>  ARM/FARADAY FA526 PORT
>  M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	arch/arm/mm/*-fa*
>  
>  ARM/FOOTBRIDGE ARCHITECTURE
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  F:	arch/arm/include/asm/hardware/dec21285.h
> @@ -600,17 +600,17 @@ F:	arch/arm/mach-footbridge/
>  
>  ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
>  M:	Sascha Hauer <kernel@pengutronix.de>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/GUMSTIX MACHINE SUPPORT
>  M:	Steve Sakoman <sakoman@gmail.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/H4700 (HP IPAQ HX4700) MACHINE SUPPORT
> @@ -630,55 +630,55 @@ F:	arch/arm/mach-sa1100/include/mach/jornada720.h
>  ARM/INTEL IOP32X ARM ARCHITECTURE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Supported
>  
>  ARM/INTEL IOP33X ARM ARCHITECTURE
>  M:	Dan Williams <dan.j.williams@intel.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Supported
>  
>  ARM/INTEL IOP13XX ARM ARCHITECTURE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Supported
>  
>  ARM/INTEL IQ81342EX MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Supported
>  
>  ARM/INTEL IXP2000 ARM ARCHITECTURE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/INTEL IXDP2850 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/INTEL IXP23XX ARM ARCHITECTURE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/INTEL XSC3 (MANZANO) ARM CORE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Supported
>  
>  ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/LOGICPD PXA270 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/MAGICIAN MACHINE SUPPORT
> @@ -687,7 +687,7 @@ S:	Maintained
>  
>  ARM/MIOA701 MACHINE SUPPORT
>  M:	Robert Jarzmik <robert.jarzmik@free.fr>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  F:	arch/arm/mach-pxa/mioa701.c
>  S:	Maintained
>  
> @@ -728,18 +728,18 @@ S:	Maintained
>  
>  ARM/PT DIGITAL BOARD PORT
>  M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  
>  ARM/RADISYS ENP2611 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/RISCPC ARCHITECTURE
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  F:	arch/arm/common/time-acorn.c
> @@ -758,7 +758,7 @@ S:	Maintained
>  
>  ARM/SAMSUNG ARM ARCHITECTURES
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/plat-s3c/
> @@ -766,65 +766,65 @@ F:	arch/arm/plat-s3c24xx/
>  
>  ARM/S3C2410 ARM ARCHITECTURE
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/mach-s3c2410/
>  
>  ARM/S3C2440 ARM ARCHITECTURE
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/mach-s3c2440/
>  
>  ARM/S3C2442 ARM ARCHITECTURE
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/mach-s3c2442/
>  
>  ARM/S3C2443 ARM ARCHITECTURE
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/mach-s3c2443/
>  
>  ARM/S3C6400 ARM ARCHITECTURE
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/mach-s3c6400/
>  
>  ARM/S3C6410 ARM ARCHITECTURE
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/mach-s3c6410/
>  
>  ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/THECUS N2100 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  
>  ARM/NUVOTON W90X900 ARM ARCHITECTURE
>  M:	Wan ZongShun <mcuos.com@gmail.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.mcuos.com
>  S:	Maintained
>  
>  ARM/VFP SUPPORT
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  F:	arch/arm/vfp/
> @@ -923,7 +923,7 @@ F:	include/linux/atm*
>  
>  ATMEL AT91 MCI DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.atmel.com/products/AT91/
>  W:	http://www.at91.com/
>  S:	Maintained
> @@ -1501,7 +1501,7 @@ F:	drivers/infiniband/hw/cxgb3/
>  
>  CYBERPRO FB DRIVER
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  W:	http://www.arm.linux.org.uk/
>  S:	Maintained
>  F:	drivers/video/cyber2000fb.*
> @@ -2046,7 +2046,7 @@ F:	drivers/i2c/busses/i2c-cpm.c
>  FREESCALE IMX / MXC FRAMEBUFFER DRIVER
>  M:	Sascha Hauer <kernel@pengutronix.de>
>  L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	arch/arm/plat-mxc/include/mach/imxfb.h
>  F:	drivers/video/imxfb.c
> @@ -3398,7 +3398,7 @@ F:	include/linux/meye.h
>  
>  MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
>  M:	Pavel Pisa <ppisa@pikron.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	drivers/mmc/host/imxmmc.*
>  
> @@ -4106,7 +4106,7 @@ F:	drivers/media/video/pvrusb2/
>  PXA2xx/PXA3xx SUPPORT
>  M:	Eric Miao <eric.y.miao@gmail.com>
>  M:	Russell King <linux@arm.linux.org.uk>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	arch/arm/mach-pxa/
>  F:	drivers/pcmcia/pxa2xx*
> @@ -4119,13 +4119,13 @@ F:	sound/soc/pxa
>  PXA168 SUPPORT
>  M:	Eric Miao <eric.y.miao@gmail.com>
>  M:	Jason Chagas <jason.chagas@marvell.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
>  S:	Maintained
>  
>  PXA910 SUPPORT
>  M:	Eric Miao <eric.y.miao@gmail.com>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
>  S:	Maintained
>  
> @@ -4366,7 +4366,7 @@ F:	net/iucv/
>  
>  S3C24XX SD/MMC Driver
>  M:	Ben Dooks <ben-linux@fluff.org>
> -L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Supported
>  F:	drivers/mmc/host/s3cmci.*
>  
> @@ -4561,7 +4561,7 @@ F:	drivers/misc/sgi-xp/
>  SHARP LH SUPPORT (LH7952X & LH7A40X)
>  M:	Marc Singer <elf@buici.com>
>  W:	http://projects.buici.com/arm
> -L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
>  F:	arch/arm/mach-lh7a40x/
> 

Since we are changing mailing lists now, I have to say, can't the ARM
_kernel_ mailing list just be hosted as an open list at
linux-arm@vger.kernel.org and be done with? *Please*? All this moderating,
subscribing, cross-posting and flaming is really troubling.

Regards,
David.
