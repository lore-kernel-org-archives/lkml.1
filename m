Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYG3JpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYG3JpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbYG3Joq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:44:46 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:40402 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761108AbYG3Jop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:44:45 -0400
Subject: [patch 15/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Pi-0007Fg-UH@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:06 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p14/include/linux/pci_ids.h	2008-07-30 13:19:49.088675000 +1000
+++ linux-p15/include/linux/pci_ids.h	2008-07-30 13:24:57.122353000 +1000
@@ -1155,10 +1155,6 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE	0x0265
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA	0x0266
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2	0x0267
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS	0x0368
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE	0x036E
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA	0x037E
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2	0x037F
 #define PCI_DEVICE_ID_NVIDIA_NVENET_12		0x0268
 #define PCI_DEVICE_ID_NVIDIA_NVENET_13		0x0269
 #define PCI_DEVICE_ID_NVIDIA_GEFORCE4_TI_4800	0x0280
@@ -1207,8 +1203,12 @@
 #define PCI_DEVICE_ID_NVIDIA_GEFORCE_FX_GO5700_2    0x0348
 #define PCI_DEVICE_ID_NVIDIA_QUADRO_FX_GO1000       0x034C
 #define PCI_DEVICE_ID_NVIDIA_QUADRO_FX_1100         0x034E
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS	0x0368
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE	0x036E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_14              0x0372
 #define PCI_DEVICE_ID_NVIDIA_NVENET_15              0x0373
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA	0x037E
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2	0x037F
 #define PCI_DEVICE_ID_NVIDIA_NVENET_16              0x03E5
 #define PCI_DEVICE_ID_NVIDIA_NVENET_17              0x03E6
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA      0x03E7
@@ -1228,10 +1228,6 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_25              0x054D
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
-#define PCI_DEVICE_ID_NVIDIA_NVENET_28              0x07DC
-#define PCI_DEVICE_ID_NVIDIA_NVENET_29              0x07DD
-#define PCI_DEVICE_ID_NVIDIA_NVENET_30              0x07DE
-#define PCI_DEVICE_ID_NVIDIA_NVENET_31              0x07DF
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
@@ -1239,6 +1235,10 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_33              0x0761
 #define PCI_DEVICE_ID_NVIDIA_NVENET_34              0x0762
 #define PCI_DEVICE_ID_NVIDIA_NVENET_35              0x0763
+#define PCI_DEVICE_ID_NVIDIA_NVENET_28              0x07DC
+#define PCI_DEVICE_ID_NVIDIA_NVENET_29              0x07DD
+#define PCI_DEVICE_ID_NVIDIA_NVENET_30              0x07DE
+#define PCI_DEVICE_ID_NVIDIA_NVENET_31              0x07DF
 #define PCI_DEVICE_ID_NVIDIA_NVENET_36              0x0AB0
 #define PCI_DEVICE_ID_NVIDIA_NVENET_37              0x0AB1
 #define PCI_DEVICE_ID_NVIDIA_NVENET_38              0x0AB2
