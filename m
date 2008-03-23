Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbYCWIPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbYCWIPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYCWIIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:15 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2249 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbYCWIIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:11 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 135/148] include/asm-x86/unaligned.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:50 -0700
Message-Id: <1206259443-13210-136-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/unaligned.h b/include/asm-x86/unaligned.h
index 913598d..d270ffe 100644
--- a/include/asm-x86/unaligned.h
+++ b/include/asm-x86/unaligned.h
@@ -32,6 +32,6 @@
  *
  * Note that unaligned accesses can be very expensive on some architectures.
  */
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#define put_unaligned(val, ptr) ((void)(*(ptr) = (val)))
 
 #endif /* _ASM_X86_UNALIGNED_H */
-- 
1.5.4.rc2

