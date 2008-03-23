Return-Path: <linux-kernel-owner+w=401wt.eu-S1764394AbYCWJJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764394AbYCWJJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbYCWIMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:35 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2380 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760263AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 129/148] include/asm-x86/thread_info.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:44 -0700
Message-Id: <1206259443-13210-130-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/thread_info.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 407b88c..9c93845 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -8,6 +8,7 @@
 #ifndef __ASSEMBLY__
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
-extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern int arch_dup_task_struct(struct task_struct *dst,
+				struct task_struct *src);
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
-- 
1.5.4.rc2

