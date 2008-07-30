Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYG3JFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYG3JFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYG3JEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:04:54 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43123 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405AbYG3JEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:04:53 -0400
Subject: [patch 22/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7QJ-0007Ha-6N@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:43 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p21/include/linux/pci_ids.h	2008-07-30 13:35:33.641989000 +1000
+++ linux-p22/include/linux/pci_ids.h	2008-07-30 13:37:18.873248000 +1000
@@ -628,17 +628,15 @@
 #define PCI_DEVICE_ID_SI_LPC		0x0018
 #define PCI_DEVICE_ID_SI_5597_VGA	0x0200
 #define PCI_DEVICE_ID_SI_6205		0x0205
-#define PCI_DEVICE_ID_SI_501		0x0406
-#define PCI_DEVICE_ID_SI_496		0x0496
 #define PCI_DEVICE_ID_SI_300		0x0300
 #define PCI_DEVICE_ID_SI_315H		0x0310
 #define PCI_DEVICE_ID_SI_315		0x0315
 #define PCI_DEVICE_ID_SI_315PRO		0x0325
+#define PCI_DEVICE_ID_SI_501		0x0406
+#define PCI_DEVICE_ID_SI_496		0x0496
 #define PCI_DEVICE_ID_SI_530		0x0530
 #define PCI_DEVICE_ID_SI_540		0x0540
 #define PCI_DEVICE_ID_SI_550		0x0550
-#define PCI_DEVICE_ID_SI_540_VGA	0x5300
-#define PCI_DEVICE_ID_SI_550_VGA	0x5315
 #define PCI_DEVICE_ID_SI_620		0x0620
 #define PCI_DEVICE_ID_SI_630		0x0630
 #define PCI_DEVICE_ID_SI_633		0x0633
@@ -653,7 +651,6 @@
 #define PCI_DEVICE_ID_SI_661		0x0661
 #define PCI_DEVICE_ID_SI_730		0x0730
 #define PCI_DEVICE_ID_SI_733		0x0733
-#define PCI_DEVICE_ID_SI_630_VGA	0x6300
 #define PCI_DEVICE_ID_SI_735		0x0735
 #define PCI_DEVICE_ID_SI_740		0x0740
 #define PCI_DEVICE_ID_SI_741		0x0741
@@ -669,6 +666,8 @@
 #define PCI_DEVICE_ID_SI_966		0x0966
 #define PCI_DEVICE_ID_SI_968		0x0968
 #define PCI_DEVICE_ID_SI_1180		0x1180
+#define PCI_DEVICE_ID_SI_540_VGA	0x5300
+#define PCI_DEVICE_ID_SI_550_VGA	0x5315
 #define PCI_DEVICE_ID_SI_5511		0x5511
 #define PCI_DEVICE_ID_SI_5513		0x5513
 #define PCI_DEVICE_ID_SI_5517		0x5517
@@ -681,6 +680,7 @@
 #define PCI_DEVICE_ID_SI_5597		0x5597
 #define PCI_DEVICE_ID_SI_5598		0x5598
 #define PCI_DEVICE_ID_SI_5600		0x5600
+#define PCI_DEVICE_ID_SI_630_VGA	0x6300
 #define PCI_DEVICE_ID_SI_7012		0x7012
 #define PCI_DEVICE_ID_SI_7013		0x7013
 #define PCI_DEVICE_ID_SI_7016		0x7016
