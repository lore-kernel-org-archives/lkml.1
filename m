Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXGKTsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXGKTsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761634AbXGKTsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:48:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:41573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbXGKTsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,527,1175497200"; 
   d="scan'208";a="267126590"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Add entries to MAINTAINERS for I/OAT and DMAENGINE
Date: Wed, 11 Jul 2007 12:48:33 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02A87A52@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add entries to MAINTAINERS for I/OAT and DMAENGINE
Thread-Index: AcfD8dMm4SV8FBTFTumqsS+VGHvxZAAABiPg
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>
X-OriginalArrivalTime: 11 Jul 2007 19:48:35.0038 (UTC) FILETIME=[77A977E0:01C7C3F4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add entries to MAINTAINERS for I/OAT and DMAENGINE

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>


diff --git a/MAINTAINERS b/MAINTAINERS
index 151f4ef..e27b807 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1277,6 +1277,12 @@ M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+DMA GENERIC MEMCPY SUBSYSTEM
+P:	Shannon Nelson
+M:	shannon.nelson@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
@@ -1901,6 +1907,12 @@ P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 
+INTEL I/OAT DMA DRIVER
+P:	Shannon Nelson
+M:	shannon.nelson@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
