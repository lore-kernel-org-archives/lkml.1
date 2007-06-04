Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbXFDQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbXFDQoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXFDQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:44:08 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:41808 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618AbXFDQoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:44:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <466441B8.30502@amd.com>
Date: Mon, 04 Jun 2007 18:45:44 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, gregkh@suse.de, cornelia.huck@de.ibm.com
Subject: [patch] remove orphaned Email
X-OriginalArrivalTime: 04 Jun 2007 16:43:55.0241 (UTC)
 FILETIME=[8A4DDD90:01C7A6C7]
X-WSS-ID: 6A7A9EC41GC4040378-01-01
Content-Type: multipart/mixed;
 boundary=------------020803070507060605000205
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020803070507060605000205
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

Manuel Estrada Sainz passed away on May 9th 2004, his email account got 
deactivated. He was in charge of the firmware_class code, and still got 
CC'ed in recent discussions about it.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>

--------------020803070507060605000205
Content-Type: text/x-patch;
 name=remove_email_firmware_class.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=remove_email_firmware_class.diff

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index e9cc8bb..d19eb19 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -1,7 +1,7 @@
 
  request_firmware() hotplug interface:
  ------------------------------------
-	Copyright (C) 2003 Manuel Estrada Sainz <ranty@debian.org>
+	Copyright (C) 2003 Manuel Estrada Sainz (passed away on May 9th 2004 at a car accident) 
 
  Why:
  ---
diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
index 87feccd..3d4a877 100644
--- a/Documentation/firmware_class/firmware_sample_driver.c
+++ b/Documentation/firmware_class/firmware_sample_driver.c
@@ -1,7 +1,7 @@
 /*
  * firmware_sample_driver.c -
  *
- * Copyright (c) 2003 Manuel Estrada Sainz <ranty@debian.org>
+ * Copyright (c) 2003 Manuel Estrada Sainz (passed away on May 9th 2004 at a car accident)
  *
  * Sample code on how to use request_firmware() from drivers.
  *
diff --git a/Documentation/firmware_class/firmware_sample_firmware_class.c b/Documentation/firmware_class/firmware_sample_firmware_class.c
index 9e1b0e4..678b050 100644
--- a/Documentation/firmware_class/firmware_sample_firmware_class.c
+++ b/Documentation/firmware_class/firmware_sample_firmware_class.c
@@ -1,7 +1,7 @@
 /*
  * firmware_sample_firmware_class.c -
  *
- * Copyright (c) 2003 Manuel Estrada Sainz <ranty@debian.org>
+ * Copyright (c) 2003 Manuel Estrada Sainz (passed away on May 9th 2004 at a car accident)
  *
  * NOTE: This is just a probe of concept, if you think that your driver would
  * be well served by this mechanism please contact me first.
@@ -19,7 +19,7 @@
 #include <linux/firmware.h>
 
 
-MODULE_AUTHOR("Manuel Estrada Sainz <ranty@debian.org>");
+MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Hackish sample for using firmware class directly");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 97ab5bd..672c221 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1,7 +1,7 @@
 /*
  * firmware_class.c - Multi purpose firmware loading support
  *
- * Copyright (c) 2003 Manuel Estrada Sainz <ranty@debian.org>
+ * Copyright (c) 2003 Manuel Estrada Sainz (passed away on May 9th 2004 at a car accident)
  *
  * Please see Documentation/firmware_class/ for more information.
  *
@@ -23,7 +23,7 @@
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
-MODULE_AUTHOR("Manuel Estrada Sainz <ranty@debian.org>");
+MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 

--------------020803070507060605000205--


