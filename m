Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbXHMGpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbXHMGpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965835AbXHMGXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3594 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936470AbXHMGXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:08 -0400
Date: Sun, 12 Aug 2007 23:22:55 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [49/2many] MAINTAINERS - ARM PRIMECELL MMCI PL180/1
 DRIVER
Message-ID: <46bff8bf.LmUR4vzWLeqv1m67%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ca4a132..7cfc5f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -466,6 +466,7 @@ P:	Russell King
 M:	rmk@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 P:	Lennert Buytenhek
