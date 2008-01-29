Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYA2ARc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYA2ARc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYA2ARI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:17:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:4381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYA2ARH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:17:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="331184519"
From: Jason Gaston <jason.d.gaston@intel.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu, jason.d.gaston@intel.com
Subject: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 17:20:36 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281720.37350.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 LPC and SMBus Controller DeviceID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24/include/linux/pci_ids.h.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/include/linux/pci_ids.h	2008-01-28 15:05:41.000000000 -0800
@@ -2339,6 +2339,12 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
+#define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
+#define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
+#define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
+#define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
+#define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
