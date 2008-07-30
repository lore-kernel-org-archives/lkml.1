Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbYG3Jqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbYG3Jqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYG3Jqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:46:35 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:46461 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYG3Jqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:46:34 -0400
Subject: [patch 12/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7PT-0007EW-L3@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:51 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p11/include/linux/pci_ids.h	2008-07-30 13:15:27.708539000 +1000
+++ linux-p12/include/linux/pci_ids.h	2008-07-30 13:17:01.964668000 +1000
@@ -1517,11 +1517,11 @@
 #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334
 
 #define PCI_VENDOR_ID_MARVELL		0x11ab
+#define PCI_DEVICE_ID_MARVELL_CAFE_SD	0x4101
 #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
-#define PCI_DEVICE_ID_MARVELL_CAFE_SD	0x4101
 
 #define PCI_VENDOR_ID_V3		0x11b0
 #define PCI_DEVICE_ID_V3_V960		0x0001
