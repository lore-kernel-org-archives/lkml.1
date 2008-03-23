Return-Path: <linux-kernel-owner+w=401wt.eu-S1765410AbYCWInU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765410AbYCWInU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759407AbYCWIKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:49 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2313 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759931AbYCWIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:44 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 142/148] include/asm-x86/vga.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:57 -0700
Message-Id: <1206259443-13210-143-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/vga.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/vga.h b/include/asm-x86/vga.h
index 0ecf68a..0ccf804 100644
--- a/include/asm-x86/vga.h
+++ b/include/asm-x86/vga.h
@@ -12,9 +12,9 @@
  *	access the videoram directly without any black magic.
  */
 
-#define VGA_MAP_MEM(x,s) (unsigned long)phys_to_virt(x)
+#define VGA_MAP_MEM(x, s) (unsigned long)phys_to_virt(x)
 
 #define vga_readb(x) (*(x))
-#define vga_writeb(x,y) (*(y) = (x))
+#define vga_writeb(x, y) (*(y) = (x))
 
 #endif
-- 
1.5.4.rc2

