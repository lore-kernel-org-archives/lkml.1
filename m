Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYKFNna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYKFNna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYKFNnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:43:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60242 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754075AbYKFNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:43:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] mfd: Remove i.MX31ism from WM8350 i2c driver
Date: Thu,  6 Nov 2008 13:43:03 +0000
Message-Id: <1225978986-25990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081106134254.GA21855@rakim.wolfsonmicro.main>
References: <20081106134254.GA21855@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-i2c.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 8dfe21b..f7e9172 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -1,8 +1,6 @@
 /*
  * wm8350-i2c.c  --  Generic I2C driver for Wolfson WM8350 PMIC
  *
- * This driver defines and configures the WM8350 for the Freescale i.MX32ADS.
- *
  * Copyright 2007, 2008 Wolfson Microelectronics PLC.
  *
  * Author: Liam Girdwood
-- 
1.5.6.5

