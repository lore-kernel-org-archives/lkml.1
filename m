Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYJNXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYJNXTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYJNXSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:18:17 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:43034 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752599AbYJNXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:18:12 -0400
Message-Id: <20081014231811.178920438@fluff.org.uk>
References: <20081014231714.739345038@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Wed, 15 Oct 2008 00:17:19 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 5/5] s3cmci: Add Ben Dooks/Simtec Electronics to header & copyright
Content-Disposition: inline; filename=simtec/drivers-s3c24xx-mmc-add-us-to-copyright-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the original authour (Thomas Kleffel) has been too busy to
merge the s3cmci driver and keep it up to date, I (mostly as part
of my role with Simtec Electronics) got the driver to a mergable
state and have been maintaining it since I think that I should
be added to the header. Also add a copyright statement for the
new work. 

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc6-quilt3/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.27-rc6-quilt3.orig/drivers/mmc/host/s3cmci.c	2008-09-21 21:06:47.000000000 +0100
+++ linux-2.6.27-rc6-quilt3/drivers/mmc/host/s3cmci.c	2008-09-21 21:10:24.000000000 +0100
@@ -3,6 +3,9 @@
  *
  *  Copyright (C) 2004-2006 maintech GmbH, Thomas Kleffel <tk@maintech.de>
  *
+ * Current driver maintained by Ben Dooks and Simtec Electronics
+ *  Copyright (C) 2008 Simtec Electronics <ben-linux@fluff.org>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -1560,7 +1563,7 @@ module_exit(s3cmci_exit);
 
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>");
+MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>, Ben Dooks <ben-linux@fluff.org>");
 MODULE_ALIAS("platform:s3c2410-sdi");
 MODULE_ALIAS("platform:s3c2412-sdi");
 MODULE_ALIAS("platform:s3c2440-sdi");

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
