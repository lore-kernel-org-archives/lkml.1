Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbYG3Jpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbYG3Jpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYG3Jpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:45:35 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:40479 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYG3Jpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:45:34 -0400
Subject: [patch 05/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Ot-0007D5-Vr@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:15 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p4/include/linux/pci_ids.h	2008-07-30 13:04:29.063645000 +1000
+++ linux-p5/include/linux/pci_ids.h	2008-07-30 13:07:50.568053000 +1000
@@ -2075,10 +2075,10 @@
 #define PCI_VENDOR_ID_MELLANOX		0x15b3
 #define PCI_DEVICE_ID_MELLANOX_TAVOR	0x5a44
 #define PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE	0x5a46
-#define PCI_DEVICE_ID_MELLANOX_ARBEL_COMPAT 0x6278
-#define PCI_DEVICE_ID_MELLANOX_ARBEL	0x6282
 #define PCI_DEVICE_ID_MELLANOX_SINAI_OLD 0x5e8c
 #define PCI_DEVICE_ID_MELLANOX_SINAI	0x6274
+#define PCI_DEVICE_ID_MELLANOX_ARBEL_COMPAT 0x6278
+#define PCI_DEVICE_ID_MELLANOX_ARBEL	0x6282
 
 #define PCI_VENDOR_ID_QUICKNET		0x15e2
 #define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
