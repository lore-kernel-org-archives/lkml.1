Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbYGKUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbYGKUSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbYGKUR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:17:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:16853 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbYGKURz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,347,1212390000"; 
   d="txt'?scan'208";a="411748305"
Message-Id: <20080711201443.057901000@linux-os.sc.intel.com>
References: <20080711201442.769225000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Jul 2008 13:11:57 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, x86@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] x2apic: kernel-parameter documentation for "x2apic_phys"
Content-Disposition: inline; filename=x2apic_phys_kernel_parameters.txt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/Documentation/kernel-parameters.txt
===================================================================
--- tree-x86.orig/Documentation/kernel-parameters.txt	2008-07-11 10:58:31.000000000 -0700
+++ tree-x86/Documentation/kernel-parameters.txt	2008-07-11 13:08:22.000000000 -0700
@@ -1379,6 +1379,10 @@
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
+			default x2apic cluster mode on platforms
+			supporting x2apic.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 

-- 

