Return-Path: <linux-kernel-owner+w=401wt.eu-S1765140AbXLQTqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765140AbXLQTqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbXLQTcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:04 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3022 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761115AbXLQTb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:58 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Subject: [PATCH] drivers/ide/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:35 -0800
Message-Id: <1197919875-5288-36-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/pci/cs5535.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 9094916..ddcbeba 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -49,7 +49,7 @@
 #define ATAC_BM0_PRD		0x04
 #define CS5535_CABLE_DETECT	0x48
 
-/* Format I PIO settings. We seperate out cmd and data for safer timings */
+/* Format I PIO settings. We separate out cmd and data for safer timings */
 
 static unsigned int cs5535_pio_cmd_timings[5] =
 { 0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131 };
-- 
1.5.3.7.949.g2221a6

