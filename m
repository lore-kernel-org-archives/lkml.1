Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbYG3Jxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbYG3Jxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYG3JxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:53:23 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:41038 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYG3JxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:53:22 -0400
Subject: [patch 24/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7QT-0007Hz-CJ@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:53 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p23/include/linux/pci_ids.h	2008-07-30 13:38:37.567198000 +1000
+++ linux-p24/include/linux/pci_ids.h	2008-07-30 13:39:33.074864000 +1000
@@ -540,21 +540,21 @@
 #define PCI_VENDOR_ID_TRIDENT		0x1023
 #define PCI_DEVICE_ID_TRIDENT_4DWAVE_DX	0x2000
 #define PCI_DEVICE_ID_TRIDENT_4DWAVE_NX	0x2001
+#define PCI_DEVICE_ID_TRIDENT_8400	0x8400
+#define PCI_DEVICE_ID_TRIDENT_8420	0x8420
+#define PCI_DEVICE_ID_TRIDENT_8500	0x8500
 #define PCI_DEVICE_ID_TRIDENT_9320	0x9320
 #define PCI_DEVICE_ID_TRIDENT_9388	0x9388
 #define PCI_DEVICE_ID_TRIDENT_9397	0x9397
 #define PCI_DEVICE_ID_TRIDENT_939A	0x939A
-#define PCI_DEVICE_ID_TRIDENT_9520	0x9520
-#define PCI_DEVICE_ID_TRIDENT_9525	0x9525
 #define PCI_DEVICE_ID_TRIDENT_9420	0x9420
 #define PCI_DEVICE_ID_TRIDENT_9440	0x9440
+#define PCI_DEVICE_ID_TRIDENT_9520	0x9520
+#define PCI_DEVICE_ID_TRIDENT_9525	0x9525
 #define PCI_DEVICE_ID_TRIDENT_9660	0x9660
 #define PCI_DEVICE_ID_TRIDENT_9750	0x9750
 #define PCI_DEVICE_ID_TRIDENT_9850	0x9850
 #define PCI_DEVICE_ID_TRIDENT_9880	0x9880
-#define PCI_DEVICE_ID_TRIDENT_8400	0x8400
-#define PCI_DEVICE_ID_TRIDENT_8420	0x8420
-#define PCI_DEVICE_ID_TRIDENT_8500	0x8500
 
 #define PCI_VENDOR_ID_AI		0x1025
 #define PCI_DEVICE_ID_AI_M1435		0x1435
