Return-Path: <linux-kernel-owner+w=401wt.eu-S939770AbXHMGx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939770AbXHMGx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965936AbXHMGXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3677 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964905AbXHMGXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:36 -0400
Date: Sun, 12 Aug 2007 23:23:22 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel@wantstofly.org, akpm@linux-foundation.org
Subject: [PATCH] [63/2many] MAINTAINERS - ARM/INTEL IXP23XX ARM
 ARCHITECTURE
Message-ID: <46bff8da.UpViP5ePqQ9Dz8Lq%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c606361..b43eda2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -595,6 +595,8 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp23xx/
+F:	include/asm-arm/arch-ixp23xx/
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 P:	Lennert Buytenhek
