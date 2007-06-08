Return-Path: <linux-kernel-owner+w=401wt.eu-S968158AbXFHUGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968158AbXFHUGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030699AbXFHUE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:04:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:38811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030633AbXFHUE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:04:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Markus Rechberger <markus.rechberger@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] firmware: remove orphaned Email
Date: Fri,  8 Jun 2007 13:04:43 -0700
Message-Id: <11813331032408-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <1181333098614-git-send-email-gregkh@suse.de>
References: <20070608200407.GA22825@kroah.com>
 <11813330832783-git-send-email-gregkh@suse.de>
 <11813330873231-git-send-email-gregkh@suse.de>
 <118133309258-git-send-email-gregkh@suse.de>
 <1181333098614-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Rechberger <markus.rechberger@amd.com>

Manuel Estrada Sainz passed away on May 9th 2004, his email account got
deactivated. He was in charge of the firmware_class code, and still got
CC'ed in recent discussions about it.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/firmware_class/README                |    2 +-
 .../firmware_class/firmware_sample_driver.c        |    2 +-
 .../firmware_sample_firmware_class.c               |    4 ++--
 drivers/base/firmware_class.c                      |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index e9cc8bb..c3480aa 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -1,7 +1,7 @@
 
  request_firmware() hotplug interface:
  ------------------------------------
-	Copyright (C) 2003 Manuel Estrada Sainz <ranty@debian.org>
+	Copyright (C) 2003 Manuel Estrada Sainz
 
  Why:
  ---
diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
index 87feccd..6865cbe 100644
--- a/Documentation/firmware_class/firmware_sample_driver.c
+++ b/Documentation/firmware_class/firmware_sample_driver.c
@@ -1,7 +1,7 @@
 /*
  * firmware_sample_driver.c -
  *
- * Copyright (c) 2003 Manuel Estrada Sainz <ranty@debian.org>
+ * Copyright (c) 2003 Manuel Estrada Sainz
  *
  * Sample code on how to use request_firmware() from drivers.
  *
diff --git a/Documentation/firmware_class/firmware_sample_firmware_class.c b/Documentation/firmware_class/firmware_sample_firmware_class.c
index 9e1b0e4..4994f1f 100644
--- a/Documentation/firmware_class/firmware_sample_firmware_class.c
+++ b/Documentation/firmware_class/firmware_sample_firmware_class.c
@@ -1,7 +1,7 @@
 /*
  * firmware_sample_firmware_class.c -
  *
- * Copyright (c) 2003 Manuel Estrada Sainz <ranty@debian.org>
+ * Copyright (c) 2003 Manuel Estrada Sainz
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
index 97ab5bd..89a5f4a 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1,7 +1,7 @@
 /*
  * firmware_class.c - Multi purpose firmware loading support
  *
- * Copyright (c) 2003 Manuel Estrada Sainz <ranty@debian.org>
+ * Copyright (c) 2003 Manuel Estrada Sainz
  *
  * Please see Documentation/firmware_class/ for more information.
  *
@@ -23,7 +23,7 @@
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
-MODULE_AUTHOR("Manuel Estrada Sainz <ranty@debian.org>");
+MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
-- 
1.5.2.1

