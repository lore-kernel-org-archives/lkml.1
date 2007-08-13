Return-Path: <linux-kernel-owner+w=401wt.eu-S936852AbXHMHAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936852AbXHMHAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965923AbXHMGYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3757 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966069AbXHMGYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:07 -0400
Date: Sun, 12 Aug 2007 23:23:54 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxextreme@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [80/2many] MAINTAINERS - AUXILIARY DISPLAY DRIVERS
Message-ID: <46bff8fa.jPPVBOEkQ5RmiYoK%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0042bf6..9e28325 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -808,6 +808,8 @@ M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	drivers/auxdisplay/
+F:	include/linux/cfag12864b.h
 
 AVR32 ARCHITECTURE
 P:	Haavard Skinnemoen
