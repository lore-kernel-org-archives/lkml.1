Return-Path: <linux-kernel-owner+w=401wt.eu-S966361AbXHMH0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966361AbXHMH0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966208AbXHMGZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3982 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965761AbXHMGZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:23 -0400
Date: Sun, 12 Aug 2007 23:25:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxextreme@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER
 DRIVER
Message-ID: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fdedf32..0f5a92f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1169,6 +1169,8 @@ M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	drivers/auxdisplay/cfag12864bfb.c
+F:	include/linux/cfag12864b.h
 
 CFG80211 and NL80211
 P:	Johannes Berg
