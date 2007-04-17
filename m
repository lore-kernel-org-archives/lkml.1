Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXDQG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXDQG0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXDQG0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:26:19 -0400
Received: from holomorphy.com ([66.93.40.71]:35472 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXDQG0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:26:18 -0400
Date: Mon, 16 Apr 2007 23:26:21 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417062621.GL2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417061503.GC1057@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:09:55PM -0700, William Lee Irwin III wrote:
>> All things are not equal; they all have different properties. I like

On Tue, Apr 17, 2007 at 08:15:03AM +0200, Nick Piggin wrote:
> Exactly. So we have to explore those properties and evaluate performance
> (in all meanings of the word). That's only logical.

Any chance you'd be willing to put down a few thoughts on what sorts
of standards you'd like to set for both correctness (i.e. the bare
minimum a scheduler implementation must do to be considered valid
beyond not oopsing) and performance metrics (i.e. things that produce
numbers for each scheduler you can compare to say "this scheduler is
better than this other scheduler at this.").


-- wli
