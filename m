Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZF1Qfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZF1Qfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZF1Q14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:56 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1141 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZF1Q1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:53 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 37/62] drivers/regulator/pcf50633-regulator.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:42 -0700
Message-Id: <f56b87d6e81de7d97625fb6c340900ee4f30a30e.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/regulator/pcf50633-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 8e14900..70ba775 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -155,7 +155,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
 	int regulator_id, millivolts, volt_bits;
 	u8 regnr;
 
-	pcf = rdev_get_drvdata(rdev);;
+	pcf = rdev_get_drvdata(rdev);
 
 	regulator_id = rdev_get_id(rdev);
 	if (regulator_id >= PCF50633_NUM_REGULATORS)
-- 
1.6.3.1.10.g659a0.dirty

