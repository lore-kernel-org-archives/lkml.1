Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYBQJvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYBQJvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYBQJuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:50:55 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:50633 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbYBQJuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:50:54 -0500
Date: Sun, 17 Feb 2008 10:50:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: linux-fbdev is moderated
Message-ID: <Pine.LNX.4.64.0802171050220.6848@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While linux-fbdev is subscribers-only, non-subscribers are not plainly
rejected, but moderated, so the casual patch/comment/question comes through.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -697,7 +697,7 @@ S:	Supported
 ATMEL LCDFB DRIVER
 P:	Nicolas Ferre
 M:	nicolas.ferre@atmel.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 ATMEL MACB ETHERNET DRIVER
@@ -1202,7 +1202,7 @@ S:	Maintained
 CYBLAFB FRAMEBUFFER DRIVER
 P:	Knut Petersen
 M:	Knut_Petersen@t-online.de
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 CYCLADES 2X SYNC CARD DRIVER
@@ -1580,7 +1580,7 @@ S:	Supported
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
 
@@ -1965,7 +1965,7 @@ L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
 
 INFINIBAND SUBSYSTEM
@@ -1999,13 +1999,13 @@ S:	Maintained
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
@@ -2601,7 +2601,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
@@ -2910,7 +2910,7 @@ S:	Maintained
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 OPENCORES I2C BUS DRIVER
@@ -3239,13 +3239,13 @@ S:	Maintained
 RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
 M:	paulus@samba.org
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
@@ -3350,7 +3350,7 @@ S:	Maintained
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 S390

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
