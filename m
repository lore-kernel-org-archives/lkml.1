Return-Path: <linux-kernel-owner+w=401wt.eu-S966301AbXHMGqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966301AbXHMGqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965856AbXHMGXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3610 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965523AbXHMGXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:14 -0400
Date: Sun, 12 Aug 2007 23:22:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [51/2many] MAINTAINERS - ARM/ADS SPHERE MACHINE SUPPORT
Message-ID: <46bff8c3.PO1aTqM6rpTuWbKJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c295d04..fb9c4a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -481,6 +481,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/adssphere.c
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/AJECO 1ARM MACHINE SUPPORT
 P:	Lennert Buytenhek
