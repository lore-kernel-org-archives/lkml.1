Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYLSVvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYLSVvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYLSVui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:53755 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbYLSVuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="372404919"
Message-Id: <20081219214725.125171000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 13:47:25 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 0/5] Changes based on review comments for PAT pfnmap tracking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incremental patches to address the review comments from Nick Piggin
for v3 version of x86 PAT pfnmap changes patchset here

http://lkml.indiana.edu/hypermail/linux/kernel/0812.2/01330.html

-- 

