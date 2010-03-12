Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab0CLTNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:13:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:17016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934505Ab0CLTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VHV4CRqa9kHlDwlgcC4+kl/sOwLauq9BdvXyz0eFyxq/XnFtZFkEZ6yCEFCdeObomb
         +4tGccLjbh0g42YZ5RWbR4C950B1I4CU/+W79NiyfSJ4T54msBrFW2JCzJvqLqYY04g1
         HezcgJsESo/rQX4+4XNnbGmpKtE8RUQ11f4VQ=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, andre@bitwigglers.org, ak@linux.intel.com,
       peterhuewe@gmx.de, kevin.granade@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH] Staging:asus_oled: fix tabs coding style issue in asus_oled.c This is a patch to the asus_oled.c file that fixes up a tabs warning found by the checkpatch.pl tool
Date: Sat, 13 Mar 2010 00:12:57 +0500
Message-Id: <1268421177-20527-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
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
1.7.0.2

