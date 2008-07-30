Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbYG3JIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbYG3JIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYG3JIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:08:07 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43487 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYG3JIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:08:06 -0400
Subject: [patch 19/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Q3-0007Gz-T1@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:27 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p18/include/linux/pci_ids.h	2008-07-30 13:32:12.199574000 +1000
+++ linux-p19/include/linux/pci_ids.h	2008-07-30 13:33:04.474199000 +1000
@@ -838,8 +838,8 @@
 #define PCI_DEVICE_ID_MYLEX_DAC960_PG	0x0010
 #define PCI_DEVICE_ID_MYLEX_DAC960_LA	0x0020
 #define PCI_DEVICE_ID_MYLEX_DAC960_LP	0x0050
-#define PCI_DEVICE_ID_MYLEX_DAC960_BA	0xBA56
 #define PCI_DEVICE_ID_MYLEX_DAC960_GEM	0xB166
+#define PCI_DEVICE_ID_MYLEX_DAC960_BA	0xBA56
 
 #define PCI_VENDOR_ID_APPLE		0x106b
 #define PCI_DEVICE_ID_APPLE_BANDIT	0x0001
