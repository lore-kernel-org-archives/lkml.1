Return-Path: <linux-kernel-owner+w=401wt.eu-S936362AbXLQT44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936362AbXLQT44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762462AbXLQTlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:17 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3186 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703AbXLQTlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:04 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       netdev@vger.kernel.org
Subject: [PATCH] drivers/ssb/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:17 -0800
Message-Id: <1197920439-5455-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ssb/b43_pci_bridge.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/b43_pci_bridge.c b/drivers/ssb/b43_pci_bridge.c
index f145d8a..310b84f 100644
--- a/drivers/ssb/b43_pci_bridge.c
+++ b/drivers/ssb/b43_pci_bridge.c
@@ -1,7 +1,7 @@
 /*
  * Broadcom 43xx PCI-SSB bridge module
  *
- * This technically is a seperate PCI driver module, but
+ * This technically is a separate PCI driver module, but
  * because of its small size we include it in the SSB core
  * instead of creating a standalone module.
  *
-- 
1.5.3.7.949.g2221a6

