Return-Path: <linux-kernel-owner+w=401wt.eu-S942736AbXHMHr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942736AbXHMHr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966392AbXHMG0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4211 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966368AbXHMG0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:45 -0400
Date: Sun, 12 Aug 2007 23:25:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, muli@il.ibm.com,
       linux-kernel@vger.kernel.org, jdmason@kudzu.us, discuss@x86-64.org,
       akpm@linux-foundation.org
Subject: [PATCH] [118/2many] MAINTAINERS - CALGARY x86-64 IOMMU
Message-ID: <46bff942.x4ZM/iFABMD4F1sR%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 482d255..9c26e7b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1148,6 +1148,11 @@ M:	jdmason@kudzu.us
 L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
+F:	arch/x86_64/kernel/pci-calgary.c
+F:	arch/x86_64/kernel/pci-dma.c
+F:	arch/x86_64/kernel/tce.c
+F:	include/asm-x86_6/calgary.h
+F:	include/asm-x86_6/pci.h
 
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
