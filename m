Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab0CLKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:32:17 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52887 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab0CLKcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SQ/LGiAFtjm31LAH9dBm5gSTjiHP/BiFpfU+47PvF+w8i0yqX7NgKb+S0ODqDeTEx0
         9fTuN7B17DCH1Gldg7cuovDzpMKzEzkRpXyIu1wcTh0gHYLUdbCWkCVZqNJbcqeBiaeg
         zYszesURx1BJ/It1azIkp8L3IbXY7UeRXp9PU=
From: revent82@gmail.com
To: gregkh@suse.de, andre@bitwigglers.org, peterhuewe@gmx.de,
       ak@linux.intel.com, eugeni@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       revent <revent@router.Premier>
Subject: [PATCH] Staging:asus_oled: Fixed problem of style tabs in asus_oled.c
Date: Fri, 12 Mar 2010 15:32:11 +0500
Message-Id: <1268389931-26872-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: revent <revent@router.Premier>

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
1.5.6.5

