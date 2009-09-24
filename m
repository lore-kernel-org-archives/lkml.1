Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZIXSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZIXSms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZIXSmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:42:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1158 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbZIXSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:57 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/11] MAINTAINERS: Update WOLFSON MICROELECTRONICS
Date: Thu, 24 Sep 2009 11:41:59 -0700
Message-Id: <2043bdfac1bd625461d07d6029d239a99e7bb736.1253817463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1253817463.git.joe@perches.com>
References: <cover.1253817463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate P:/M: lines
Remove L: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 50c0e70..50cd5bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5731,9 +5731,7 @@ F:	drivers/input/touchscreen/*wm97*
 F:	include/linux/wm97xx.h
 
 WOLFSON MICROELECTRONICS PMIC DRIVERS
-P:	Mark Brown
-M:	broonie@opensource.wolfsonmicro.com
-L:	linux-kernel@vger.kernel.org
+M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/node/8
 S:	Supported
-- 
1.6.3.1.10.g659a0.dirty

