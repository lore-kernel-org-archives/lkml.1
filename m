Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYG3JF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYG3JF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbYG3JEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:04:50 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43117 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182AbYG3JEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:04:49 -0400
Subject: [patch 27/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Qi-0007JA-Lt@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:53:08 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p26/include/linux/pci_ids.h	2008-07-30 13:44:49.874660000 +1000
+++ linux-p27/include/linux/pci_ids.h	2008-07-30 13:46:23.228774000 +1000
@@ -442,8 +442,8 @@
 #define PCI_DEVICE_ID_DEC_21152		0x0024
 #define PCI_DEVICE_ID_DEC_21153		0x0025
 #define PCI_DEVICE_ID_DEC_21154		0x0026
-#define PCI_DEVICE_ID_DEC_21285		0x1065
 #define PCI_DEVICE_ID_COMPAQ_42XX	0x0046
+#define PCI_DEVICE_ID_DEC_21285		0x1065
 
 #define PCI_VENDOR_ID_CIRRUS		0x1013
 #define PCI_DEVICE_ID_CIRRUS_7548	0x0038
