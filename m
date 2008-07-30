Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYG3KZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYG3KZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYG3KZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:25:13 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:43750 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYG3KZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:25:12 -0400
Subject: [patch 18/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Py-0007GV-Pc@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:22 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p17/include/linux/pci_ids.h	2008-07-30 13:31:13.783880000 +1000
+++ linux-p18/include/linux/pci_ids.h	2008-07-30 13:32:12.199574000 +1000
@@ -870,9 +870,9 @@
 
 #define PCI_VENDOR_ID_YAMAHA		0x1073
 #define PCI_DEVICE_ID_YAMAHA_724	0x0004
-#define PCI_DEVICE_ID_YAMAHA_724F	0x000d
 #define PCI_DEVICE_ID_YAMAHA_740	0x000a
 #define PCI_DEVICE_ID_YAMAHA_740C	0x000c
+#define PCI_DEVICE_ID_YAMAHA_724F	0x000d
 #define PCI_DEVICE_ID_YAMAHA_744	0x0010
 #define PCI_DEVICE_ID_YAMAHA_754	0x0012
 
