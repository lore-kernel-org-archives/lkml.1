Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXBGDfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXBGDfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 22:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXBGDfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 22:35:25 -0500
Received: from mail0.lsil.com ([147.145.40.20]:34625 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXBGDfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 22:35:24 -0500
Subject: [PATCH 5/5] scsi: megaraid_sas - update version and author info
From: Sumant Patro <sumantp@lsil.com>
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com,
       sumant.patro@lsi.com
Content-Type: multipart/mixed; boundary="=-ie6699aZ9uIRkAuoL5XU"
Date: Tue, 06 Feb 2007 14:24:59 -0800
Message-Id: <1170800699.10482.46.camel@dumbo>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-22) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ie6699aZ9uIRkAuoL5XU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Update version and author information.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |    8 +++++---
 drivers/scsi/megaraid/megaraid_sas.h |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:12:42.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:20:10.000000000 -0800
@@ -10,11 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.05
+ * Version	: v00.00.03.09-rc1
  *
  * Authors:
- * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsi.com>
- * 	Sumant Patro		<Sumant.Patro@lsi.com>
+ *	(email-id : megaraidlinux@lsi.com)
+ * 	Sreenivas Bagalkote
+ * 	Sumant Patro
+ *	Bo Yang
  *
  * List of supported controllers
  *
diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 10:14:17.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 13:03:55.000000000 -0800
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.05"
-#define MEGASAS_RELDATE				"Oct 02, 2006"
-#define MEGASAS_EXT_VERSION			"Mon Oct 02 11:21:32 PDT 2006"
+#define MEGASAS_VERSION				"00.00.03.09-rc1"
+#define MEGASAS_RELDATE				"Feb 06, 2007"
+#define MEGASAS_EXT_VERSION			"Tue Feb 06 12:35:46 PST 2007"
 
 /*
  * Device IDs


--=-ie6699aZ9uIRkAuoL5XU
Content-Disposition: attachment; filename=p5-update-vers.patch
Content-Type: text/x-patch; name=p5-update-vers.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:12:42.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:20:10.000000000 -0800
@@ -10,11 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.05
+ * Version	: v00.00.03.09-rc1
  *
  * Authors:
- * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsi.com>
- * 	Sumant Patro		<Sumant.Patro@lsi.com>
+ *	(email-id : megaraidlinux@lsi.com)
+ * 	Sreenivas Bagalkote
+ * 	Sumant Patro
+ *	Bo Yang
  *
  * List of supported controllers
  *
diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 10:14:17.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 13:03:55.000000000 -0800
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.05"
-#define MEGASAS_RELDATE				"Oct 02, 2006"
-#define MEGASAS_EXT_VERSION			"Mon Oct 02 11:21:32 PDT 2006"
+#define MEGASAS_VERSION				"00.00.03.09-rc1"
+#define MEGASAS_RELDATE				"Feb 06, 2007"
+#define MEGASAS_EXT_VERSION			"Tue Feb 06 12:35:46 PST 2007"
 
 /*
  * Device IDs

--=-ie6699aZ9uIRkAuoL5XU--

