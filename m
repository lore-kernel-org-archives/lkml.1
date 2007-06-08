Return-Path: <linux-kernel-owner+w=401wt.eu-S938888AbXFHHrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938888AbXFHHrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937120AbXFHHYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:47 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55271 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938376AbXFHHYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:45 -0400
Message-Id: <20070608072208.773460000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Gaston <jason.d.gaston@intel.com>, Greg KH <greg@kroah.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 24/54] pci_ids: update patch for Intel ICH9M
Content-Disposition: inline; filename=pci_ids-update-patch-for-intel-ich9m.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jason Gaston <jason.d.gaston@intel.com>

This patch updates the Intel ICH9M LPC Controller DID's, due to a
specification change.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Cc: <stable@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/pci_ids.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21.4.orig/include/linux/pci_ids.h
+++ linux-2.6.21.4/include/linux/pci_ids.h
@@ -2260,11 +2260,11 @@
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

-- 
