Return-Path: <linux-kernel-owner+w=401wt.eu-S968204AbXHMGvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968204AbXHMGvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965885AbXHMGX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3645 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965877AbXHMGX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:26 -0400
Date: Sun, 12 Aug 2007 23:23:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kristoffer.ericson@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [58/2many] MAINTAINERS - ARM/HP JORNADA 7XX MACHINE
 SUPPORT
Message-ID: <46bff8d0.FdXR5tg5BuHPzlZT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 926fb9f..1fb8063 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -533,10 +533,12 @@ F:	arch/arm/mach-ep93xx/gesbc9312.c
 F:	include/asm-arm/arch-ep93xx/
 
 ARM/HP JORNADA 7XX MACHINE SUPPORT
-P:      Kristoffer Ericson
-M:      kristoffer.ericson@gmail.com
-W:      www.jlime.com
-S:      Maintained
+P:	Kristoffer Ericson
+M:	kristoffer.ericson@gmail.com
+W:	www.jlime.com
+S:	Maintained
+F:	arch/arm/mach-sa1100/jornada*
+F:	include/asm-arm/arch-sa1100/
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 P:	Lennert Buytenhek
