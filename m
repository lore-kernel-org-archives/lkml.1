Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbYCWISd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbYCWISd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759257AbYCWIIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:43 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2257 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbYCWIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 137/148] include/asm-x86/unistd_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:52 -0700
Message-Id: <1206259443-13210-138-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/unistd_64.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index 3883ceb..fe26e36 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_64_UNISTD_H_
 
 #ifndef __SYSCALL
-#define __SYSCALL(a,b)
+#define __SYSCALL(a, b)
 #endif
 
 /*
-- 
1.5.4.rc2

