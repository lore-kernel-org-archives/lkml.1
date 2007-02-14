Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbXBOCPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbXBOCPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964851AbXBOCPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:15:18 -0500
Received: from mail0.lsil.com ([147.145.40.20]:48921 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844AbXBOCPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:15:16 -0500
Subject: [PATCH 6/6] scsi: megaraid_sas - update version and author info
From: Sumant Patro <sumantp@lsil.com>
To: James.Bottomley@SteelEye.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com
Content-Type: text/plain
Date: Wed, 14 Feb 2007 13:05:42 -0800
Message-Id: <1171487142.4188.37.camel@dumbo>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-22) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Update version and author information.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |    8 +++++---
 drivers/scsi/megaraid/megaraid_sas.h |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -uprN linux-feb13-new-p5/drivers/scsi/megaraid/megaraid_sas.c linux-feb13-new-p6/drivers/scsi/megaraid/megaraid_sas.c
--- linux-feb13-new-p5/drivers/scsi/megaraid/megaraid_sas.c	2007-02-14 05:19:30.000000000 -0800
+++ linux-feb13-new-p6/drivers/scsi/megaraid/megaraid_sas.c	2007-02-14 05:19:44.000000000 -0800
@@ -10,11 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.05
+ * Version	: v00.00.03.10-rc1
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
diff -uprN linux-feb13-new-p5/drivers/scsi/megaraid/megaraid_sas.h linux-feb13-new-p6/drivers/scsi/megaraid/megaraid_sas.h
--- linux-feb13-new-p5/drivers/scsi/megaraid/megaraid_sas.h	2007-02-14 04:36:46.000000000 -0800
+++ linux-feb13-new-p6/drivers/scsi/megaraid/megaraid_sas.h	2007-02-14 05:04:45.000000000 -0800
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.05"
-#define MEGASAS_RELDATE				"Oct 02, 2006"
-#define MEGASAS_EXT_VERSION			"Mon Oct 02 11:21:32 PDT 2006"
+#define MEGASAS_VERSION				"00.00.03.10-rc1"
+#define MEGASAS_RELDATE				"Feb 14, 2007"
+#define MEGASAS_EXT_VERSION			"Wed Feb 14 10:14:25 PST 2007"
 
 /*
  * Device IDs


