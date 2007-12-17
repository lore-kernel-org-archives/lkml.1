Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbXLQTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbXLQTpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761382AbXLQTb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:59 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3016 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbXLQTb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:56 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/firmware/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:33 -0800
Message-Id: <1197919875-5288-34-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firmware/edd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 6942e06..d41a256 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -11,7 +11,7 @@
  *
  * This code takes information provided by BIOS EDD calls
  * fn41 - Check Extensions Present and
- * fn48 - Get Device Parametes with EDD extensions
+ * fn48 - Get Device Parameters with EDD extensions
  * made in setup.S, copied to safe structures in setup.c,
  * and presents it in sysfs.
  *
-- 
1.5.3.7.949.g2221a6

