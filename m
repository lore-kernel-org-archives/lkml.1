Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYG3JGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYG3JGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760477AbYG3JE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:04:56 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:43129 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009AbYG3JEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:04:55 -0400
Subject: [patch 06/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7Oz-0007DJ-2U@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:51:21 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p5/include/linux/pci_ids.h	2008-07-30 13:07:50.568053000 +1000
+++ linux-p6/include/linux/pci_ids.h	2008-07-30 13:09:26.712209000 +1000
@@ -2031,8 +2031,8 @@
 #define PCI_DEVICE_ID_TIGON3_5753	0x16f7
 #define PCI_DEVICE_ID_TIGON3_5753M	0x16fd
 #define PCI_DEVICE_ID_TIGON3_5753F	0x16fe
-#define PCI_DEVICE_ID_TIGON3_5901	0x170d
 #define PCI_DEVICE_ID_BCM4401B1		0x170c
+#define PCI_DEVICE_ID_TIGON3_5901	0x170d
 #define PCI_DEVICE_ID_TIGON3_5901_2	0x170e
 #define PCI_DEVICE_ID_TIGON3_5906	0x1712
 #define PCI_DEVICE_ID_TIGON3_5906M	0x1713
