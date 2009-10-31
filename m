Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbZJaJmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbZJaJmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbZJaJmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:42:21 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:35835 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbZJaJmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=GFVnJ9fxIfkPjKxHZvI6egB6sNiY1SFrCfqEwhNUwtbgUXHS3rHzQyEqBfVBPgui1m
         YQmsUo80QYqiq+Tv5awpTUiY122g2YX061f7ixMqA3718p+bVNqqSW0zWBG5JbjYIB7c
         gtYkQrZgg4oEHiffUzd05wgW1wjTWzZ1VauTI=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:55 -0200
Message-ID: <b8bf37780910310241n3db9e1belf1bdcddd769f0fee@mail.gmail.com>
Subject: [PATCH 14/16] trivial: fix assorted "example" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2bcbf68c2be77bf807d4d70350386f99f63fdba2 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 07:12:07 -0200
Subject: [PATCH 14/16] trivial: fix assorted "example" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 3671815..e845b75 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -432,7 +432,7 @@ static int adm1029_remove(struct i2c_client *client)
 }

 /*
-function that update the status of the chips (temperature for exemple)
+function that update the status of the chips (temperature for example)
 */
 static struct adm1029_data *adm1029_update_device(struct device *dev)
 {
diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index 1a83709..492e6e6 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -701,7 +701,7 @@ static int gbefb_set_par(struct fb_info *info)
 	   blocks of 512x128, 256x128 or 128x128 pixels, respectively for 8bit,
 	   16bit and 32 bit modes (64 kB). They cover the screen with partial
 	   tiles on the right and/or bottom of the screen if needed.
-	   For exemple in 640x480 8 bit mode the mapping is:
+	   For example in 640x480 8 bit mode the mapping is:

 	   <-------- 640 ----->
 	   <---- 512 ----><128|384 offscreen>
diff --git a/include/linux/chio.h b/include/linux/chio.h
index 519248d..d9bac7f 100644
--- a/include/linux/chio.h
+++ b/include/linux/chio.h
@@ -21,7 +21,7 @@
  *    query vendor-specific element types
  *
  *    accessing elements works by specifing type and unit of the element.
- *    for eample, storage elements are addressed with type = CHET_ST and
+ *    for example, storage elements are addressed with type = CHET_ST and
  *    unit = 0 .. cp_nslots-1
  *
  */
-- 
1.6.5.2.101.gcd0f8
