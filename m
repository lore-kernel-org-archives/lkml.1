Return-Path: <linux-kernel-owner+w=401wt.eu-S943441AbXHMJ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943441AbXHMJ1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966752AbXHMGc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1101 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966511AbXHMGcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:00 -0400
Date: Sun, 12 Aug 2007 23:31:46 -0700
From: joe@perches.com
To: vandrove@vc.cvut.cz, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [311/2many] MAINTAINERS - MATROX FRAMEBUFFER DRIVER
Message-ID: <46bffad2.KskgJ46/7qymvwcO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ce9418a..f200501 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2998,6 +2998,8 @@ P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/matrox/matroxfb_*
+F:	include/linux/matroxfb.h
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 P:	Hans J. Koch
