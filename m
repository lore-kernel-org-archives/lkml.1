Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYDRICx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYDRICx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYDRICg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:02:36 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:56583 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755697AbYDRICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:02:33 -0400
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH 1/1] Update email address in MODULE_AUTHOR
Date: Fri, 18 Apr 2008 10:02:30 +0200
Message-Id: <1208505750-32561-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the MODULE_AUTHOR email address for the kernel drivers I
maintain to my new, long term address.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/input/mouse/gpio_mouse.c  |    2 +-
 drivers/misc/atmel-ssc.c          |    2 +-
 drivers/rtc/rtc-at32ap700x.c      |    2 +-
 drivers/watchdog/at32ap700x_wdt.c |    2 +-
 sound/spi/at73c213.c              |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 0936d6b..012b4f2 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -191,6 +191,6 @@ static void __exit gpio_mouse_exit(void)
 }
 module_exit(gpio_mouse_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("GPIO mouse driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index e171650..496823b 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -170,7 +170,7 @@ static void __exit ssc_exit(void)
 }
 module_exit(ssc_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("SSC driver for Atmel AVR32 and AT91");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:ssc");
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 42244f1..e3c8572 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -312,6 +312,6 @@ static void __exit at32_rtc_exit(void)
 }
 module_exit(at32_rtc_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Real time clock for AVR32 AT32AP700x");
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index ae0fca5..4e50c2c 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -444,7 +444,7 @@ static void __exit at32_wdt_exit(void)
 }
 module_exit(at32_wdt_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 89d6e9c..b3c4fbc 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -1118,6 +1118,6 @@ static void __exit at73c213_exit(void)
 }
 module_exit(at73c213_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Sound driver for AT73C213 with Atmel SSC");
 MODULE_LICENSE("GPL");
-- 
1.5.4.3

