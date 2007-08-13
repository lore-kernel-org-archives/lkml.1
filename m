Return-Path: <linux-kernel-owner+w=401wt.eu-S941457AbXHMHYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941457AbXHMHYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966122AbXHMGZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3977 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938433AbXHMGZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:21 -0400
Date: Sun, 12 Aug 2007 23:25:08 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxextreme@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [119/2many] MAINTAINERS - CFAG12864B LCD DRIVER
Message-ID: <46bff944.TXRyfpw7R3rhvEwe%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c26e7b..fdedf32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1160,6 +1160,8 @@ M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	drivers/auxdisplay/cfag12864b.c
+F:	include/linux/cfag12864b.h
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
