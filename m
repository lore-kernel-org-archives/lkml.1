Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXLQTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXLQTfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbXLQTbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:34 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2949 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760215AbXLQTb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:29 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-parisc@vger.kernel.org
Subject: [PATCH] include/asm-parisc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:11 -0800
Message-Id: <1197919875-5288-12-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-parisc/elf.h     |    2 +-
 include/asm-parisc/linkage.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-parisc/elf.h b/include/asm-parisc/elf.h
index f628ac7..8e7946a 100644
--- a/include/asm-parisc/elf.h
+++ b/include/asm-parisc/elf.h
@@ -28,7 +28,7 @@
 #define EFA_PARISC_1_1		    0x0210 /* PA-RISC 1.1 big-endian.  */
 #define EFA_PARISC_2_0		    0x0214 /* PA-RISC 2.0 big-endian.  */
 
-/* Additional section indeces.  */
+/* Additional section indices.  */
 
 #define SHN_PARISC_ANSI_COMMON	0xff00	   /* Section for tenatively declared
 					      symbols in ANSI C.  */
diff --git a/include/asm-parisc/linkage.h b/include/asm-parisc/linkage.h
index ad8cd0d..0b19a72 100644
--- a/include/asm-parisc/linkage.h
+++ b/include/asm-parisc/linkage.h
@@ -8,7 +8,7 @@
 
 /*
  * In parisc assembly a semicolon marks a comment while a
- * exclamation mark is used to seperate independent lines.
+ * exclamation mark is used to separate independent lines.
  */
 #ifdef __ASSEMBLY__
 
-- 
1.5.3.7.949.g2221a6

