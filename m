Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYG3JLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYG3JLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYG3JLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:11:39 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43776 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYG3JLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:11:38 -0400
Subject: [patch 17/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Pt-0007G8-4G@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:17 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p16/include/linux/pci_ids.h	2008-07-30 13:29:38.648742000 +1000
+++ linux-p17/include/linux/pci_ids.h	2008-07-30 13:31:13.783880000 +1000
@@ -888,14 +888,14 @@
 #define PCI_DEVICE_ID_QLOGIC_ISP2300	0x2300
 #define PCI_DEVICE_ID_QLOGIC_ISP2312	0x2312
 #define PCI_DEVICE_ID_QLOGIC_ISP2322	0x2322
-#define PCI_DEVICE_ID_QLOGIC_ISP6312	0x6312
-#define PCI_DEVICE_ID_QLOGIC_ISP6322	0x6322
 #define PCI_DEVICE_ID_QLOGIC_ISP2422	0x2422
 #define PCI_DEVICE_ID_QLOGIC_ISP2432	0x2432
 #define PCI_DEVICE_ID_QLOGIC_ISP2512	0x2512
 #define PCI_DEVICE_ID_QLOGIC_ISP2522	0x2522
 #define PCI_DEVICE_ID_QLOGIC_ISP5422	0x5422
 #define PCI_DEVICE_ID_QLOGIC_ISP5432	0x5432
+#define PCI_DEVICE_ID_QLOGIC_ISP6312	0x6312
+#define PCI_DEVICE_ID_QLOGIC_ISP6322	0x6322
 
 #define PCI_VENDOR_ID_CYRIX		0x1078
 #define PCI_DEVICE_ID_CYRIX_5510	0x0000
