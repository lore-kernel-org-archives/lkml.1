Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbZF1Qkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbZF1Qkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbZF1Q2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:30 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1176 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbZF1Q2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 52/62] drivers/watchdog/bcm47xx_wdt.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:57 -0700
Message-Id: <24eea6cba10492e0a19cbb341335e0e024b2a949.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/bcm47xx_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 5c7011c..751c003 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -161,7 +161,7 @@ static long bcm47xx_wdt_ioctl(struct file *file,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	int new_value, retval = -EINVAL;;
+	int new_value, retval = -EINVAL;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-- 
1.6.3.1.10.g659a0.dirty

