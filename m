Return-Path: <linux-kernel-owner+w=401wt.eu-S967991AbXHMGrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967991AbXHMGrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965851AbXHMGXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3615 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965849AbXHMGXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:16 -0400
Date: Sun, 12 Aug 2007 23:23:01 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [52/2many] MAINTAINERS - ARM/AJECO 1ARM MACHINE SUPPORT
Message-ID: <46bff8c5.5occjyLKcNwruLbN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fb9c4a5..ec54328 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -489,6 +489,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-at91/board-1arm.c
+F:	include/asm-arm/arch-at91/
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 P:      Andrew Victor
