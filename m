Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXHMG5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXHMG5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965970AbXHMGXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3702 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965966AbXHMGXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:46 -0400
Date: Sun, 12 Aug 2007 23:23:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [69/2many] MAINTAINERS - ARM/STRONGARM110 PORT
Message-ID: <46bff8e5.krpxio+c955He+uQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 92cf73a..90c1b81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -664,6 +664,8 @@ M:	rmk@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
+F:	arch/arm/mach-ebsa110/
+F:	include/asm-arm/arch-ebsa110/
 
 ARM/S3C2410 ARM ARCHITECTURE
 P:	Ben Dooks
