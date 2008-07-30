Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbYG3J4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbYG3J4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYG3J4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:56:45 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:47260 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYG3J4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:56:44 -0400
Subject: [patch 02/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Oe-0007CS-Mm@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:00 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p1/include/linux/pci_ids.h	2008-07-30 12:57:57.308494000 +1000
+++ linux-p2/include/linux/pci_ids.h	2008-07-30 12:59:43.718781000 +1000
@@ -2173,8 +2173,8 @@
 
 #define PCI_VENDOR_ID_S2IO		0x17d5
 #define	PCI_DEVICE_ID_S2IO_WIN		0x5731
-#define	PCI_DEVICE_ID_S2IO_UNI		0x5831
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
+#define	PCI_DEVICE_ID_S2IO_UNI		0x5831
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
 #define PCI_VENDOR_ID_RDC		0x17f3
