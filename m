Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbYCWIO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbYCWIO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYCWIIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2245 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758899AbYCWIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:08 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 029/148] include/asm-x86/e820_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:04 -0700
Message-Id: <1206259443-13210-30-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/e820_32.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/e820_32.h b/include/asm-x86/e820_32.h
index e7207a6..43b1a8b 100644
--- a/include/asm-x86/e820_32.h
+++ b/include/asm-x86/e820_32.h
@@ -34,8 +34,8 @@ extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
 extern void init_iomem_resources(struct resource *code_resource,
-			    struct resource *data_resource,
-			    struct resource *bss_resource);
+				 struct resource *data_resource,
+				 struct resource *bss_resource);
 
 #if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 extern void e820_mark_nosave_regions(void);
-- 
1.5.4.rc2

