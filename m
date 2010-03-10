Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0CJINU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:13:20 -0500
Received: from mail6.msi.com ([210.59.147.74]:32822 "EHLO mail6.msi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab0CJINR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:13:17 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 03:13:16 EST
From: <linchan.hsiao@gmail.com>
To: <gregkh@suse.de>, <peterhuewe@gmx.de>, <jgarzik@redhat.com>,
       <linchan.hsiao@gmail.com>, <alan@linux.intel.com>
Cc: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: phison: fix space before TAB coding style issue in phison.c This is a patch to the phison.c file that fixes up a space before TAB warning found by the checkpatch.pl tool Signed-off-by: Lin Chan Hsiao <linchan.hsiao@gmail.com>
Date: Wed, 10 Mar 2010 16:06:24 +0800
Message-ID: <1268208384-2339-1-git-send-email-linchan.hsiao@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2A8DUmE010122

From: matt <matt@matt-ubuntu.(none)>

---
 drivers/staging/phison/phison.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 0c495ea..42783d7 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -23,7 +23,7 @@
 #define PHISON_DEBUG
 
 #define DRV_NAME		"phison_e-box"	/* #0003 */
-#define DRV_VERSION 		"0.91"		/* #0003 */
+#define DRV_VERSION		"0.91"		/* #0003 */
 
 #define PCI_VENDOR_ID_PHISON	0x1987
 #define PCI_DEVICE_ID_PS5000	0x5000
@@ -56,7 +56,7 @@ static int phison_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= ATA_UDMA5,
+		.udma_mask	= ATA_UDMA5,
 
 		.port_ops	= &phison_ops,
 	};
-- 
1.6.3.3


*****CONFIDENTIAL INFORMATION*****

This email is intended only for the use of the person or entity to whom it is
addressed and contains information that may be subject to and/or may be
restricted from disclosure by contract or applicable law. If you are not the 
intended recipient of this email, be advised that any disclosure, copy, 
distribution or use of the contents of this message is strictly prohibited. 
If you are not the intended recipient of this email, please notify the sender 
that you have received this in error by replying to this message. Then, 
please delete it from your system. Thank you.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
