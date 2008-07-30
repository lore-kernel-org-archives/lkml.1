Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbYG3J4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbYG3J4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbYG3Jzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:55:47 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:41198 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506AbYG3Jzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:55:46 -0400
Subject: [patch 28/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Qn-0007JN-P7@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:53:13 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p27/include/linux/pci_ids.h	2008-07-30 13:46:23.228774000 +1000
+++ linux-p28/include/linux/pci_ids.h	2008-07-30 13:47:46.384774000 +1000
@@ -398,6 +398,7 @@
 #define PCI_DEVICE_ID_NS_87560_USB	0x0012
 #define PCI_DEVICE_ID_NS_83815		0x0020
 #define PCI_DEVICE_ID_NS_83820		0x0022
+#define PCI_DEVICE_ID_NS_GX_HOST_BRIDGE  0x0028
 #define PCI_DEVICE_ID_NS_CS5535_ISA	0x002b
 #define PCI_DEVICE_ID_NS_CS5535_IDE	0x002d
 #define PCI_DEVICE_ID_NS_CS5535_AUDIO	0x002e
@@ -415,8 +416,6 @@
 #define PCI_DEVICE_ID_NS_SC1100_XBUS	0x0515
 #define PCI_DEVICE_ID_NS_87410		0xd001
 
-#define PCI_DEVICE_ID_NS_GX_HOST_BRIDGE  0x0028
-
 #define PCI_VENDOR_ID_TSENG		0x100c
 #define PCI_DEVICE_ID_TSENG_W32P_2	0x3202
 #define PCI_DEVICE_ID_TSENG_W32P_b	0x3205
