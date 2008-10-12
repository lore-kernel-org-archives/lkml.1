Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYJLM2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYJLM2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYJLM2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:28:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:52627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYJLM2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:28:04 -0400
Subject: [PATCH] input: wm97xx - update email address for Liam Girdwood
From: Liam Girdwood <lrg@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Sun, 12 Oct 2008 13:27:57 +0100
Message-Id: <1223814477.6814.351.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the email address for Liam Girdwood as my old address is no
longer valid.

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 MAINTAINERS                                  |    2 +-
 drivers/input/touchscreen/mainstone-wm97xx.c |    5 ++---
 drivers/input/touchscreen/wm9705.c           |    5 ++---
 drivers/input/touchscreen/wm9712.c           |    5 ++---
 drivers/input/touchscreen/wm9713.c           |    5 ++---
 drivers/input/touchscreen/wm97xx-core.c      |    5 ++---
 6 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 587f418..ca5f4f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4591,7 +4591,7 @@ WM97XX TOUCHSCREEN DRIVERS
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 P:	Liam Girdwood
-M:	liam.girdwood@wolfsonmicro.com
+M:	lrg@slimlogic.co.uk
 L:	linux-input@vger.kernel.org
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
 W:	http://opensource.wolfsonmicro.com/node/7
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 37a555f..ba64875 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -3,8 +3,7 @@
  *                         Wolfson WM97xx AC97 Codecs.
  *
  * Copyright 2004, 2007 Wolfson Microelectronics PLC.
- * Author: Liam Girdwood
- *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  * Parts Copyright : Ian Molton <spyro@f2s.com>
  *                   Andrew Zabolotny <zap@homelink.ru>
  *
@@ -296,6 +295,6 @@ module_init(mainstone_wm97xx_init);
 module_exit(mainstone_wm97xx_exit);
 
 /* Module information */
-MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_AUTHOR("Liam Girdwood <lrg@slimlogic.co.uk>");
 MODULE_DESCRIPTION("wm97xx continuous touch driver for mainstone");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/wm9705.c b/drivers/input/touchscreen/wm9705.c
index 372efbc..6b5be74 100644
--- a/drivers/input/touchscreen/wm9705.c
+++ b/drivers/input/touchscreen/wm9705.c
@@ -2,8 +2,7 @@
  * wm9705.c  --  Codec driver for Wolfson WM9705 AC97 Codec.
  *
  * Copyright 2003, 2004, 2005, 2006, 2007 Wolfson Microelectronics PLC.
- * Author: Liam Girdwood
- *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  * Parts Copyright : Ian Molton <spyro@f2s.com>
  *                   Andrew Zabolotny <zap@homelink.ru>
  *                   Russell King <rmk@arm.linux.org.uk>
@@ -347,6 +346,6 @@ struct wm97xx_codec_drv wm9705_codec = {
 EXPORT_SYMBOL_GPL(wm9705_codec);
 
 /* Module information */
-MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_AUTHOR("Liam Girdwood <lrg@slimlogic.co.uk>");
 MODULE_DESCRIPTION("WM9705 Touch Screen Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/wm9712.c b/drivers/input/touchscreen/wm9712.c
index c8bb1e7..7490b05 100644
--- a/drivers/input/touchscreen/wm9712.c
+++ b/drivers/input/touchscreen/wm9712.c
@@ -2,8 +2,7 @@
  * wm9712.c  --  Codec driver for Wolfson WM9712 AC97 Codecs.
  *
  * Copyright 2003, 2004, 2005, 2006, 2007 Wolfson Microelectronics PLC.
- * Author: Liam Girdwood
- *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  * Parts Copyright : Ian Molton <spyro@f2s.com>
  *                   Andrew Zabolotny <zap@homelink.ru>
  *                   Russell King <rmk@arm.linux.org.uk>
@@ -462,6 +461,6 @@ struct wm97xx_codec_drv wm9712_codec = {
 EXPORT_SYMBOL_GPL(wm9712_codec);
 
 /* Module information */
-MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_AUTHOR("Liam Girdwood <lrg@slimlogic.co.uk>");
 MODULE_DESCRIPTION("WM9712 Touch Screen Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/wm9713.c b/drivers/input/touchscreen/wm9713.c
index 781ee83..238b513 100644
--- a/drivers/input/touchscreen/wm9713.c
+++ b/drivers/input/touchscreen/wm9713.c
@@ -2,8 +2,7 @@
  * wm9713.c  --  Codec touch driver for Wolfson WM9713 AC97 Codec.
  *
  * Copyright 2003, 2004, 2005, 2006, 2007, 2008 Wolfson Microelectronics PLC.
- * Author: Liam Girdwood
- *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  * Parts Copyright : Ian Molton <spyro@f2s.com>
  *                   Andrew Zabolotny <zap@homelink.ru>
  *                   Russell King <rmk@arm.linux.org.uk>
@@ -476,6 +475,6 @@ struct wm97xx_codec_drv wm9713_codec = {
 EXPORT_SYMBOL_GPL(wm9713_codec);
 
 /* Module information */
-MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_AUTHOR("Liam Girdwood <lrg@slimlogic.co.uk>");
 MODULE_DESCRIPTION("WM9713 Touch Screen Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index d589ab0..d15aa11 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -3,8 +3,7 @@
  *                    and WM9713 AC97 Codecs.
  *
  * Copyright 2003, 2004, 2005, 2006, 2007, 2008 Wolfson Microelectronics PLC.
- * Author: Liam Girdwood
- *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  * Parts Copyright : Ian Molton <spyro@f2s.com>
  *                   Andrew Zabolotny <zap@homelink.ru>
  *                   Russell King <rmk@arm.linux.org.uk>
@@ -824,6 +823,6 @@ module_init(wm97xx_init);
 module_exit(wm97xx_exit);
 
 /* Module information */
-MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_AUTHOR("Liam Girdwood <lrg@slimlogic.co.uk>");
 MODULE_DESCRIPTION("WM97xx Core - Touch Screen / AUX ADC / GPIO Driver");
 MODULE_LICENSE("GPL");
-- 
1.5.4.3


