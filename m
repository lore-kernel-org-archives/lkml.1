Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYG3JeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYG3JeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbYG3Jd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:33:28 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:39732 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689AbYG3Jd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:33:27 -0400
Subject: [patch 31/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7R3-0007K1-2V@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:53:29 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p30/include/linux/pci_ids.h	2008-07-30 13:55:13.560136000 +1000
+++ linux-p31/include/linux/pci_ids.h	2008-07-30 15:35:00.324525000 +1000
@@ -1615,6 +1615,8 @@
 #define PCI_SUBDEVICE_ID_AT_2701FX	0x2703
 
 #define PCI_VENDOR_ID_ESS		0x125d
+/* formerly Platform Tech */
+#define PCI_DEVICE_ID_ESS_ESS0100	0x0100
 #define PCI_DEVICE_ID_ESS_ESS1968	0x1968
 #define PCI_DEVICE_ID_ESS_ESS1978	0x1978
 #define PCI_DEVICE_ID_ESS_ALLEGRO_1	0x1988
@@ -1647,9 +1649,6 @@
 #define PCI_DEVICE_ID_ITE_8872		0x8872
 #define PCI_DEVICE_ID_ITE_IT8330G_0	0xe886
 
-/* formerly Platform Tech */
-#define PCI_DEVICE_ID_ESS_ESS0100	0x0100
-
 #define PCI_VENDOR_ID_ALTEON		0x12ae
 
 #define PCI_SUBVENDOR_ID_CONNECT_TECH			0x12c4
