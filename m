Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZIINqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZIINqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZIINqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:46:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35264 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752290AbZIINqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:46:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Update MAINTAINERS patterns for WM831x
Date: Wed,  9 Sep 2009 14:46:43 +0100
Message-Id: <1252504003-3866-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x PMICs added a backlight driver and a new include directory.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b5300a..5c245e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5734,7 +5734,9 @@ F:	drivers/mfd/wm8*.c
 F:	drivers/power/wm83*.c
 F:	drivers/rtc/rtc-wm83*.c
 F:	drivers/regulator/wm8*.c
+F:	drivers/video/backlight/wm83*_bl.c
 F:	drivers/watchdog/wm83*_wdt.c
+F:	include/linux/mfd/wm831x/
 F:	include/linux/mfd/wm8350/
 F:	include/linux/mfd/wm8400/
 F:	sound/soc/codecs/wm8350.c
-- 
1.6.3.3

