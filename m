Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYG3Jwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYG3Jwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbYG3JwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:52:25 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:40937 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbYG3JwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:52:24 -0400
Subject: [patch 09/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7PE-0007Dv-BE@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:36 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p8/include/linux/pci_ids.h	2008-07-30 13:11:35.923753000 +1000
+++ linux-p9/include/linux/pci_ids.h	2008-07-30 13:12:24.429345000 +1000
@@ -1730,6 +1730,9 @@
 #define PCI_DEVICE_ID_SIIG_1S_20x_550	0x2000
 #define PCI_DEVICE_ID_SIIG_1S_20x_650	0x2001
 #define PCI_DEVICE_ID_SIIG_1S_20x_850	0x2002
+#define PCI_DEVICE_ID_SIIG_1S1P_20x_550	0x2010
+#define PCI_DEVICE_ID_SIIG_1S1P_20x_650	0x2011
+#define PCI_DEVICE_ID_SIIG_1S1P_20x_850	0x2012
 #define PCI_DEVICE_ID_SIIG_1P_20x	0x2020
 #define PCI_DEVICE_ID_SIIG_2P_20x	0x2021
 #define PCI_DEVICE_ID_SIIG_2S_20x_550	0x2030
@@ -1738,9 +1741,6 @@
 #define PCI_DEVICE_ID_SIIG_2P1S_20x_550	0x2040
 #define PCI_DEVICE_ID_SIIG_2P1S_20x_650	0x2041
 #define PCI_DEVICE_ID_SIIG_2P1S_20x_850	0x2042
-#define PCI_DEVICE_ID_SIIG_1S1P_20x_550	0x2010
-#define PCI_DEVICE_ID_SIIG_1S1P_20x_650	0x2011
-#define PCI_DEVICE_ID_SIIG_1S1P_20x_850	0x2012
 #define PCI_DEVICE_ID_SIIG_4S_20x_550	0x2050
 #define PCI_DEVICE_ID_SIIG_4S_20x_650	0x2051
 #define PCI_DEVICE_ID_SIIG_4S_20x_850	0x2052
