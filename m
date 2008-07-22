Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYGVT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYGVT1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYGVTYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:02 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40544 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYGVTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:58 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9V8-02-3LN-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/24] x86: Add PCI IDs for AMD Barcelona PCI devices
Date: Tue, 22 Jul 2008 21:08:45 +0200
Message-ID: <1216753748-11261-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:38.0933 (UTC) FILETIME=[71A5B650:01C8EC30]
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
index d8507eb..d1a52d8 100644
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


