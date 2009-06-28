Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZF1QgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZF1QgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbZF1Q16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:58 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1138 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbZF1Q1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@vger.kernel.org
Subject: [PATCH 35/62] drivers/pci/pcie/aer/ecrc.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:40 -0700
Message-Id: <e33e260ba10929dbf148ced4764de433b7bf5879.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pci/pcie/aer/ecrc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/ecrc.c b/drivers/pci/pcie/aer/ecrc.c
index ece97df..a928d8a 100644
--- a/drivers/pci/pcie/aer/ecrc.c
+++ b/drivers/pci/pcie/aer/ecrc.c
@@ -106,7 +106,7 @@ void pcie_set_ecrc_checking(struct pci_dev *dev)
 		disable_ecrc_checking(dev);
 		break;
 	case ECRC_POLICY_ON:
-		enable_ecrc_checking(dev);;
+		enable_ecrc_checking(dev);
 		break;
 	default:
 		return;
-- 
1.6.3.1.10.g659a0.dirty

