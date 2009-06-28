Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZF1Qea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZF1Qea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZF1Q1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:43 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1118 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbZF1Q1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 25/62] drivers/mfd/twl4030-irq.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:30 -0700
Message-Id: <e94af2d6c03a0c47d2f8555d2a4cca502d10d380.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mfd/twl4030-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index bae61b2..e57f778 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -441,7 +441,7 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 	/* see what work we have */
 	spin_lock_irq(&sih_agent_lock);
 	edge_change = agent->edge_change;
-	agent->edge_change = 0;;
+	agent->edge_change = 0;
 	sih = edge_change ? agent->sih : NULL;
 	spin_unlock_irq(&sih_agent_lock);
 	if (!sih)
-- 
1.6.3.1.10.g659a0.dirty

