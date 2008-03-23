Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbYCWI1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbYCWI1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbYCWIJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:23 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2278 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbYCWIJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:21 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 084/148] include/asm-x86/param.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:59 -0700
Message-Id: <1206259443-13210-85-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/param.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/param.h b/include/asm-x86/param.h
index c996ec4..6f0d042 100644
--- a/include/asm-x86/param.h
+++ b/include/asm-x86/param.h
@@ -3,8 +3,8 @@
 
 #ifdef __KERNEL__
 # define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-# define USER_HZ	100		/* .. some user interfaces are in "ticks" */
-# define CLOCKS_PER_SEC	(USER_HZ)       /* like times() */
+# define USER_HZ	100		/* some user interfaces are */
+# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
 #endif
 
 #ifndef HZ
-- 
1.5.4.rc2

