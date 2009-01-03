Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZACHzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZACHzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:55:13 -0500
Received: from vps1.tull.net ([66.180.172.116]:37924 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:55:12 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 05/11] Fix misspelling of "firmware" in ql4_mbx.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:54:39 +1100
Message-ID: <20090103075428.27466.61851.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in ql4_mbx.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c577d79..051b0f5 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -392,7 +392,7 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 		ha->iocb_hiwat -= IOCB_HIWAT_CUSHION;
 	else
 		dev_info(&ha->pdev->dev, "WARNING!!!  You have less than %d "
-			   "firmare IOCBs available (%d).\n",
+			   "firmware IOCBs available (%d).\n",
 			   IOCB_HIWAT_CUSHION, ha->iocb_hiwat);
 
 	return QLA_SUCCESS;

