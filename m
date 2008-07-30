Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbYG3J7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbYG3J7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYG3J7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:59:11 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:41486 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbYG3J7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:59:10 -0400
Subject: [patch 30/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Qx-0007Jp-VW@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:53:23 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p29/include/linux/pci_ids.h	2008-07-30 13:53:10.256659000 +1000
+++ linux-p30/include/linux/pci_ids.h	2008-07-30 13:55:13.560136000 +1000
@@ -146,19 +146,19 @@
 #define PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO	0xffa8
 
 #define PCI_VENDOR_ID_COMPAQ		0x0e11
+#define PCI_DEVICE_ID_COMPAQ_CISSC	0x0046
 #define PCI_DEVICE_ID_COMPAQ_TOKENRING	0x0508
 #define PCI_DEVICE_ID_COMPAQ_TACHYON	0xa0fc
 #define PCI_DEVICE_ID_COMPAQ_SMART2P	0xae10
 #define PCI_DEVICE_ID_COMPAQ_NETEL100	0xae32
-#define PCI_DEVICE_ID_COMPAQ_NETEL10	0xae34
 #define PCI_DEVICE_ID_COMPAQ_TRIFLEX_IDE 0xae33
+#define PCI_DEVICE_ID_COMPAQ_NETEL10	0xae34
 #define PCI_DEVICE_ID_COMPAQ_NETFLEX3I	0xae35
 #define PCI_DEVICE_ID_COMPAQ_NETEL100D	0xae40
 #define PCI_DEVICE_ID_COMPAQ_NETEL100PI	0xae43
 #define PCI_DEVICE_ID_COMPAQ_NETEL100I	0xb011
 #define PCI_DEVICE_ID_COMPAQ_CISS	0xb060
 #define PCI_DEVICE_ID_COMPAQ_CISSB	0xb178
-#define PCI_DEVICE_ID_COMPAQ_CISSC	0x46
 #define PCI_DEVICE_ID_COMPAQ_THUNDER	0xf130
 #define PCI_DEVICE_ID_COMPAQ_NETFLEX3B	0xf150
 
