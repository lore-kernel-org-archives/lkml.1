Return-Path: <linux-kernel-owner+w=401wt.eu-S935631AbXLQTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631AbXLQTzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbXLQTlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:14 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3184 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762462AbXLQTlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/serial/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:15 -0800
Message-Id: <1197920439-5455-9-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/mux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mux.c b/drivers/serial/mux.c
index 8321101..e940317 100644
--- a/drivers/serial/mux.c
+++ b/drivers/serial/mux.c
@@ -582,7 +582,7 @@ static struct parisc_driver serial_mux_driver = {
 };
 
 /**
- * mux_init - Serial MUX initalization procedure.
+ * mux_init - Serial MUX initialization procedure.
  *
  * Register the Serial MUX driver.
  */
-- 
1.5.3.7.949.g2221a6

