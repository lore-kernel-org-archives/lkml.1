Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbYG3JEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbYG3JEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYG3JEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:04:33 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43089 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYG3JEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:04:32 -0400
Subject: [patch 26/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Qd-0007Iy-IZ@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:53:03 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p25/include/linux/pci_ids.h	2008-07-30 13:42:14.072787000 +1000
+++ linux-p26/include/linux/pci_ids.h	2008-07-30 13:44:49.874660000 +1000
@@ -465,18 +465,18 @@
 
 #define PCI_VENDOR_ID_IBM		0x1014
 #define PCI_DEVICE_ID_IBM_TR		0x0018
+#define PCI_DEVICE_ID_IBM_ICOM_DEV_ID_1	0x0031
 #define PCI_DEVICE_ID_IBM_TR_WAKE	0x003e
 #define PCI_DEVICE_ID_IBM_CPC710_PCI64	0x00fc
 #define PCI_DEVICE_ID_IBM_SNIPE		0x0180
-#define PCI_DEVICE_ID_IBM_CITRINE		0x028C
-#define PCI_DEVICE_ID_IBM_GEMSTONE		0xB166
-#define PCI_DEVICE_ID_IBM_OBSIDIAN		0x02BD
-#define PCI_DEVICE_ID_IBM_ICOM_DEV_ID_1	0x0031
 #define PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2	0x0219
 #define PCI_DEVICE_ID_IBM_ICOM_V2_TWO_PORTS_RVX		0x021A
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
+#define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x0252
+#define PCI_DEVICE_ID_IBM_CITRINE		0x028C
+#define PCI_DEVICE_ID_IBM_OBSIDIAN		0x02BD
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
-#define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_DEVICE_ID_IBM_GEMSTONE		0xB166
 
 #define PCI_VENDOR_ID_UNISYS		0x1018
 #define PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR 0x001C
