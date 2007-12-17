Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbXLQTom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbXLQTom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761361AbXLQTb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:57 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3014 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761175AbXLQTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:55 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <dougthompson@xmission.com>,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH] drivers/edac/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:32 -0800
Message-Id: <1197919875-5288-33-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/edac/edac_pci.c   |    2 +-
 drivers/edac/i5000_edac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 5dee9f5..e0b47b7 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
  *
  *	Last action on the pci control structure.
  *
- *	call the remove sysfs informaton, which will unregister
+ *	call the remove sysfs information, which will unregister
  *	this control struct's kobj. When that kobj's ref count
  *	goes to zero, its release function will be call and then
  *	kfree() the memory.
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index a1f24c4..5a85201 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -351,7 +351,7 @@ struct i5000_pvt {
 	u16 b1_ambpresent0;	/* Branch 1, Channel 8 */
 	u16 b1_ambpresent1;	/* Branch 1, Channel 1 */
 
-	/* DIMM infomation matrix, allocating architecture maximums */
+	/* DIMM information matrix, allocating architecture maximums */
 	struct i5000_dimm_info dimm_info[MAX_CSROWS][MAX_CHANNELS];
 
 	/* Actual values for this controller */
-- 
1.5.3.7.949.g2221a6

