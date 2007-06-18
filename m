Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbXFRI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbXFRI4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbXFRI4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:56:11 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:37053 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755784AbXFRI4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:56:10 -0400
Message-id: <11171260732566729370@wsc.cz>
In-reply-to: <29285162611339719891@wsc.cz>
Subject: [PATCH 4/5] pci_ids, add atheros and 3com_2 vendors
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Date: Mon, 18 Jun 2007 10:56:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_ids, add atheros and 3com_2 vendors

Atheros is wifi vendor. 3com_2 (0xa727) is an vendor id for one card with
ath chip.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 9aec913bf7bedc252b466f9d8022abe5d9eae449
tree 9b1eb9cf33e1689f9ff5bab4b73bc9833f3a7098
parent 6e779d054a804b16394dacb669facc3b1da8aae8
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:39:03 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 18 Jun 2007 10:46:42 +0200

 include/linux/pci_ids.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 19a5977..012fd6e 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2060,6 +2060,8 @@
 #define PCI_DEVICE_ID_BCM1250_PCI	0x0001
 #define PCI_DEVICE_ID_BCM1250_HT	0x0002
 
+#define PCI_VENDOR_ID_ATHEROS		0x168c
+
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
@@ -2412,6 +2414,8 @@
 #define PCI_DEVICE_ID_NETMOS_9845	0x9845
 #define PCI_DEVICE_ID_NETMOS_9855	0x9855
 
+#define PCI_VENDOR_ID_3COM_2		0xa727
+
 #define PCI_SUBVENDOR_ID_EXSYS		0xd84d
 #define PCI_SUBDEVICE_ID_EXSYS_4014	0x4014
 #define PCI_SUBDEVICE_ID_EXSYS_4055	0x4055
