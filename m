Return-Path: <linux-kernel-owner+w=401wt.eu-S1764143AbXJRODJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764143AbXJRODJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765878AbXJROC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:02:26 -0400
Received: from smtp1.int-evry.fr ([157.159.10.44]:45386 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765985AbXJROCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:02:24 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 resend] pci.h : Add PCI identifiers for the RDC devices
Date: Thu, 18 Oct 2007 15:57:55 +0200
User-Agent: KMail/1.9.7
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <200710181551.28720.florian.fainelli@telecomint.eu>
In-Reply-To: <200710181551.28720.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710181557.56041.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to remove the attachment on this one, sorry.

This patch defines the PCI identifiers found in
the RDC R-321x System-on-Chip.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 include/linux/pci_ids.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
---
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2aaf1c1..c5a0f5b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2097,6 +2097,13 @@
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
+#define PCI_VENDOR_ID_RDC		0x17f3
+#define PCI_DEVICE_ID_RDC_R6020		0x6020
+#define PCI_DEVICE_ID_RDC_R6030		0x6030
+#define PCI_DEVICE_ID_RDC_R6040		0x6040
+#define PCI_DEVICE_ID_RDC_R6060		0x6060
+#define PCI_DEVICE_ID_RDC_R6061		0x6061
+
 #define PCI_VENDOR_ID_SITECOM		0x182d
 #define PCI_DEVICE_ID_SITECOM_DC105V2	0x3069
