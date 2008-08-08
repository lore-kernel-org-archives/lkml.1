Return-Path: <linux-kernel-owner+w=401wt.eu-S1764672AbYHHXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764672AbYHHXLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763439AbYHHXLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:11:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:15791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763428AbYHHXLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="324556000"
From: Seth Heasley <seth.heasley@intel.com>
To: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, khali@linux-fr.org
Subject: [PATCH 2.6.26.2] pci_ids: patch for Intel Ibex Peak DeviceIDs
Date: Fri, 8 Aug 2008 16:16:07 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081616.08158.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) LPC and SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.26.2/include/linux/pci_ids.h.orig 2008-08-08 11:07:41.000000000 -0700
+++ linux-2.6.26.2/include/linux/pci_ids.h      2008-08-08 11:22:31.000000000 -0700
@@ -2385,6 +2385,9 @@
 #define PCI_DEVICE_ID_INTEL_ICH10_3    0x3a1a
 #define PCI_DEVICE_ID_INTEL_ICH10_4    0x3a30
 #define PCI_DEVICE_ID_INTEL_ICH10_5    0x3a60
+#define PCI_DEVICE_ID_INTEL_PCH_0      0x3b10
+#define PCI_DEVICE_ID_INTEL_PCH_1      0x3b11
+#define PCI_DEVICE_ID_INTEL_PCH_2      0x3b30
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB   0x402f
 #define PCI_DEVICE_ID_INTEL_5400_ERR   0x4030
 #define PCI_DEVICE_ID_INTEL_5400_FBD0  0x4035
