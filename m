Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbYDNOVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbYDNOVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbYDNOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:18:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33548 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760871AbYDNOSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:18:31 -0400
Date: Mon, 14 Apr 2008 17:17:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sun3_scsi_vme.c: add MODULE_LICENSE
Message-ID: <20080414141726.GJ6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
899d0052f8e3fbe4aa465ef98c10408307ee46a5 diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 02d9727..aaa4fd0 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -582,3 +582,4 @@ static struct scsi_host_template driver_template = {
 
 #include "scsi_module.c"
 
+MODULE_LICENSE("GPL");

