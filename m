Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZKILrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZKILrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZKILqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:46:50 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41607 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZKILqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:46:38 -0500
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 19/19] MAINTAINERS: Add OMAP2/3 DSS and OMAPFB maintainer
Date: Mon,  9 Nov 2009 13:45:26 +0200
Message-Id: <1257767126-12059-20-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1257767126-12059-19-git-send-email-tomi.valkeinen@nokia.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-2-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-3-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-4-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-5-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-6-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-7-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-8-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-9-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-10-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-11-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-12-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-13-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-14-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-15-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-16-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-17-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-18-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-19-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 09 Nov 2009 11:46:21.0464 (UTC) FILETIME=[41DB7180:01CA6132]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
---
 MAINTAINERS |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd633a6..0939a2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3853,6 +3853,23 @@ L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/video/omap/
 
+OMAP DISPLAY SUBSYSTEM SUPPORT (DSS2)
+M:	Tomi Valkeinen <tomi.valkeinen@nokia.com>
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	drivers/video/omap2/dss/
+F:	drivers/video/omap2/vrfb.c
+F:	drivers/video/omap2/vram.c
+F:	Documentation/arm/OMAP/DSS
+
+OMAP FRAMEBUFFER SUPPORT (FOR DSS2)
+M:	Tomi Valkeinen <tomi.valkeinen@nokia.com>
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	drivers/video/omap2/omapfb/
+
 OMAP MMC SUPPORT
 M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
 L:	linux-omap@vger.kernel.org
-- 
1.6.5.1

