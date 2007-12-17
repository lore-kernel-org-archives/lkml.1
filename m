Return-Path: <linux-kernel-owner+w=401wt.eu-S936406AbXLQT6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936406AbXLQT6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762862AbXLQTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:26 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3196 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762944AbXLQTlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:09 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/watchdog/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:20 -0800
Message-Id: <1197920439-5455-14-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/shwdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index cecbedd..61dde86 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -52,7 +52,7 @@
  * overflow periods respectively.
  *
  * Also, since we can't really expect userspace to be responsive enough
- * before the overflow happens, we maintain two seperate timers .. One in
+ * before the overflow happens, we maintain two separate timers .. One in
  * the kernel for clearing out WOVF every 2ms or so (again, this depends on
  * HZ == 1000), and another for monitoring userspace writes to the WDT device.
  *
-- 
1.5.3.7.949.g2221a6

