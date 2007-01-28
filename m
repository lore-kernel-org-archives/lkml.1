Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbXA1VHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbXA1VHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbXA1VHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:07:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbXA1VHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:07:23 -0500
Date: Sun, 28 Jan 2007 22:05:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128210536.GA6237@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128184116.GA12150@elte.hu> <20070128203841.GA27397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128203841.GA27397@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> Thanks for having some numbers to start with.

you are welcome.

> > Any rational explanation?
> 
> Can we please stop this stupid pissing contest.  I'm totally fine to 
> admit yours is bigger than mine in public, so let's get back to the 
> facts.

sure. Could we begin with you not doing derogative, belittling comments 
like:

 <hch> so -rt folks also restart the lock brigade crap :P

and:

 * hch hands Peter Zijlstra the mister braindead locking madness award

but to show a little bit of .. respect and goodwill towards the work of 
others? Those comments might sound funny to you, but they are offensive 
to me.

I'll readily admit that the patches are complex and even ugly, but the 
problem is complex and ugly to begin with. /Finally/ someone comes along 
and tries to sort out the mess that YOU (amonst others, like me) have 
not fixed for years, and you welcome his (hard!) efforts with ridicule?

You also are NAK-ing the same patches on lkml for clearly bogus reasons: 
for example your 'this is lockdep internals' comment was off the mark by 
far. So this isnt just colorful comments, it is also actual prejudice 
that is irrational and harmful.

Linux will take 100 years to break into the mainstream if this attitude 
prevails. And i think this is a far bigger problem than pretty much 
/any/ technological problem we have at the moment so i will continue to 
be upset about it, no matter how uncomfortable it is to finally face 
this and no matter how ugly such flames might look externally.

Or if you really cannot talk about hard problems without insulting 
others then /just dont do it/. Nobody is forcing you to do this if you 
cannot find any fun in it, really.

	Ingo
