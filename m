Return-Path: <linux-kernel-owner+w=401wt.eu-S940571AbXHMKqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940571AbXHMKqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967339AbXHMGg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1885 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967331AbXHMGg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:27 -0400
Date: Sun, 12 Aug 2007 23:30:51 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, prasanna@in.ibm.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH] [282/2many] MAINTAINERS - KPROBES
Message-ID: <46bffa9b.dx9+NQkPWG7Xh1MJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 71738bd..534403d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2708,6 +2708,9 @@ P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/kprobes.txt
+F:	include/linux/kprobes.h
+F:	kernel/kprobes.c
 
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
