Return-Path: <linux-kernel-owner+w=401wt.eu-S936389AbXLQUEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936389AbXLQUEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934621AbXLQTmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:00 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3249 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXLQTli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:38 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] include/sound/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:39 -0800
Message-Id: <1197920439-5455-33-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/sound/ad1848.h      |    2 +-
 include/sound/cs4231-regs.h |    2 +-
 include/sound/soc-dapm.h    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/sound/ad1848.h b/include/sound/ad1848.h
index d04f9e7..d9aebdf 100644
--- a/include/sound/ad1848.h
+++ b/include/sound/ad1848.h
@@ -48,7 +48,7 @@
 #define AD1848_IFACE_CTRL	0x09	/* interface control - bits 7-2 MCE */
 #define AD1848_PIN_CTRL		0x0a	/* pin control */
 #define AD1848_TEST_INIT	0x0b	/* test and initialization */
-#define AD1848_MISC_INFO	0x0c	/* miscellaneaous information */
+#define AD1848_MISC_INFO	0x0c	/* miscellaneous information */
 #define AD1848_LOOPBACK		0x0d	/* loopback control */
 #define AD1848_DATA_UPR_CNT	0x0e	/* playback/capture upper base count */
 #define AD1848_DATA_LWR_CNT	0x0f	/* playback/capture lower base count */
diff --git a/include/sound/cs4231-regs.h b/include/sound/cs4231-regs.h
index f149026..e8d1f3e 100644
--- a/include/sound/cs4231-regs.h
+++ b/include/sound/cs4231-regs.h
@@ -45,7 +45,7 @@
 #define CS4231_IFACE_CTRL	0x09	/* interface control - bits 7-2 MCE */
 #define CS4231_PIN_CTRL		0x0a	/* pin control */
 #define CS4231_TEST_INIT	0x0b	/* test and initialization */
-#define CS4231_MISC_INFO	0x0c	/* miscellaneaous information */
+#define CS4231_MISC_INFO	0x0c	/* miscellaneous information */
 #define CS4231_LOOPBACK		0x0d	/* loopback control */
 #define CS4231_PLY_UPR_CNT	0x0e	/* playback upper base count */
 #define CS4231_PLY_LWR_CNT	0x0f	/* playback lower base count */
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 2b1ae8e..b9d5864 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -22,7 +22,7 @@
 #define SND_SOC_NOPM	-1
 
 /*
- * SoC dynamic audio power managment
+ * SoC dynamic audio power management
  *
  * We can have upto 4 power domains
  * 	1. Codec domain - VREF, VMID
-- 
1.5.3.7.949.g2221a6

