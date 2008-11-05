Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYKEKsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYKEKsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYKEKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:48:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:48469 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYKEKsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:48:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,550,1220252400"; 
   d="scan'208";a="635742185"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH]2/3 intel_menlow:Adding to MAINTAINERS
Date: Wed, 5 Nov 2008 16:15:31 +0530
Message-ID: <7D0189F5BE1DF549A570B212D1D5612182AF04@bgsmsx412.gar.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]2/3 intel_menlow:Adding to MAINTAINERS
Thread-Index: Ack/M5+00dYMedumT6+pA/1WucMM/g==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Len Brown" <lenb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>, "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 05 Nov 2008 10:45:34.0784 (UTC) FILETIME=[A1D67C00:01C93F33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a maintainer for intel's menlow thermal driver

Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.27/MAINTAINERS
===================================================================
--- linux-2.6.27.orig/MAINTAINERS
+++ linux-2.6.27/MAINTAINERS
@@ -2185,6 +2185,13 @@ M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for
non-subscribers)
 S:	Maintained
 
+INTEL MENLOW THERMAL DRIVER
+P:	Sujith Thomas
+M:	sujith.thomas@intel.com
+L:	linux-acpi@vger.kernel.org
+W:	http://www.lesswatts.org/projects/acpi/
+S:	Supported
+
 INTEL IA32 MICROCODE UPDATE SUPPORT
 P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
