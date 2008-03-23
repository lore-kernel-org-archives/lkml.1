Return-Path: <linux-kernel-owner+w=401wt.eu-S1765194AbYCWIlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765194AbYCWIlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759921AbYCWIKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:42 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2309 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759904AbYCWIKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:39 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 136/148] include/asm-x86/unistd_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:51 -0700
Message-Id: <1206259443-13210-137-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/unistd_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 984123a..8317d94 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -81,7 +81,7 @@
 #define __NR_sigpending		 73
 #define __NR_sethostname	 74
 #define __NR_setrlimit		 75
-#define __NR_getrlimit		 76	/* Back compatible 2Gig limited rlimit */
+#define __NR_getrlimit		 76   /* Back compatible 2Gig limited rlimit */
 #define __NR_getrusage		 77
 #define __NR_gettimeofday	 78
 #define __NR_settimeofday	 79
-- 
1.5.4.rc2

