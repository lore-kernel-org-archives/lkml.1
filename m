Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbYCWItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbYCWItX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760062AbYCWIL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:26 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2329 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760059AbYCWILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:25 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 101/148] include/asm-x86/proto.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:16 -0700
Message-Id: <1206259443-13210-102-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/proto.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/proto.h b/include/asm-x86/proto.h
index 68563c0..9da46af 100644
--- a/include/asm-x86/proto.h
+++ b/include/asm-x86/proto.h
@@ -26,7 +26,7 @@ extern int reboot_force;
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
-#define round_up(x,y) (((x) + (y) - 1) & ~((y)-1))
-#define round_down(x,y) ((x) & ~((y)-1))
+#define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
+#define round_down(x, y) ((x) & ~((y) - 1))
 
 #endif
-- 
1.5.4.rc2

