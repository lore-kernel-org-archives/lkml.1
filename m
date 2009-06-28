Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbZF1Qik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbZF1Qik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZF1Q2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1167 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZF1Q2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 50/62] drivers/video/imxfb.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:55 -0700
Message-Id: <b3809f274f910612520e30bc4a53d4fcb905771c.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/imxfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 15a0ee6..89e6f1e 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -677,7 +677,7 @@ static int __init imxfb_probe(struct platform_device *pdev)
 
 	fbi->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(fbi->clk)) {
-		ret = PTR_ERR(fbi->clk);;
+		ret = PTR_ERR(fbi->clk);
 		dev_err(&pdev->dev, "unable to get clock: %d\n", ret);
 		goto failed_getclock;
 	}
-- 
1.6.3.1.10.g659a0.dirty

