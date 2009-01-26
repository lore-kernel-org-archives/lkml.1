Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZAZCGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZAZCGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZAZCGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:06:22 -0500
Received: from vps1.tull.net ([66.180.172.116]:36453 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751162AbZAZCGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:06:21 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 13/20] Fix misspelling of firmware in libata.h
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:06:14 +1100
Message-ID: <20090126020613.15168.99029.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in libata.h

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 include/linux/libata.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2c6bd66..76bc61f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -377,7 +377,7 @@ enum {
 	ATA_HORKAGE_BRIDGE_OK	= (1 << 10),	/* no bridge limits */
 	ATA_HORKAGE_ATAPI_MOD16_DMA = (1 << 11), /* use ATAPI DMA for commands
 						    not multiple of 16 bytes */
-	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firwmare update warning */
+	ATA_HORKAGE_FIRMWARE_WARN = (1 << 12),	/* firmware update warning */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */

