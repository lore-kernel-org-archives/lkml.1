Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZF1Qb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZF1Qb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZF1Q13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:29 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1098 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZF1Q11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:27 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, Zhang Wei <zw@zh-kernel.org>,
       Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org
Subject: [PATCH 15/62] drivers/dma/fsldma.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:20 -0700
Message-Id: <03676ce0e272d44d1d4ea19639b28afb994c65eb.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/fsldma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index f18d1bd..71ce8ed 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -136,7 +136,7 @@ static int dma_is_idle(struct fsl_dma_chan *fsl_chan)
 
 static void dma_start(struct fsl_dma_chan *fsl_chan)
 {
-	u32 mr_set = 0;;
+	u32 mr_set = 0;
 
 	if (fsl_chan->feature & FSL_DMA_CHAN_PAUSE_EXT) {
 		DMA_OUT(fsl_chan, &fsl_chan->reg_base->bcr, 0, 32);
-- 
1.6.3.1.10.g659a0.dirty

