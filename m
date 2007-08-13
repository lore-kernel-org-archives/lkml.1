Return-Path: <linux-kernel-owner+w=401wt.eu-S966475AbXHMIDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966475AbXHMIDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966542AbXHMG1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4388 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966359AbXHMG1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:46 -0400
Date: Sun, 12 Aug 2007 23:27:32 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, adaplas@gmail.com
Subject: [PATCH] [192/2many] MAINTAINERS - FRAMEBUFFER LAYER
Message-ID: <46bff9d4.hTB27P/Vd9PZG86o%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d92f67..e06f478 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1847,6 +1847,9 @@ M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
+F:	Documentation/fb/
+F:	drivers/video/fb*
+F:	include/linux/fb.h
 
 FREESCALE SOC FS_ENET DRIVER
 P:	Pantelis Antoniou
