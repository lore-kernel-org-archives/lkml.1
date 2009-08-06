Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZHFQeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZHFQeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZHFQeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:34:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4247 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZHFQeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:34:11 -0400
Subject: [PATCH] MAINTAINERS: Add list entries linux-arm@vger.kernel.org
 and linux-arm-kernel@ to OMAP sections
From: Joe Perches <joe@perches.com>
To: linux-omap@vger.kernel.org
Cc: linux-arm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 09:34:10 -0700
Message-Id: <1249576450.3467.25.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps it's useful for OMAP patches and bug reports
to CC entries to the primary and secondary ARM lists.

Added a pattern entry for OMAP USB as well.

Signed-off-by: Joe Perches

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..f237765 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3662,6 +3662,8 @@ F:	drivers/video/nvidia/
 OMAP SUPPORT
 M:	"Tony Lindgren <tony@atomide.com>" <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
@@ -3671,12 +3673,16 @@ F:	arch/arm/*omap*
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*clock*
 
 OMAP POWER MANAGEMENT SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
 
@@ -3684,6 +3690,8 @@ OMAP AUDIO SUPPORT
 M:	Jarkko Nikula <jhnikula@gmail.com>
 L:	alsa-devel@alsa-project.org (subscribers-only)
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	sound/soc/omap/
 
@@ -3691,17 +3699,24 @@ OMAP FRAMEBUFFER SUPPORT
 M:	Imre Deak <imre.deak@nokia.com>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	drivers/video/omap/
 
 OMAP MMC SUPPORT
 M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/*omap*
 
 OMAP RANDOM NUMBER GENERATOR SUPPORT
 M:	Deepak Saxena <dsaxena@plexity.net>
+L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	drivers/char/hw_random/omap-rng.c
 
@@ -3710,7 +3725,10 @@ M:	Felipe Balbi <felipe.balbi@nokia.com>
 M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/*/*omap*
 
 OMFS FILESYSTEM
 M:	Bob Copeland <me@bobcopeland.com>


