Return-Path: <linux-kernel-owner+w=401wt.eu-S1764459AbXLQTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764459AbXLQTrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbXLQTcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:05 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3030 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761351AbXLQTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/input/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:37 -0800
Message-Id: <1197919875-5288-38-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/serio/gscps2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 3e99df6..adc3bd6 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -141,7 +141,7 @@ static void gscps2_flush(struct gscps2port *ps2port)
 /*
  * gscps2_writeb_output() - write a byte to the port
  *
- * returns 1 on sucess, 0 on error
+ * returns 1 on success, 0 on error
  */
 
 static inline int gscps2_writeb_output(struct gscps2port *ps2port, u8 data)
-- 
1.5.3.7.949.g2221a6

