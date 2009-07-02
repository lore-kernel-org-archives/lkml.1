Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZGBPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZGBPnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZGBPnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:43:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48191 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756649AbZGBPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:43:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] MAINTAINERS: Add entry for Wolfson PMIC drivers
Date: Thu,  2 Jul 2009 16:43:08 +0100
Message-Id: <1246549388-29007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf4abdd..b9a1e2d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6278,6 +6278,24 @@ S:	Supported
 F:	drivers/input/touchscreen/*wm97*
 F:	include/linux/wm97xx.h
 
+WOLFSON MICROELECTRONICS PMIC DRIVERS
+P:	Mark Brown
+M:	broonie@opensource.wolfsonmicro.com
+L:	linux-kernel@vger.kernel.org
+T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
+W:	http://opensource.wolfsonmicro.com/node/8
+S:	Supported
+F:	drivers/leds/leds-wm83*.c
+F:	drivers/mfd/wm8*.c
+F:	drivers/power/wm83*.c
+F:	drivers/rtc/rtc-wm83*.c
+F:	drivers/regulator/wm8*.c
+F:	drivers/watchdog/wm83*_wdt.c
+F:	include/linux/mfd/wm8350/
+F:	include/linux/mfd/wm8400/
+F:	sound/soc/codecs/wm8350.c
+F:	sound/soc/codecs/wm8400.c
+
 X.25 NETWORK LAYER
 P:	Henner Eisen
 M:	eis@baty.hanse.de
-- 
1.6.3.3

