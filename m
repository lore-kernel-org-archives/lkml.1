Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbYCWI5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbYCWI5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760221AbYCWILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:55 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2348 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760153AbYCWILp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:45 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 040/148] include/asm-x86/highmem.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:15 -0700
Message-Id: <1206259443-13210-41-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/highmem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index 479767c..e153f3b 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -8,7 +8,7 @@
  *		      Gerhard.Wichert@pdb.siemens.de
  *
  *
- * Redesigned the x86 32-bit VM architecture to deal with 
+ * Redesigned the x86 32-bit VM architecture to deal with
  * up to 16 Terabyte physical memory. With current x86 CPUs
  * we now support up to 64 Gigabytes physical RAM.
  *
-- 
1.5.4.rc2

