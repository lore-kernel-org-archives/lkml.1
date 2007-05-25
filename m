Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbXEYTCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbXEYTCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXEYTCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:02:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:15031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXEYTCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:02:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,580,1170662400"; 
   d="scan'208";a="247367312"
From: Jason Gaston <jason.d.gaston@intel.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, jason.d.gaston@intel.com
Subject: [PATCH 2.6.22-rc2] pci_ids: update patch for Intel ICH9M
Date: Fri, 25 May 2007 12:03:31 -0700
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705251203.31985.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Intel ICH9M LPC Controller DID's, due to a 
specification change.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.22-rc2/include/linux/pci_ids.h.orig	2007-05-25 
11:42:11.000000000 -0700
+++ linux-2.6.22-rc2/include/linux/pci_ids.h	2007-05-25 11:43:28.000000000 
-0700
@@ -2266,11 +2266,11 @@
 #define PCI_DEVICE_ID_INTEL_ICH8_5	0x283e
 #define PCI_DEVICE_ID_INTEL_ICH8_6	0x2850
 #define PCI_DEVICE_ID_INTEL_ICH9_0	0x2910
-#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2911
+#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2917
 #define PCI_DEVICE_ID_INTEL_ICH9_2	0x2912
 #define PCI_DEVICE_ID_INTEL_ICH9_3	0x2913
 #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
-#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2915
+#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
 #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
