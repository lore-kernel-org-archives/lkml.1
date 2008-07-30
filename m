Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbYG3KbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbYG3KbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYG3KbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:31:06 -0400
Received: from evaki.its.uow.edu.au ([130.130.68.32]:44225 "EHLO
	evaki.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYG3KbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:31:05 -0400
Subject: [patch 25/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7QY-0007Ik-FR@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:52:58 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-p24/include/linux/pci_ids.h	2008-07-30 13:39:33.074864000 +1000
+++ linux-p25/include/linux/pci_ids.h	2008-07-30 13:42:14.072787000 +1000
@@ -500,6 +500,16 @@
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
+#define PCI_DEVICE_ID_AMD_LX_VIDEO  0x2081
+#define PCI_DEVICE_ID_AMD_LX_AES    0x2082
+#define PCI_DEVICE_ID_AMD_CS5536_ISA    0x2090
+#define PCI_DEVICE_ID_AMD_CS5536_FLASH  0x2091
+#define PCI_DEVICE_ID_AMD_CS5536_AUDIO  0x2093
+#define PCI_DEVICE_ID_AMD_CS5536_OHC    0x2094
+#define PCI_DEVICE_ID_AMD_CS5536_EHC    0x2095
+#define PCI_DEVICE_ID_AMD_CS5536_UDC    0x2096
+#define PCI_DEVICE_ID_AMD_CS5536_UOC    0x2097
+#define PCI_DEVICE_ID_AMD_CS5536_IDE    0x209A
 #define PCI_DEVICE_ID_AMD_SERENADE	0x36c0
 #define PCI_DEVICE_ID_AMD_FE_GATE_7006	0x7006
 #define PCI_DEVICE_ID_AMD_FE_GATE_7007	0x7007
@@ -516,26 +526,15 @@
 #define PCI_DEVICE_ID_AMD_OPUS_7443	0x7443
 #define PCI_DEVICE_ID_AMD_VIPER_7443	0x7443
 #define PCI_DEVICE_ID_AMD_OPUS_7445	0x7445
+#define PCI_DEVICE_ID_AMD_8131_BRIDGE	0x7450
+#define PCI_DEVICE_ID_AMD_8131_APIC	0x7451
+#define PCI_DEVICE_ID_AMD_8151_0	0x7454
+#define PCI_DEVICE_ID_AMD_8132_BRIDGE	0x7458
 #define PCI_DEVICE_ID_AMD_8111_LPC	0x7468
 #define PCI_DEVICE_ID_AMD_8111_IDE	0x7469
 #define PCI_DEVICE_ID_AMD_8111_SMBUS2	0x746a
 #define PCI_DEVICE_ID_AMD_8111_SMBUS	0x746b
 #define PCI_DEVICE_ID_AMD_8111_AUDIO	0x746d
-#define PCI_DEVICE_ID_AMD_8151_0	0x7454
-#define PCI_DEVICE_ID_AMD_8131_BRIDGE	0x7450
-#define PCI_DEVICE_ID_AMD_8131_APIC	0x7451
-#define PCI_DEVICE_ID_AMD_8132_BRIDGE	0x7458
-#define PCI_DEVICE_ID_AMD_CS5536_ISA    0x2090
-#define PCI_DEVICE_ID_AMD_CS5536_FLASH  0x2091
-#define PCI_DEVICE_ID_AMD_CS5536_AUDIO  0x2093
-#define PCI_DEVICE_ID_AMD_CS5536_OHC    0x2094
-#define PCI_DEVICE_ID_AMD_CS5536_EHC    0x2095
-#define PCI_DEVICE_ID_AMD_CS5536_UDC    0x2096
-#define PCI_DEVICE_ID_AMD_CS5536_UOC    0x2097
-#define PCI_DEVICE_ID_AMD_CS5536_IDE    0x209A
-
-#define PCI_DEVICE_ID_AMD_LX_VIDEO  0x2081
-#define PCI_DEVICE_ID_AMD_LX_AES    0x2082
 
 #define PCI_VENDOR_ID_TRIDENT		0x1023
 #define PCI_DEVICE_ID_TRIDENT_4DWAVE_DX	0x2000
