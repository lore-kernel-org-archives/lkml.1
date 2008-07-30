Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbYG3KEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbYG3KEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYG3KEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:04:25 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:41863 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761326AbYG3KEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:04:25 -0400
Subject: [patch 04/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Oo-0007Cs-Sz@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:10 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p3/include/linux/pci_ids.h	2008-07-30 13:00:56.679087000 +1000
+++ linux-p4/include/linux/pci_ids.h	2008-07-30 13:04:29.063645000 +1000
@@ -2091,7 +2091,6 @@
 #define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300        0x7002
-#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
 #define PCI_DEVICE_ID_ADDIDATA_APCI7500_2      0x7009
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420_2      0x700A
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300_2      0x700B
@@ -2099,6 +2098,7 @@
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
 #define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
 
 #define PCI_VENDOR_ID_PDC		0x15e9
 
