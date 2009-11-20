Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZKTTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZKTTxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZKTTxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:53:31 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:44818 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZKTTxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:53:30 -0500
Date: Fri, 20 Nov 2009 20:48:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-fbdev@vger.kernel.org, linux-fbdev-announce@lists.sourceforge.net,
       linux-fbdev-user@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbdev: Migrate mailing lists to vger
Message-ID: <alpine.DEB.2.00.0911202045380.22848@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fbdev mailing lists at SourceForge have been migrated to a single
mailing list at kernel.org: linux-fbdev@vger.kernel.org.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/fb/framebuffer.txt |    6 ++----
 MAINTAINERS                      |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/Documentation/fb/framebuffer.txt b/Documentation/fb/framebuffer.txt
index b3e3a03..fe79e3c 100644
--- a/Documentation/fb/framebuffer.txt
+++ b/Documentation/fb/framebuffer.txt
@@ -312,10 +312,8 @@ and to the following documentation:
 8. Mailing list
 ---------------
 
-There are several frame buffer device related mailing lists at SourceForge:
-  - linux-fbdev-announce@lists.sourceforge.net, for announcements,
-  - linux-fbdev-user@lists.sourceforge.net, for generic user support,
-  - linux-fbdev-devel@lists.sourceforge.net, for project developers.
+There is a frame buffer device related mailing list at kernel.org:
+linux-fbdev@vger.kernel.org.
 
 Point your web browser to http://sourceforge.net/projects/linux-fbdev/ for
 subscription information and archive browsing.
diff --git a/MAINTAINERS b/MAINTAINERS
index c824b4d..5726ffc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1027,7 +1027,7 @@ F:	drivers/serial/atmel_serial.c
 
 ATMEL LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/atmel_lcdfb.c
 F:	include/video/atmel_lcdc.h
@@ -2113,7 +2113,7 @@ F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
 FRAMEBUFFER LAYER
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 W:	http://linux-fbdev.sourceforge.net/
 S:	Orphan
 F:	Documentation/fb/
@@ -2136,7 +2136,7 @@ F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
@@ -2635,7 +2635,7 @@ S:	Supported
 F:	security/integrity/ima/
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Orphan
 F:	drivers/video/imsttfb.c
 
@@ -2670,14 +2670,14 @@ F:	drivers/input/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Sylvain Meyer <sylvain.meyer@worldonline.fr>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/fb/intelfb.txt
 F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/i810/
 
@@ -3391,7 +3391,7 @@ S:	Supported
 
 MATROX FRAMEBUFFER DRIVER
 M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/matrox/matroxfb_*
 F:	include/linux/matroxfb.h
@@ -3778,7 +3778,7 @@ F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/riva/
 F:	drivers/video/nvidia/
@@ -3813,7 +3813,7 @@ F:	sound/soc/omap/
 
 OMAP FRAMEBUFFER SUPPORT
 M:	Imre Deak <imre.deak@nokia.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/video/omap/
@@ -4319,14 +4319,14 @@ F:	include/linux/qnxtypes.h
 
 RADEON FRAMEBUFFER DISPLAY DRIVER
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/aty/radeon*
 F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 M:	Paul Mackerras <paulus@samba.org>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/aty/aty128fb.c
 
@@ -4465,7 +4465,7 @@ F:	drivers/net/wireless/rtl818x/rtl8187*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/savage/
 
@@ -5628,7 +5628,7 @@ S:	Maintained
 
 UVESAFB DRIVER
 M:	Michal Januszewski <spock@gentoo.org>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 W:	http://dev.gentoo.org/~spock/projects/uvesafb/
 S:	Maintained
 F:	Documentation/fb/uvesafb.txt
@@ -5661,7 +5661,7 @@ F:	drivers/mmc/host/via-sdmmc.c
 VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
 M:	Joseph Chan <JosephChan@via.com.tw>
 M:	Scott Fang <ScottFang@viatech.com.cn>
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/via/
 
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
