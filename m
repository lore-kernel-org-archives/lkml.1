Return-Path: <linux-kernel-owner+w=401wt.eu-S1761721AbXLQTdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721AbXLQTdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbXLQTb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:27 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2938 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbXLQTbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:24 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jes Sorensen <jes@sgi.com>,
       Tony Luck <tony.luck@intel.com>, linux-altix@sgi.com,
       linux-ia64@vger.kernel.org
Subject: [PATCH] arch/ia64/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:05 -0800
Message-Id: <1197919875-5288-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/sn/pci/tioce_provider.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index cee9379..e1a3e19 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -41,7 +41,7 @@
  *	} else
  *		do desired mmr access
  *
- * According to hw, we can use reads instead of writes to the above addres
+ * According to hw, we can use reads instead of writes to the above address
  *
  * Note this WAR can only to be used for accessing internal MMR's in the
  * TIOCE Coretalk Address Range 0x0 - 0x07ff_ffff.  This includes the
-- 
1.5.3.7.949.g2221a6

