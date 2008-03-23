Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbYCWIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbYCWIrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759981AbYCWILM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:12 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2323 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbYCWILK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:10 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 132/148] include/asm-x86/tsc.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:47 -0700
Message-Id: <1206259443-13210-133-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/tsc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 7d3e27f..d2d8eb5 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -42,7 +42,7 @@ static inline cycles_t vget_cycles(void)
 	if (!cpu_has_tsc)
 		return 0;
 #endif
-	return (cycles_t) __native_read_tsc();
+	return (cycles_t)__native_read_tsc();
 }
 
 extern void tsc_init(void);
-- 
1.5.4.rc2

