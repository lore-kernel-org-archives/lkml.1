Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbYG3Jd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbYG3Jd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760152AbYG3JdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:33:07 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:45579 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062AbYG3JdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:33:06 -0400
Subject: [patch 21/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7QE-0007HO-38@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:38 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p20/include/linux/pci_ids.h	2008-07-30 13:34:07.224952000 +1000
+++ linux-p21/include/linux/pci_ids.h	2008-07-30 13:35:33.641989000 +1000
@@ -701,8 +701,8 @@
 #define PCI_DEVICE_ID_HP_DIVA_TOSCA1	0x1049
 #define PCI_DEVICE_ID_HP_DIVA_TOSCA2	0x104A
 #define PCI_DEVICE_ID_HP_DIVA_MAESTRO	0x104B
-#define PCI_DEVICE_ID_HP_REO_IOC	0x10f1
 #define PCI_DEVICE_ID_HP_VISUALIZE_FXE	0x108b
+#define PCI_DEVICE_ID_HP_REO_IOC	0x10f1
 #define PCI_DEVICE_ID_HP_DIVA_HALFDOME	0x1223
 #define PCI_DEVICE_ID_HP_DIVA_KEYSTONE	0x1226
 #define PCI_DEVICE_ID_HP_DIVA_POWERBAR	0x1227
