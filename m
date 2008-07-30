Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbYG3Jd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbYG3Jd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYG3Jc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:32:58 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:45561 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYG3Jc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:32:57 -0400
Subject: [patch 20/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Q8-0007HB-WC@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:32 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p19/include/linux/pci_ids.h	2008-07-30 13:33:04.474199000 +1000
+++ linux-p20/include/linux/pci_ids.h	2008-07-30 13:34:07.224952000 +1000
@@ -811,16 +811,16 @@
 
 #define PCI_VENDOR_ID_PROMISE		0x105a
 #define PCI_DEVICE_ID_PROMISE_20265	0x0d30
+#define PCI_DEVICE_ID_PROMISE_20263	0x0D38
+#define PCI_DEVICE_ID_PROMISE_20275	0x1275
 #define PCI_DEVICE_ID_PROMISE_20267	0x4d30
 #define PCI_DEVICE_ID_PROMISE_20246	0x4d33
 #define PCI_DEVICE_ID_PROMISE_20262	0x4d38
-#define PCI_DEVICE_ID_PROMISE_20263	0x0D38
 #define PCI_DEVICE_ID_PROMISE_20268	0x4d68
 #define PCI_DEVICE_ID_PROMISE_20269	0x4d69
+#define PCI_DEVICE_ID_PROMISE_20276	0x5275
 #define PCI_DEVICE_ID_PROMISE_20270	0x6268
 #define PCI_DEVICE_ID_PROMISE_20271	0x6269
-#define PCI_DEVICE_ID_PROMISE_20275	0x1275
-#define PCI_DEVICE_ID_PROMISE_20276	0x5275
 #define PCI_DEVICE_ID_PROMISE_20277	0x7275
 
 #define PCI_VENDOR_ID_UMC		0x1060
