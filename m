Return-Path: <linux-kernel-owner+w=401wt.eu-S939629AbXHMGyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939629AbXHMGyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965944AbXHMGXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3683 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965298AbXHMGXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:38 -0400
Date: Sun, 12 Aug 2007 23:23:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [64/2many] MAINTAINERS - ARM/LOGICPD PXA270 MACHINE
 SUPPORT
Message-ID: <46bff8dc.0OPgDjGBx7mNhXAn%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b43eda2..6387b12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -617,6 +617,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-pxa/
+F:	include/asm-arm/arch-pxa/
 
 ARM/TOSA MACHINE SUPPORT
 P:	Dirk Opfer
