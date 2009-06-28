Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbZF1Qhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbZF1Qhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbZF1Q2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:01 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1143 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbZF1Q1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:54 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 38/62] drivers/rtc/rtc-omap.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:43 -0700
Message-Id: <b2f1b64cc00b0727a7bb385d8ba639adc318752c.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/rtc/rtc-omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index bd1ce8e..0587d53 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -430,7 +430,7 @@ fail:
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device	*rtc = platform_get_drvdata(pdev);;
+	struct rtc_device	*rtc = platform_get_drvdata(pdev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
-- 
1.6.3.1.10.g659a0.dirty

