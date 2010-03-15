Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935178Ab0COBQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:16:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60350 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935062Ab0COBQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jD/yunvKcQiB0fWB41vwkE4ygbCN7s5PK4vxEd4CKgX7NWTHZTDuYOeRJZGBFIOnGe
         KVff0f7KgHOWOJs8osG3RbrMhP7nP3jZzNVxne0ljgdTZ/0l/HpI7i367j2W7CJ/UI/6
         +YlS86I4+625CH/1jhGs3+BQiyLeLuN4Ot71g=
From: willismonroe@gmail.com
To: gregkh@suse.de, andre@bitwigglers.org, ak@linux.intel.com,
       peterhuewe@gmx.de, willismonroe@gmail.com
Cc: devel@driverdev.osuosol.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: asus_oled: changes spaces to tabs in asus_oled.c Ran checkpatch.pl as per TODO mentioned that one line had spaces, fixed it. Signed-off-by: M. Willis Monroe <willismonroe@gmail.com>
Date: Sun, 14 Mar 2010 21:16:27 -0400
Message-Id: <1268615787-11104-1-git-send-email-willismonroe@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: M. Willis Monroe <willis@willis-desktop.(none)>

---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.6.3.3

