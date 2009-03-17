Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbZCQA2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbZCQA2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbZCQA2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:9269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbZCQA2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="673456226"
Message-Id: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/13] x2apic and interrupt-remapping related fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables support for kexec, vt-d fault-handling,
simplified io-apic level triggered irq migration and other fixes, cleanups
for platforms enabling x2apic and interrupt-remapping.

thanks,
suresh
-- 

