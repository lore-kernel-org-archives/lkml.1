Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYG3Jkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYG3Jkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYG3JkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:40:09 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:46032 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYG3JkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:40:07 -0400
Subject: [patch 23/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7QO-0007Hn-9C@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:48 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p22/include/linux/pci_ids.h	2008-07-30 13:37:18.873248000 +1000
+++ linux-p23/include/linux/pci_ids.h	2008-07-30 13:38:37.567198000 +1000
@@ -571,12 +571,12 @@
 #define PCI_DEVICE_ID_MATROX_MIL_2	0x051b
 #define PCI_DEVICE_ID_MATROX_MYS_AGP	0x051e
 #define PCI_DEVICE_ID_MATROX_MIL_2_AGP	0x051f
-#define PCI_DEVICE_ID_MATROX_MGA_IMP	0x0d10
-#define PCI_DEVICE_ID_MATROX_G100_MM	0x1000
-#define PCI_DEVICE_ID_MATROX_G100_AGP	0x1001
 #define PCI_DEVICE_ID_MATROX_G200_PCI	0x0520
 #define PCI_DEVICE_ID_MATROX_G200_AGP	0x0521
 #define	PCI_DEVICE_ID_MATROX_G400	0x0525
+#define PCI_DEVICE_ID_MATROX_MGA_IMP	0x0d10
+#define PCI_DEVICE_ID_MATROX_G100_MM	0x1000
+#define PCI_DEVICE_ID_MATROX_G100_AGP	0x1001
 #define PCI_DEVICE_ID_MATROX_G550	0x2527
 #define PCI_DEVICE_ID_MATROX_VIA	0x4536
 
