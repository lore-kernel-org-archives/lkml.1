Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYG3JkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYG3JkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYG3JkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:40:07 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:46030 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbYG3JkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:40:06 -0400
Subject: [patch 11/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7PO-0007EK-Hg@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:46 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p10/include/linux/pci_ids.h	2008-07-30 13:14:38.402939000 +1000
+++ linux-p11/include/linux/pci_ids.h	2008-07-30 13:15:27.708539000 +1000
@@ -1633,9 +1633,9 @@
 #define PCI_DEVICE_ID_SATSAGEM_NICCY	0x1016
 
 #define PCI_VENDOR_ID_ENSONIQ		0x1274
-#define PCI_DEVICE_ID_ENSONIQ_CT5880	0x5880
-#define PCI_DEVICE_ID_ENSONIQ_ES1370	0x5000
 #define PCI_DEVICE_ID_ENSONIQ_ES1371	0x1371
+#define PCI_DEVICE_ID_ENSONIQ_ES1370	0x5000
+#define PCI_DEVICE_ID_ENSONIQ_CT5880	0x5880
 
 #define PCI_VENDOR_ID_TRANSMETA		0x1279
 #define PCI_DEVICE_ID_EFFICEON		0x0060
