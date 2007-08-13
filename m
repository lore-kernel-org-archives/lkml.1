Return-Path: <linux-kernel-owner+w=401wt.eu-S968165AbXHMGtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968165AbXHMGtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965880AbXHMGX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3641 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965869AbXHMGXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:25 -0400
Date: Sun, 12 Aug 2007 23:23:11 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [57/2many] MAINTAINERS - ARM/GLOMATION GESBC9312SX
 MACHINE SUPPORT
Message-ID: <46bff8cf.mPd/PGXTt9E1ALmQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2176101..926fb9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -529,6 +529,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/gesbc9312.c
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/HP JORNADA 7XX MACHINE SUPPORT
 P:      Kristoffer Ericson
