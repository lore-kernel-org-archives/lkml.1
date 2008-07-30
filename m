Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYG3JE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYG3JE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYG3JEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:04:35 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43092 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYG3JEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:04:34 -0400
Subject: [patch 14/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Pd-0007FT-R4@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:01 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p13/include/linux/pci_ids.h	2008-07-30 13:17:43.998171000 +1000
+++ linux-p14/include/linux/pci_ids.h	2008-07-30 13:19:49.088675000 +1000
@@ -1288,15 +1288,15 @@
 #define PCI_DEVICE_ID_VIA_8380_0	0x0204
 #define PCI_DEVICE_ID_VIA_3238_0	0x0238
 #define PCI_DEVICE_ID_VIA_PT880		0x0258
-#define PCI_DEVICE_ID_VIA_PT880ULTRA	0x0308
 #define PCI_DEVICE_ID_VIA_PX8X0_0	0x0259
 #define PCI_DEVICE_ID_VIA_3269_0	0x0269
 #define PCI_DEVICE_ID_VIA_K8T800PRO_0	0x0282
 #define PCI_DEVICE_ID_VIA_3296_0	0x0296
 #define PCI_DEVICE_ID_VIA_8363_0	0x0305
+#define PCI_DEVICE_ID_VIA_PT880ULTRA	0x0308
 #define PCI_DEVICE_ID_VIA_P4M800CE	0x0314
-#define PCI_DEVICE_ID_VIA_P4M890	0x0327
 #define PCI_DEVICE_ID_VIA_VT3324	0x0324
+#define PCI_DEVICE_ID_VIA_P4M890	0x0327
 #define PCI_DEVICE_ID_VIA_VT3336	0x0336
 #define PCI_DEVICE_ID_VIA_VT3351	0x0351
 #define PCI_DEVICE_ID_VIA_VT3364	0x0364
@@ -1305,6 +1305,7 @@
 #define PCI_DEVICE_ID_VIA_82C561	0x0561
 #define PCI_DEVICE_ID_VIA_82C586_1	0x0571
 #define PCI_DEVICE_ID_VIA_82C576	0x0576
+#define PCI_DEVICE_ID_VIA_CX700_IDE	0x0581
 #define PCI_DEVICE_ID_VIA_82C586_0	0x0586
 #define PCI_DEVICE_ID_VIA_82C596	0x0596
 #define PCI_DEVICE_ID_VIA_82C597_0	0x0597
@@ -1353,7 +1354,6 @@
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
 #define PCI_DEVICE_ID_VIA_8365_1	0x8305
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
-#define PCI_DEVICE_ID_VIA_CX700_IDE	0x0581
 #define PCI_DEVICE_ID_VIA_VX800		0x8353
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
