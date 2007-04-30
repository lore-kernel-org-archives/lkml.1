Return-Path: <linux-kernel-owner+w=401wt.eu-S1423447AbXD3P4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423447AbXD3P4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423439AbXD3P4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423447AbXD3Ptl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:41 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070430549.617098000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/34] x86 candidate patches for review VI: MTRR, APIC, more paravirt, misc
Date: Mon, 30 Apr 2007 17:49:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Various more x86 patches:

- Safer APIC access during kcrash
- Handle fixed MTRRs on K8
- A few more paravirt changes
- Pagetable optimizations from Zach
- Slab optimization for non NUMA systems from Suresh
- Support machine checks on AMD Fam10 on 32bit kernels from Joachim
- Other misc stuff

Happy reviewing!

-Andi

