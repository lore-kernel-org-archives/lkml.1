Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbYCWI6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbYCWI6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYCWIL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:58 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2353 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbYCWILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 044/148] include/asm-x86/i8259.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:19 -0700
Message-Id: <1206259443-13210-45-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/i8259.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/i8259.h b/include/asm-x86/i8259.h
index e2650f2..45d4df3 100644
--- a/include/asm-x86/i8259.h
+++ b/include/asm-x86/i8259.h
@@ -5,7 +5,7 @@
 
 extern unsigned int cached_irq_mask;
 
-#define __byte(x,y)		(((unsigned char *) &(y))[x])
+#define __byte(x, y)		(((unsigned char *)&(y))[x])
 #define cached_master_mask	(__byte(0, cached_irq_mask))
 #define cached_slave_mask	(__byte(1, cached_irq_mask))
 
-- 
1.5.4.rc2

