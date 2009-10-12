Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbZJLBDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbZJLBDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZJLBDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:03:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:62131 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZJLBDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:03:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,544,1249282800"; 
   d="scan'208";a="197735888"
Date: Mon, 12 Oct 2009 09:02:35 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Richard Kennedy <richard@rsk.demon.co.uk>, Theodore Tso <tytso@mit.edu>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [Bug #14266] regression in page writeback
Message-ID: <20091012010235.GA30378@sli10-desk.sh.intel.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.riC.kzl0KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <L6tb-VyKHZK.A.riC.kzl0KB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 07:01:09AM +0800, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14266
> Subject		: regression in page writeback
> Submitter	: Shaohua Li <shaohua.li@intel.com>
> Date		: 2009-09-22 5:49 (20 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7831a0bdf06b9f722b947bb0c205ff7d77cebd8
> References	: http://marc.info/?l=linux-kernel&m=125359858117176&w=4
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
The regression is disappeared in latest git tree

Thanks,
Shaohua
