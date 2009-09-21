Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZIULTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZIULTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZIULTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:19:34 -0400
Received: from ozlabs.org ([203.10.76.45]:52674 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZIULTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:19:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19127.24899.576444.303678@cargo.ozlabs.ibm.com>
Date: Mon, 21 Sep 2009 21:19:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Sachin Sant <sachinp@in.ibm.com>,
       Markus Metzger <markus.t.metzger@intel.com>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf_counter/powerpc: Fix compilation after
	perf_counter_overflow change
In-Reply-To: <20090921071127.GA24467@elte.hu>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
	<20090921071127.GA24467@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Paul, you might also want to test the perfcounter bits of -tip on 
> PowerPC a bit more frequently - this patch was there for 5 days before i 
> sent it to Linus.

Yes, I'll try to do that in future.

I hope I didn't come across as blaming anyone for anything - that
wasn't my intention at all.

> Cross-builds didnt catch it as perfcounters isnt enabled by default in 
> any of the powerpc defconfigs:

I'll get that fixed too.

Paul.
