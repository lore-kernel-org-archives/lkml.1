Return-Path: <linux-kernel-owner+w=401wt.eu-S967949AbXHMGrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967949AbXHMGrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965859AbXHMGXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:21 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3624 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936470AbXHMGXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:20 -0400
Date: Sun, 12 Aug 2007 23:23:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [54/2many] MAINTAINERS - ARM/CIRRUS LOGIC EP93XX ARM
 ARCHITECTURE
Message-ID: <46bff8c9.R9N1yBrIF9CcVjFo%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f1318bb..6df336f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -506,6 +506,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 P:	Lennert Buytenhek
