Return-Path: <linux-kernel-owner+w=401wt.eu-S1765922AbXHMKKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765922AbXHMKKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967105AbXHMGdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1316 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967019AbXHMGdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:15 -0400
Date: Sun, 12 Aug 2007 23:33:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, adaplas@gmail.com
Subject: [PATCH] [349/2many] MAINTAINERS - NVIDIA (rivafb and nvidiafb)
 FRAMEBUFFER DRIVER
Message-ID: <46bffb1c.Oh4RIR+UyQt8lXV7%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fa4b1bf..6e78725 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3358,6 +3358,8 @@ P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/riva/
+F:	drivers/video/nvidia/
 
 NETERION (S2IO) Xframe 10GbE DRIVER
 P:	Ramkrishna Vepa
