Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0CLK0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:26:15 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:59880 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab0CLK0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ftezo0qMwL8qmKutx5cWVCKIytXYo3rADg9Wa/gWaOKSzqjKyrCZhbSYsLOw1wfD76
         cpiS2x513hoYCY+66b2B+iF69qG8vUglikTDyOeAPbAEspx5jMndAl6UQoecGCdHjG/g
         6gnnQrPmDYTIcYWNJIsvNeoJmMKrskmf08Sq4=
From: revent82@gmail.com
To: gregkh@suse.de, andre@bitwigglers.org, peterhuewe@gmx.de,
       ak@linux.intel.com, eugeni@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       revent <revent@router.Premier>
Subject: [PATCH] Staging:asus_oled: Fixed problem of style tabs in asus_oled.c
Date: Fri, 12 Mar 2010 15:26:06 +0500
Message-Id: <1268389566-26737-1-git-send-email-revent82@gmail.com>
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

