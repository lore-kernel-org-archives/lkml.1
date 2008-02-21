Return-Path: <linux-kernel-owner+w=401wt.eu-S1761090AbYBUSYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbYBUSYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYBUSYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:24:17 -0500
Received: from mga07.intel.com ([143.182.124.22]:7400 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305AbYBUSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:24:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,387,1199692800"; 
   d="scan'208";a="381979249"
Date: Thu, 21 Feb 2008 10:15:55 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] copyright owner and author clean up for intel iommu and
	related files
Message-ID: <20080221181555.GA9593@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a clean up and correction of the copyright holding
entities for the files associated with the intel iommu code.


Its a no brainer.

--mgross


Signed-off-by: <mgross@linux.intel.com>



Index: linux-2.6.24-mm1/drivers/pci/dmar.c
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/dmar.c	2008-02-21 09:22:57.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/dmar.c	2008-02-21 09:24:02.000000000 -0800
@@ -14,11 +14,12 @@
  * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * 	Copyright (C) Ashok Raj <ashok.raj@intel.com>
- *	Copyright (C) Shaohua Li <shaohua.li@intel.com>
- *	Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Shaohua Li <shaohua.li@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  *
- * 	This file implements early detection/parsing of DMA Remapping Devices
+ * This file implements early detection/parsing of DMA Remapping Devices
  * reported to OS through BIOS via DMA remapping reporting (DMAR) ACPI
  * tables.
  */
Index: linux-2.6.24-mm1/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/intel-iommu.c	2008-02-21 08:53:43.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/intel-iommu.c	2008-02-21 09:02:25.000000000 -0800
@@ -14,9 +14,10 @@
  * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * Copyright (C) Ashok Raj <ashok.raj@intel.com>
- * Copyright (C) Shaohua Li <shaohua.li@intel.com>
- * Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Shaohua Li <shaohua.li@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
 #include <linux/init.h>
Index: linux-2.6.24-mm1/drivers/pci/intel-iommu.h
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/intel-iommu.h	2008-02-21 08:53:45.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/intel-iommu.h	2008-02-21 09:22:47.000000000 -0800
@@ -14,8 +14,9 @@
  * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * Copyright (C) Ashok Raj <ashok.raj@intel.com>
- * Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
 #ifndef _INTEL_IOMMU_H_
Index: linux-2.6.24-mm1/drivers/pci/iova.c
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/iova.c	2008-02-21 08:53:35.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/iova.c	2008-02-21 09:02:51.000000000 -0800
@@ -3,7 +3,8 @@
  *
  * This file is released under the GPLv2.
  *
- * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
 #include "iova.h"
Index: linux-2.6.24-mm1/drivers/pci/iova.h
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/iova.h	2008-02-21 08:53:39.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/iova.h	2008-02-21 09:03:20.000000000 -0800
@@ -3,7 +3,8 @@
  *
  * This file is released under the GPLv2.
  *
- * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  *
  */
 
