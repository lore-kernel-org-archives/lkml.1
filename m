Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbXFPPsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbXFPPsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXFPPsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:48:15 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:39439 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752809AbXFPPsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:48:14 -0400
Message-id: <18562570158061376@wsc.cz>
In-reply-to: <116342983010020429@wsc.cz>
Subject: [PATCH 6/6] pci_ids, add atheros and 3com_2 vendors
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 16 Jun 2007 17:48:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_ids, add atheros and 3com_2 vendors

Atheros is wifi vendor. 3com_2 (0xa727) is an vendor id for one card with
ath chip.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 10800193cc6cfc3761914fd7e6813094f39199bb
tree 898657022e66f154a84224d5f09109f242ffc0ad
parent ed29fc665adc4f8ef224318cb0877394f9b75ea4
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:39:03 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:39:03 +0200

 include/linux/pci_ids.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 279f2c0..1f228f8 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2018,6 +2018,8 @@
 #define PCI_DEVICE_ID_BCM1250_PCI	0x0001
 #define PCI_DEVICE_ID_BCM1250_HT	0x0002
 
+#define PCI_VENDOR_ID_ATHEROS		0x168c
+
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
@@ -2364,6 +2366,8 @@
 #define PCI_DEVICE_ID_NETMOS_9845	0x9845
 #define PCI_DEVICE_ID_NETMOS_9855	0x9855
 
+#define PCI_VENDOR_ID_3COM_2		0xa727
+
 #define PCI_SUBVENDOR_ID_EXSYS		0xd84d
 #define PCI_SUBDEVICE_ID_EXSYS_4014	0x4014
 #define PCI_SUBDEVICE_ID_EXSYS_4055	0x4055
