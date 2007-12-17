Return-Path: <linux-kernel-owner+w=401wt.eu-S936468AbXLQT7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936468AbXLQT7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764098AbXLQTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:29 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3201 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764110AbXLQTlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:17 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH] include/asm-frv/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:22 -0800
Message-Id: <1197920439-5455-16-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-frv/cacheflush.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-frv/cacheflush.h b/include/asm-frv/cacheflush.h
index 0250040..432a69e 100644
--- a/include/asm-frv/cacheflush.h
+++ b/include/asm-frv/cacheflush.h
@@ -29,7 +29,7 @@
 #define flush_dcache_mmap_unlock(mapping)	do {} while(0)
 
 /*
- * physically-indexed cache managment
+ * physically-indexed cache management
  * - see arch/frv/lib/cache.S
  */
 extern void frv_dcache_writeback(unsigned long start, unsigned long size);
-- 
1.5.3.7.949.g2221a6

