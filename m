Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYG3JL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYG3JL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbYG3JLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:11:41 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43778 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbYG3JLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:11:40 -0400
Subject: [patch 29/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Qs-0007Jb-SN@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:53:18 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p28/include/linux/pci_ids.h	2008-07-30 13:47:46.384774000 +1000
+++ linux-p29/include/linux/pci_ids.h	2008-07-30 13:53:10.256659000 +1000
@@ -183,29 +183,29 @@
 #define PCI_DEVICE_ID_LSI_53C1030	0x0030
 #define PCI_DEVICE_ID_LSI_1030_53C1035	0x0032
 #define PCI_DEVICE_ID_LSI_53C1035	0x0040
+#define PCI_DEVICE_ID_LSI_SAS1064	0x0050
+#define PCI_DEVICE_ID_LSI_SAS1068	0x0054
+#define PCI_DEVICE_ID_LSI_SAS1064E	0x0056
+#define PCI_DEVICE_ID_LSI_SAS1068E	0x0058
+#define PCI_DEVICE_ID_LSI_SAS1066E	0x005A
+#define PCI_DEVICE_ID_LSI_SAS1064A	0x005C
+#define PCI_DEVICE_ID_LSI_SAS1066	0x005E
+#define PCI_DEVICE_ID_LSI_SAS1078	0x0060
 #define PCI_DEVICE_ID_NCR_53C875J	0x008f
+#define PCI_DEVICE_ID_LSI_SAS1064R	0x0411
 #define PCI_DEVICE_ID_LSI_FC909		0x0621
 #define PCI_DEVICE_ID_LSI_FC929		0x0622
 #define PCI_DEVICE_ID_LSI_FC929_LAN	0x0623
 #define PCI_DEVICE_ID_LSI_FC919		0x0624
 #define PCI_DEVICE_ID_LSI_FC919_LAN	0x0625
 #define PCI_DEVICE_ID_LSI_FC929X	0x0626
-#define PCI_DEVICE_ID_LSI_FC939X	0x0642
+#define PCI_DEVICE_ID_LSI_FC919X	0x0628
 #define PCI_DEVICE_ID_LSI_FC949X	0x0640
+#define PCI_DEVICE_ID_LSI_FC939X	0x0642
 #define PCI_DEVICE_ID_LSI_FC949ES	0x0646
-#define PCI_DEVICE_ID_LSI_FC919X	0x0628
 #define PCI_DEVICE_ID_NCR_YELLOWFIN	0x0701
 #define PCI_DEVICE_ID_LSI_61C102	0x0901
 #define PCI_DEVICE_ID_LSI_63C815	0x1000
-#define PCI_DEVICE_ID_LSI_SAS1064	0x0050
-#define PCI_DEVICE_ID_LSI_SAS1064R	0x0411
-#define PCI_DEVICE_ID_LSI_SAS1066	0x005E
-#define PCI_DEVICE_ID_LSI_SAS1068	0x0054
-#define PCI_DEVICE_ID_LSI_SAS1064A	0x005C
-#define PCI_DEVICE_ID_LSI_SAS1064E	0x0056
-#define PCI_DEVICE_ID_LSI_SAS1066E	0x005A
-#define PCI_DEVICE_ID_LSI_SAS1068E	0x0058
-#define PCI_DEVICE_ID_LSI_SAS1078	0x0060
 
 #define PCI_VENDOR_ID_ATI		0x1002
 /* Mach64 */
