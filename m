Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYG3Jdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYG3Jdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYG3JdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:33:00 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:45565 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbYG3Jc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:32:59 -0400
Subject: [patch 08/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7P9-0007Di-8G@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:31 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p7/include/linux/pci_ids.h	2008-07-30 13:10:46.722167000 +1000
+++ linux-p8/include/linux/pci_ids.h	2008-07-30 13:11:35.923753000 +1000
@@ -1776,9 +1776,9 @@
 #define PCI_VENDOR_ID_SEALEVEL		0x135e
 #define PCI_DEVICE_ID_SEALEVEL_U530	0x7101
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM2	0x7201
-#define PCI_DEVICE_ID_SEALEVEL_UCOMM422	0x7402
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM232	0x7202
 #define PCI_DEVICE_ID_SEALEVEL_COMM4	0x7401
+#define PCI_DEVICE_ID_SEALEVEL_UCOMM422	0x7402
 #define PCI_DEVICE_ID_SEALEVEL_COMM8	0x7801
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM8	0x7804
 
