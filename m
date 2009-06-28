Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZF1Qj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZF1Qj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZF1Q20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:26 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1172 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbZF1Q2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:13 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <support@simtec.co.uk>
Subject: [PATCH 51/62] drivers/video/s3c2410fb.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:56 -0700
Message-Id: <6d8c02d85332ab3174822d630d29432f3437d8cf.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/s3c2410fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 7da0027..5ffca2a 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -1119,7 +1119,7 @@ int __init s3c2410fb_init(void)
 	int ret = platform_driver_register(&s3c2410fb_driver);
 
 	if (ret == 0)
-		ret = platform_driver_register(&s3c2412fb_driver);;
+		ret = platform_driver_register(&s3c2412fb_driver);
 
 	return ret;
 }
-- 
1.6.3.1.10.g659a0.dirty

