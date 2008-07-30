Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbYG3Jz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbYG3Jz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYG3Jzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:55:45 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:41193 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbYG3Jzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:55:44 -0400
Subject: [patch 16/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Po-0007Fv-1I@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:12 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p15/include/linux/pci_ids.h	2008-07-30 13:24:57.122353000 +1000
+++ linux-p16/include/linux/pci_ids.h	2008-07-30 13:29:38.648742000 +1000
@@ -931,14 +931,13 @@
 #define PCI_DEVICE_ID_SUN_CASSINI	0xabba
 
 #define PCI_VENDOR_ID_CMD		0x1095
+#define PCI_DEVICE_ID_SII_1210SA	0x0240
 #define PCI_DEVICE_ID_CMD_643		0x0643
 #define PCI_DEVICE_ID_CMD_646		0x0646
 #define PCI_DEVICE_ID_CMD_648		0x0648
 #define PCI_DEVICE_ID_CMD_649		0x0649
-
 #define PCI_DEVICE_ID_SII_680		0x0680
 #define PCI_DEVICE_ID_SII_3112		0x3112
-#define PCI_DEVICE_ID_SII_1210SA	0x0240
 
 #define PCI_VENDOR_ID_BROOKTREE		0x109e
 #define PCI_DEVICE_ID_BROOKTREE_878	0x0878
