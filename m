Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbYG3K3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbYG3K3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYG3K3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:29:01 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:44049 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYG3K3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:29:00 -0400
Subject: [patch 13/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7PY-0007FH-O5@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:56 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p12/include/linux/pci_ids.h	2008-07-30 13:17:01.964668000 +1000
+++ linux-p13/include/linux/pci_ids.h	2008-07-30 13:17:43.998171000 +1000
@@ -1456,9 +1456,9 @@
 #define PCI_DEVICE_ID_SERVERWORKS_CSB6LPC 0x0227
 
 #define PCI_VENDOR_ID_SBE		0x1176
+#define PCI_DEVICE_ID_SBE_WANXL400	0x0104
 #define PCI_DEVICE_ID_SBE_WANXL100	0x0301
 #define PCI_DEVICE_ID_SBE_WANXL200	0x0302
-#define PCI_DEVICE_ID_SBE_WANXL400	0x0104
 
 #define PCI_VENDOR_ID_TOSHIBA		0x1179
 #define PCI_DEVICE_ID_TOSHIBA_PICCOLO	0x0102
