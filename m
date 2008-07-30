Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbYG3JOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbYG3JOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYG3JNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:13:55 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:38140 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYG3JNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:13:54 -0400
Subject: [patch 10/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7PJ-0007E7-ET@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:41 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p9/include/linux/pci_ids.h	2008-07-30 13:12:24.429345000 +1000
+++ linux-p10/include/linux/pci_ids.h	2008-07-30 13:14:38.402939000 +1000
@@ -1643,10 +1643,10 @@
 #define PCI_VENDOR_ID_ROCKWELL		0x127A
 
 #define PCI_VENDOR_ID_ITE		0x1283
+#define PCI_DEVICE_ID_ITE_8152		0x8152
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
 #define PCI_DEVICE_ID_ITE_8213		0x8213
-#define PCI_DEVICE_ID_ITE_8152		0x8152
 #define PCI_DEVICE_ID_ITE_8872		0x8872
 #define PCI_DEVICE_ID_ITE_IT8330G_0	0xe886
 
