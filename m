Return-Path: <linux-kernel-owner+w=401wt.eu-S935553AbXHMKSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553AbXHMKSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967210AbXHMGez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1614 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967209AbXHMGev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:51 -0400
Date: Sun, 12 Aug 2007 23:34:37 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, akpm@linux-foundation.org
Subject: [PATCH] [398/2many] MAINTAINERS - RADEON FRAMEBUFFER DISPLAY
 DRIVER
Message-ID: <46bffb7d.tUq6cv69dFlkL8ng%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ed3be09..5d45c74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3807,6 +3807,8 @@ P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/aty/radeon*
+F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
