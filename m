Return-Path: <linux-kernel-owner+w=401wt.eu-S939824AbXHMG4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939824AbXHMG4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965893AbXHMGXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3698 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965850AbXHMGXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:44 -0400
Date: Sun, 12 Aug 2007 23:23:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [67/2many] MAINTAINERS - ARM/RADISYS ENP2611 MACHINE
 SUPPORT
Message-ID: <46bff8e2.k9rkGGiI0TbWHv/r%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3761d06..e0ba633 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -647,6 +647,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp2000/enp2611.c
+F:	include/asm-arm/arch-ixp2000/
 
 ARM/SHARK MACHINE SUPPORT
 P:	Alexander Schulz
