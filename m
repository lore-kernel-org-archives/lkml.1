Return-Path: <linux-kernel-owner+w=401wt.eu-S1764265AbYCWIrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764265AbYCWIrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbYCWILL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2322 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759955AbYCWILK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:10 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 069/148] include/asm-x86/mmu.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:44 -0700
Message-Id: <1206259443-13210-70-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mmu.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/mmu.h b/include/asm-x86/mmu.h
index efa962c..00e8867 100644
--- a/include/asm-x86/mmu.h
+++ b/include/asm-x86/mmu.h
@@ -10,10 +10,10 @@
  *
  * cpu_vm_mask is used to optimize ldt flushing.
  */
-typedef struct { 
+typedef struct {
 	void *ldt;
 #ifdef CONFIG_X86_64
-	rwlock_t ldtlock; 
+	rwlock_t ldtlock;
 #endif
 	int size;
 	struct mutex lock;
-- 
1.5.4.rc2

