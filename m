Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZHUJGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZHUJGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 05:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZHUJGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 05:06:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39826 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbZHUJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 05:06:11 -0400
Date: Fri, 21 Aug 2009 11:05:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Mailing List Etiquette
Message-ID: <20090821090546.GI8431@elf.ucw.cz>
References: <20090819060004.GA23859@n2100.arm.linux.org.uk> <20090821072607.GA26983@atrey.karlin.mff.cuni.cz> <20090821081849.GA14431@n2100.arm.linux.org.uk> <20090821083028.GH8431@elf.ucw.cz> <20090821083953.GA14800@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821083953.GA14800@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-21 09:39:53, Russell King - ARM Linux wrote:
> On Fri, Aug 21, 2009 at 10:30:28AM +0200, Pavel Machek wrote:
> > On Fri 2009-08-21 09:18:49, Russell King - ARM Linux wrote:
> > > Right, this does it.  I'm off on holiday as of now.
> > 
> > Cool.
> > 
> > > Guess what?  I've had enough of this crap.  I'm pulling the plug on
> > > these lists.  Everyone, you know the email address to complain to.
> > > One community killed by an "open list" zealot.
> > 
> > If you are not willing to keep information up to date, don't spam with
> > it. It is as simple as that. I'm looking forward to list administrator
> > who does not go ballistic every time problem is reported with his
> > list, and the one who does not call me names.
> 
> Your constant whinging is the reason for the action which has now been
> taken.  The lists are now off line until future notice, when I can deal
> with the crap that constantly pours out of your keyboard.

So perhaps following patch is in order?
									Pavel

---

Switch ARM mailing lists to the ones that work.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/MAINTAINERS b/MAINTAINERS
index 66bbc53..d0a05f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -497,7 +497,7 @@ F:	arch/arm/include/asm/floppy.h
 
 ARM PORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
@@ -546,7 +546,7 @@ S:	Maintained
 
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
 
@@ -568,7 +568,7 @@ F:	arch/arm/mach-gemini/
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/mach-ebsa110/
@@ -592,7 +592,7 @@ F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/include/asm/hardware/dec21285.h
@@ -728,7 +728,7 @@ S:	Maintained
 
 ARM/PT DIGITAL BOARD PORT
 M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
@@ -739,7 +739,7 @@ S:	Maintained
 
 ARM/RISCPC ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/common/time-acorn.c
@@ -758,7 +758,7 @@ S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-s3c/
@@ -766,42 +766,42 @@ F:	arch/arm/plat-s3c24xx/
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
 ARM/S3C2440 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
 
 ARM/S3C2442 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2442/
 
 ARM/S3C2443 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
 ARM/S3C6400 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6400/
 
 ARM/S3C6410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
@@ -824,7 +824,7 @@ S:	Maintained
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
@@ -1501,7 +1501,7 @@ F:	drivers/infiniband/hw/cxgb3/
 
 CYBERPRO FB DRIVER
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
@@ -4106,7 +4106,7 @@ F:	drivers/media/video/pvrusb2/
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
@@ -4119,13 +4119,13 @@ F:	sound/soc/pxa
 PXA168 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Jason Chagas <jason.chagas@marvell.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
 PXA910 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
@@ -4561,7 +4561,7 @@ F:	drivers/misc/sgi-xp/
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
