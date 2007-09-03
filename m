Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbXICIU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbXICIU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXICITx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:19:53 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:14241 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbXICITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:19:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <20070903081736.683105000@amd.com>
References: <20070903081736.288288000@amd.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Sep 2007 10:17:40 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 4/5] x86: Add PCI IDs for AMD Barcelona PCI devices
X-OriginalArrivalTime: 03 Sep 2007 08:18:31.0667 (UTC)
 FILETIME=[03A2EC30:01C7EE03]
MIME-Version: 1.0
X-WSS-ID: 6AC51C121A46452966-13-01
Content-Disposition: inline;
 filename=fam10h-pci-ids.diff
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>

---
 include/linux/pci_ids.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/include/linux/pci_ids.h
===================================================================
--- linux-2.6.orig/include/linux/pci_ids.h
+++ linux-2.6/include/linux/pci_ids.h
@@ -501,6 +501,11 @@
 #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
 #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
+#define PCI_DEVICE_ID_AMD_FAM10H_HT	0x1200
+#define PCI_DEVICE_ID_AMD_FAM10H_MAP	0x1201
+#define PCI_DEVICE_ID_AMD_FAM10H_DRAM	0x1202
+#define PCI_DEVICE_ID_AMD_FAM10H_MISC	0x1203
+#define PCI_DEVICE_ID_AMD_FAM10H_LINK	0x1204
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



