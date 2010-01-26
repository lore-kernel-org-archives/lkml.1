Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501Ab0AZEOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0AZEOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998Ab0AZEOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:14:40 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:23246 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0AZEOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:14:39 -0500
Date: Mon, 25 Jan 2010 21:14:37 -0700
From: Alex Chiang <achiang@hp.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: trivial: fix typos in user-visible Kconfig text
Message-ID: <20100126041437.GA25411@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Kconfig text for some Wolfson Micro devices.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 262f62e..c565e0d 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -91,14 +91,14 @@ config REGULATOR_WM831X
 	  of PMIC devices.
 
 config REGULATOR_WM8350
-	tristate "Wolfson Microelectroncis WM8350 AudioPlus PMIC"
+	tristate "Wolfson Microelectronics WM8350 AudioPlus PMIC"
 	depends on MFD_WM8350
 	help
 	  This driver provides support for the voltage and current regulators
           of the WM8350 AudioPlus PMIC.
 
 config REGULATOR_WM8400
-	tristate "Wolfson Microelectroncis WM8400 AudioPlus PMIC"
+	tristate "Wolfson Microelectronics WM8400 AudioPlus PMIC"
 	depends on MFD_WM8400
 	help
 	  This driver provides support for the voltage regulators of the
