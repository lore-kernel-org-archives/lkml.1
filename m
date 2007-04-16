Return-Path: <linux-kernel-owner+w=401wt.eu-S1030769AbXDPPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030769AbXDPPpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030777AbXDPPpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:45:53 -0400
Received: from holomorphy.com ([66.93.40.71]:34090 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030769AbXDPPpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:45:51 -0400
Date: Mon, 16 Apr 2007 08:45:40 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416154540.GL8915@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415213153.GW11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415213153.GW11115@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 04:31:54PM -0500, Matt Mackall wrote:
> That's irrelevant. Plugsched was an attempt to get alternative
> schedulers exposure in mainline. I know, because I remember
> encouraging Bill to pursue it. Not only did you veto plugsched (which
> may have been a perfectly reasonable thing to do), but you also vetoed
> the whole concept of multiple schedulers in the tree too. "We don't
> want to balkanize the scheduling landscape".
> And that latter part is what I'm claiming has set us back for years.
> It's not a technical argument but a strategic one. And it's just not a
> good strategy.
[... excellent post trimmed...]

These are some rather powerful arguments. I think I'll actually start
looking at plugsched again.


-- wli
