Return-Path: <linux-kernel-owner+w=401wt.eu-S940538AbXHMH0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940538AbXHMH0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966217AbXHMGZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3958 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936143AbXHMGZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:15 -0400
Date: Sun, 12 Aug 2007 23:23:03 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       andrew@sanpeople.com, akpm@linux-foundation.org
Subject: [PATCH] [53/2many] MAINTAINERS - ARM/ATMEL AT91RM9200 ARM
 ARCHITECTURE
Message-ID: <46bff8c7.IwRq28DzAoClR92F%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ec54328..f1318bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -493,11 +493,13 @@ F:	arch/arm/mach-at91/board-1arm.c
 F:	include/asm-arm/arch-at91/
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
-P:      Andrew Victor
-M:      andrew@sanpeople.com
-L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
-W:      http://maxim.org.za/at91_26.html
-S:      Maintained
+P:	Andrew Victor
+M:	andrew@sanpeople.com
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+W:	http://maxim.org.za/at91_26.html
+S:	Maintained
+F:	arch/arm/mach-at91/
+F:	include/asm-arm/arch-at91/
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 P:	Lennert Buytenhek
