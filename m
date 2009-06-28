Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZF1QeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZF1QeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZF1Q1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1119 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZF1Q1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:40 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Pisa <ppisa@pikron.com>, Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 26/62] drivers/mmc/host/imxmmc.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:31 -0700
Message-Id: <d76aa5b943c6cd92a1a02565c681575ecac48678.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/imxmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index e0be21a..bf98d7c 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -652,7 +652,7 @@ static irqreturn_t imxmci_irq(int irq, void *devid)
 	set_bit(IMXMCI_PEND_STARTED_b, &host->pending_events);
 	tasklet_schedule(&host->tasklet);
 
-	return IRQ_RETVAL(handled);;
+	return IRQ_RETVAL(handled);
 }
 
 static void imxmci_tasklet_fnc(unsigned long data)
-- 
1.6.3.1.10.g659a0.dirty

