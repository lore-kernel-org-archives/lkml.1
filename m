Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYF0OJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYF0OJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYF0OJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:09:25 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:36255 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYF0OJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:09:24 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K34KN1-01-KHC-01
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 27 Jun 2008 16:04:28 +0200
Subject: [PATCH] x86: Add PCI IDs for AMD Barcelona PCI devices
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080627140905.EBD1C83D4@erda.amd.com>
X-OriginalArrivalTime: 27 Jun 2008 14:09:06.0186 (UTC) FILETIME=[5C494EA0:01C8D85F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/pci_ids.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index eafc9d6..4a2557c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -497,6 +497,11 @@
 #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
 #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
+#define PCI_DEVICE_ID_AMD_10H_NB_HT	0x1200
+#define PCI_DEVICE_ID_AMD_10H_NB_MAP	0x1201
+#define PCI_DEVICE_ID_AMD_10H_NB_DRAM	0x1202
+#define PCI_DEVICE_ID_AMD_10H_NB_MISC	0x1203
+#define PCI_DEVICE_ID_AMD_10H_NB_LINK	0x1204
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
-- 
1.5.5.4


