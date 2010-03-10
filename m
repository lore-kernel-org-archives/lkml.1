Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0CJRiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:38:17 -0500
Received: from ml.kn.E-Technik.Uni-Dortmund.DE ([129.217.186.234]:39488 "HELO
	ml.kn.e-technik.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932490Ab0CJRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:38:15 -0500
X-Greylist: delayed 2441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 12:38:15 EST
From: Thomas Klute <thomas2.klute@uni-dortmund.de>
To: gregkh@suse.de
Cc: sjakub@gmail.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Thomas Klute <thomas2.klute@uni-dortmund.de>
Subject: [PATCH] asus_oled: whitespace cleanup
Date: Wed, 10 Mar 2010 17:57:23 +0100
Message-Id: <1268240243-14519-1-git-send-email-thomas2.klute@uni-dortmund.de>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove space in indentation to make checkpatch.pl happy.

Signed-off-by: Thomas Klute <thomas2.klute@uni-dortmund.de>
---
 drivers/staging/asus_oled/TODO        |    1 -
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/asus_oled/TODO b/drivers/staging/asus_oled/TODO
index 2514131..1daf2a5 100644
--- a/drivers/staging/asus_oled/TODO
+++ b/drivers/staging/asus_oled/TODO
@@ -1,5 +1,4 @@
 TODO:
-	- checkpatch.pl cleanups
 	- sparse fixes
 	- audit the userspace interface
 		- sysfs vs. char?
diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..5b279fb 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -771,7 +771,7 @@ static struct usb_driver oled_driver = {
 };
 
 static CLASS_ATTR_STRING(version, S_IRUGO,
-		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
+			ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
-- 
1.6.4.4

