Return-Path: <linux-kernel-owner+w=401wt.eu-S1764669AbXLQTpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764669AbXLQTpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbXLQTcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:00 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3019 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760997AbXLQTb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:57 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org
Subject: [PATCH] drivers/i2c/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:34 -0800
Message-Id: <1197919875-5288-35-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/i2c/busses/i2c-at91.c     |    2 +-
 drivers/i2c/busses/i2c-powermac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 9c8b6d5..c09b036 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -135,7 +135,7 @@ static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int length)
  * Generic i2c master transfer entrypoint.
  *
  * Note: We do not use Atmel's feature of storing the "internal device address".
- * Instead the "internal device address" has to be written using a seperate
+ * Instead the "internal device address" has to be written using a separate
  * i2c message.
  * http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2004-September/024411.html
  */
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 0ab4f26..7813127 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -94,7 +94,7 @@ static s32 i2c_powermac_smbus_xfer(	struct i2c_adapter*	adap,
 	    	break;
 
 	/* Note that these are broken vs. the expected smbus API where
-	 * on reads, the lenght is actually returned from the function,
+	 * on reads, the length is actually returned from the function,
 	 * but I think the current API makes no sense and I don't want
 	 * any driver that I haven't verified for correctness to go
 	 * anywhere near a pmac i2c bus anyway ...
-- 
1.5.3.7.949.g2221a6

