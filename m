Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXLQTdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXLQTdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbXLQTb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:29 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2942 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247AbXLQTb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:26 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       linux-m32r-ja@ml.linux-m32r.org (in Japanese),
       linux-m32r@ml.linux-m32r.org
Subject: [PATCH] arch/m32r/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:07 -0800
Message-Id: <1197919875-5288-8-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/m32r/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index ed4d075..9aa615d 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -476,7 +476,7 @@ unregister_debug_trap(struct task_struct *child, unsigned long addr,
 		return 0;
 	}
 
-	/* Recover orignal instruction code. */
+	/* Recover original instruction code. */
 	*code = p->insn[i];
 
 	/* Shift debug trap entries. */
-- 
1.5.3.7.949.g2221a6

