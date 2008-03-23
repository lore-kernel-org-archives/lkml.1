Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYCWIJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYCWIJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbYCWIHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:43 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1939 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbYCWIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:35 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 020/148] include/asm-x86/current_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:55 -0700
Message-Id: <1206259443-13210-21-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/current_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/current_32.h b/include/asm-x86/current_32.h
index d352485..5af9bdb 100644
--- a/include/asm-x86/current_32.h
+++ b/include/asm-x86/current_32.h
@@ -11,7 +11,7 @@ static __always_inline struct task_struct *get_current(void)
 {
 	return x86_read_percpu(current_task);
 }
- 
+
 #define current get_current()
 
 #endif /* !(_I386_CURRENT_H) */
-- 
1.5.4.rc2

