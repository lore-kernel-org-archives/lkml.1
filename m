Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYCWJA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYCWJA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYCWIME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:04 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2352 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbYCWILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 050/148] include/asm-x86/io.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:25 -0700
Message-Id: <1206259443-13210-51-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/io.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index 616c9f0..99694ce 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -11,7 +11,7 @@
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
-extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
+extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
 
 extern void *xlate_dev_mem_ptr(unsigned long phys);
 extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
-- 
1.5.4.rc2

