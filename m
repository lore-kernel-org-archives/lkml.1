Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbXJPLml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbXJPLml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXJPLm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:42:26 -0400
Received: from mx1.minet.net ([157.159.40.25]:56598 "EHLO mx1.minet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765643AbXJPLmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:42:24 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Tue, 16 Oct 2007 13:41:24 +0200
Subject: [PATCH 2/4] pci.h : Add PCI identifiers for the RDC devices
MIME-Version: 1.0
X-Length: 1520
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kNKFHp4OQPKMSkt"
Message-Id: <200710161341.24598.florian.fainelli@telecomint.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--Boundary-00=_kNKFHp4OQPKMSkt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch defines the PCI identifiers found in
the RDC R-321x System-on-Chip.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 include/linux/pci_ids.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

--Boundary-00=_kNKFHp4OQPKMSkt
Content-Type: text/plain;
  charset="utf-8";
  name="f39865158a37041d0e7a8d4e5666c6f753fd6477.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="f39865158a37041d0e7a8d4e5666c6f753fd6477.diff"

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
 

--Boundary-00=_kNKFHp4OQPKMSkt--



