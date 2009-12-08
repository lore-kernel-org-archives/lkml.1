Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZLHSsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZLHSsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZLHSsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:48:32 -0500
Received: from mail.perches.com ([173.55.12.10]:1076 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbZLHSsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:48:32 -0500
Subject: [PATCH] MAINTAINERS: Update file patterns for WOLFSON
 MICROELECTRONICS PMIC DRIVERS
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 10:48:37 -0800
Message-ID: <1260298117.27677.61.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the includes pointed to a non-existent directory
Add Documentation/hwmon/wm8350
Add sound/soc/codecs/wm(8350|8400).h files

Signed-off-by: Joe Perches <joe@perches.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index ea781c1..39a710f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5901,6 +5901,7 @@ M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/node/8
 S:	Supported
+F:	Documentation/hwmon/wm8350
 F:	drivers/leds/leds-wm83*.c
 F:	drivers/mfd/wm8*.c
 F:	drivers/power/wm83*.c
@@ -5910,9 +5911,9 @@ F:	drivers/video/backlight/wm83*_bl.c
 F:	drivers/watchdog/wm83*_wdt.c
 F:	include/linux/mfd/wm831x/
 F:	include/linux/mfd/wm8350/
-F:	include/linux/mfd/wm8400/
-F:	sound/soc/codecs/wm8350.c
-F:	sound/soc/codecs/wm8400.c
+F:	include/linux/mfd/wm8400*
+F:	sound/soc/codecs/wm8350.*
+F:	sound/soc/codecs/wm8400.*
 
 X.25 NETWORK LAYER
 M:	Henner Eisen <eis@baty.hanse.de>


