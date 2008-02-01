Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYBAJfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYBAJfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYBAJeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:34:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:9695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbYBAJeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:34:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,289,1199692800"; 
   d="scan'208";a="294850345"
Subject: [PATCH 0/4] x86: set_memory_xx enhancement
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Feb 2008 17:34:42 +0800
Message-Id: <1201858482.4051.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 01 Feb 2008 09:33:37.0525 (UTC) FILETIME=[85B68A50:01C864B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enhances set_memory_xx functions and updates its usage
such as EFI accordingly.

This patchset is based on latest x86 git tree and has been tested on
EFI 32 and EFI 64 platform.

Best Regards,
Huang Ying

