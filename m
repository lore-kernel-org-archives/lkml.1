Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXGWU7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXGWU7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbXGWU6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:58:47 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:7771 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbXGWU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:58:45 -0400
Message-ID: <46A3F9A3.10508@nvidia.com>
Date: Sun, 22 Jul 2007 20:43:15 -0400
From: Ayaz Abdulla <aabdulla@nvidia.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>, Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@osdl.org>, nedev <netdev@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] forcedeth: new device ids in pci_ids.h
X-NVConfidentiality: public
Content-Type: multipart/mixed;
 boundary="------------050903070508030800080108"
X-OriginalArrivalTime: 23 Jul 2007 20:53:34.0243 (UTC) FILETIME=[88B9EF30:01C7CD6B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903070508030800080108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch contains new device ids for MCP73 chipset.

Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>


--------------050903070508030800080108
Content-Type: text/plain;
 name="patch-device-ids-mcp73"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-device-ids-mcp73"

--- old/include/linux/pci_ids.h	2007-07-22 18:57:26.000000000 -0400
+++ new/include/linux/pci_ids.h	2007-07-22 18:57:11.000000000 -0400
@@ -1223,6 +1223,10 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_25              0x054D
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
+#define PCI_DEVICE_ID_NVIDIA_NVENET_28              0x07DC
+#define PCI_DEVICE_ID_NVIDIA_NVENET_29              0x07DD
+#define PCI_DEVICE_ID_NVIDIA_NVENET_30              0x07DE
+#define PCI_DEVICE_ID_NVIDIA_NVENET_31              0x07DF
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759

--------------050903070508030800080108--
