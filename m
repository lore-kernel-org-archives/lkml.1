Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbXJaBTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbXJaBTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXJaBSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:18:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:54269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXJaBSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:18:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,349,1188802800"; 
   d="scan'208";a="363841133"
Subject: Re: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@pol.net>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1193218342.23935.147.camel@caritas-dev.intel.com>
References: <1193218342.23935.147.camel@caritas-dev.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Oct 2007 09:21:41 +0800
Message-Id: <1193793701.23935.394.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 31 Oct 2007 01:18:39.0331 (UTC) FILETIME=[F7CB0330:01C81B5B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can this patchset be merged into mainline kernel? This patchset has been
in -mm tree from 2.6.23-rc2-mm2 on. Andrew Moton has suggested it to be
merged into 2.6.24 during early merge window of 2.6.24. It was not
merged into mainline because the 32-bit boot protocol has not been done.

But now, the 32-bit boot protocol has been merged into mainline. So can
this patchset be merged into mainline kernel now?

Best Regards,
Huang Ying
