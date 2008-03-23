Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbYCWI1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbYCWI1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbYCWIJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:33 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2282 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759467AbYCWIJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:31 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 070/148] include/asm-x86/mmx.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:45 -0700
Message-Id: <1206259443-13210-71-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mmx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/mmx.h b/include/asm-x86/mmx.h
index 46b71da..9408812 100644
--- a/include/asm-x86/mmx.h
+++ b/include/asm-x86/mmx.h
@@ -6,7 +6,7 @@
  */
 
 #include <linux/types.h>
- 
+
 extern void *_mmx_memcpy(void *to, const void *from, size_t size);
 extern void mmx_clear_page(void *page);
 extern void mmx_copy_page(void *to, void *from);
-- 
1.5.4.rc2

