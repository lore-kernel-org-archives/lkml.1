Return-Path: <linux-kernel-owner+w=401wt.eu-S939486AbXHMGw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939486AbXHMGw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965931AbXHMGXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3672 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965917AbXHMGXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:35 -0400
Date: Sun, 12 Aug 2007 23:23:20 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [62/2many] MAINTAINERS - ARM/INTEL IXP2000 ARM
 ARCHITECTURE
Message-ID: <46bff8d8.u1E+Q7cDPYxAuu4Q%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index aaacc55..c606361 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -581,6 +581,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp2000/
+F:	include/asm-arm/arch-ixp2000/
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 P:	Lennert Buytenhek
