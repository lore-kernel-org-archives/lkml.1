Return-Path: <linux-kernel-owner+w=401wt.eu-S936036AbXLQTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936036AbXLQTxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933776AbXLQTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:40:53 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3174 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762921AbXLQTkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:40:52 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-parisc@vger.kernel.org
Subject: [PATCH] drivers/parisc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:10 -0800
Message-Id: <1197920439-5455-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918892.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parisc/ccio-dma.c |    4 ++--
 drivers/parisc/hppb.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 7c60cbd..ca52307 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -363,7 +363,7 @@ ccio_alloc_range(struct ioc *ioc, size_t size)
 	if (pages_needed <= 8) {
 		/*
 		 * LAN traffic will not thrash the TLB IFF the same NIC
-		 * uses 8 adjacent pages to map seperate payload data.
+		 * uses 8 adjacent pages to map separate payload data.
 		 * ie the same byte in the resource bit map.
 		 */
 #if 0
@@ -1589,7 +1589,7 @@ static int __init ccio_probe(struct parisc_device *dev)
 }
 
 /**
- * ccio_init - ccio initalization procedure.
+ * ccio_init - ccio initialization procedure.
  *
  * Register this driver.
  */
diff --git a/drivers/parisc/hppb.c b/drivers/parisc/hppb.c
index a728a7c..65eee67 100644
--- a/drivers/parisc/hppb.c
+++ b/drivers/parisc/hppb.c
@@ -95,7 +95,7 @@ static struct parisc_driver hppb_driver = {
 };
 
 /**
- * hppb_init - HP-PB bus initalization procedure.
+ * hppb_init - HP-PB bus initialization procedure.
  *
  * Register this driver.   
  */
-- 
1.5.3.7.949.g2221a6

