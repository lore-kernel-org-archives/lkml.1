Return-Path: <linux-kernel-owner+w=401wt.eu-S936610AbXLQUBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936610AbXLQUBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934276AbXLQTlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:47 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3216 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762946AbXLQTl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:26 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:28 -0800
Message-Id: <1197920439-5455-22-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/crc32.c                |    2 +-
 lib/zlib_deflate/defutil.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index d2c2f25..49d1c9e 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(crc32_be);
  * but again the multiple of the polynomial to subtract depends only on
  * the high bits, the high 8 bits in this case.  
  *
- * The multile we need in that case is the low 32 bits of a 40-bit
+ * The multiple we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the
  * generator polynomial.  This is simply the CRC-32 of the given
  * one-byte message.
diff --git a/lib/zlib_deflate/defutil.h b/lib/zlib_deflate/defutil.h
index d9feaf6..6b15a90 100644
--- a/lib/zlib_deflate/defutil.h
+++ b/lib/zlib_deflate/defutil.h
@@ -164,7 +164,7 @@ typedef struct deflate_state {
     int nice_match; /* Stop searching when current match exceeds this */
 
                 /* used by trees.c: */
-    /* Didn't use ct_data typedef below to supress compiler warning */
+    /* Didn't use ct_data typedef below to suppress compiler warning */
     struct ct_data_s dyn_ltree[HEAP_SIZE];   /* literal and length tree */
     struct ct_data_s dyn_dtree[2*D_CODES+1]; /* distance tree */
     struct ct_data_s bl_tree[2*BL_CODES+1];  /* Huffman tree for bit lengths */
-- 
1.5.3.7.949.g2221a6

