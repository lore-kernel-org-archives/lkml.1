Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbYG3Jxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbYG3Jxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbYG3Jxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:53:37 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:41057 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761467AbYG3Jxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:53:36 -0400
Subject: [patch 07/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7P4-0007DW-5Q@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:26 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p6/include/linux/pci_ids.h	2008-07-30 13:09:26.712209000 +1000
+++ linux-p7/include/linux/pci_ids.h	2008-07-30 13:10:46.722167000 +1000
@@ -1950,9 +1950,9 @@
 #define PCI_DEVICE_ID_TITAN_400L	0x8040
 #define PCI_DEVICE_ID_TITAN_800L	0x8080
 #define PCI_DEVICE_ID_TITAN_100		0xA001
-#define PCI_DEVICE_ID_TITAN_200		0xA005
 #define PCI_DEVICE_ID_TITAN_400		0xA003
 #define PCI_DEVICE_ID_TITAN_800B	0xA004
+#define PCI_DEVICE_ID_TITAN_200		0xA005
 
 #define PCI_VENDOR_ID_PANACOM		0x14d4
 #define PCI_DEVICE_ID_PANACOM_QUADMODEM	0x0400
