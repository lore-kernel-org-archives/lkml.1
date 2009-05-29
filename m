Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZE2Kec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZE2Kec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZE2KeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:34:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34388 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757651AbZE2KeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:34:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix Kconfig help text for WM8350
Date: Fri, 29 May 2009 11:34:18 +0100
Message-Id: <1243593258-10378-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More with the grammar.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9554554..5d0e926 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -152,7 +152,7 @@ config MFD_WM8400
 	depends on I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
-	  CODEC.  This driver adds provides common support for accessing
+	  CODEC.  This driver provides common support for accessing
 	  the device, additional drivers must be enabled in order to use
 	  the functionality of the device.
 
-- 
1.6.3.1

