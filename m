Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYG3JdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYG3JdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYG3Jc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:32:56 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:39711 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYG3Jcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:32:55 -0400
Subject: [patch 03/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Oj-0007Cg-Pi@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:05 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p2/include/linux/pci_ids.h	2008-07-30 12:59:43.718781000 +1000
+++ linux-p3/include/linux/pci_ids.h	2008-07-30 13:00:56.679087000 +1000
@@ -2142,13 +2142,6 @@
 #define PCI_VENDOR_ID_BELKIN		0x1799
 #define PCI_DEVICE_ID_BELKIN_F5D7010V7	0x701f
 
-#define PCI_VENDOR_ID_RDC		0x17f3
-#define PCI_DEVICE_ID_RDC_R6020		0x6020
-#define PCI_DEVICE_ID_RDC_R6030		0x6030
-#define PCI_DEVICE_ID_RDC_R6040		0x6040
-#define PCI_DEVICE_ID_RDC_R6060		0x6060
-#define PCI_DEVICE_ID_RDC_R6061		0x6061
-
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
 #define PCI_VENDOR_ID_ARECA		0x17d3
@@ -2178,6 +2171,11 @@
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
 #define PCI_VENDOR_ID_RDC		0x17f3
+#define PCI_DEVICE_ID_RDC_R6020		0x6020
+#define PCI_DEVICE_ID_RDC_R6030		0x6030
+#define PCI_DEVICE_ID_RDC_R6040		0x6040
+#define PCI_DEVICE_ID_RDC_R6060		0x6060
+#define PCI_DEVICE_ID_RDC_R6061		0x6061
 
 #define PCI_VENDOR_ID_SITECOM		0x182d
 #define PCI_DEVICE_ID_SITECOM_DC105V2	0x3069
