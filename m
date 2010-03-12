Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab0CLKD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:03:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:63887 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab0CLKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RoTHL7IKnLpoFI9brN99j3HuvMHo+EVICXRw+RfdWR2f8rc7vSVXSRbEVq4B/U91E9
         aGVqLqEYFih4GcuzC5RxWOxNuLZzeloevUuuD0ERP44zJKdeX1IoBCjiNhDup9OwmtwQ
         IpFenrxyLvZf4hRMxRd5j1H58hvjliNbA9KlA=
From: revent82@gmail.com
To: gregkh@suse.de, andre@bitwigglers.org, peterhuewe@gmx.de,
       ak@linux.intel.com, eugeni@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       revent <revent@router.Premier>
Subject: [PATCH] Staging:asus_oled: Fixed problem of style tabs in asus_oled.c
Date: Fri, 12 Mar 2010 15:03:21 +0500
Message-Id: <1268388201-26333-1-git-send-email-revent82@gmail.com>
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

