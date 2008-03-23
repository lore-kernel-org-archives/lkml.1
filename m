Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbYCWIju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbYCWIju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbYCWIKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:30 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2305 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759811AbYCWIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:26 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 039/148] include/asm-x86/geode.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:14 -0700
Message-Id: <1206259443-13210-40-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/geode.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index c208398..b1bdf63 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -177,7 +177,7 @@ static inline int is_geode(void)
 /* MFGPTs */
 
 #define MFGPT_MAX_TIMERS	8
-#define MFGPT_TIMER_ANY		-1
+#define MFGPT_TIMER_ANY		(-1)
 
 #define MFGPT_DOMAIN_WORKING	1
 #define MFGPT_DOMAIN_STANDBY	2
-- 
1.5.4.rc2

