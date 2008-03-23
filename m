Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbYCWIsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbYCWIsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYCWILW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:22 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2327 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbYCWILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:19 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 110/148] include/asm-x86/setup.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:25 -0700
Message-Id: <1206259443-13210-111-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/setup.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index f745de2..fa6763a 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -55,8 +55,8 @@ struct e820entry;
 char * __init machine_specific_memory_setup(void);
 char *memory_setup(void);
 
-int __init copy_e820_map(struct e820entry * biosmap, int nr_map);
-int __init sanitize_e820_map(struct e820entry * biosmap, char * pnr_map);
+int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
+int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map);
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
 
-- 
1.5.4.rc2

