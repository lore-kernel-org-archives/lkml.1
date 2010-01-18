Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804Ab0ARH6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0ARH6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655Ab0ARH6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:58:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0ARH6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:58:34 -0500
Date: Mon, 18 Jan 2010 08:58:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [GIT PULL] perf scheduling updates: flexible/pinned groups
 reordering, optimizations
Message-ID: <20100118075826.GA25476@elte.hu>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
 <1263800285.4283.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263800285.4283.11.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2010-01-17 at 13:22 +0100, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the perf/scheduling branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/scheduling
> > 
> > It brings more progresses wrt scheduling ordering between pinned
> > and flexible events.
> > 
> > There is still some work to do, for example concerning context spinlocks
> > that could be acquired once instead of multiple times in some areas.
> > 
> > But this set is still much more optimized than what we had before,
> > especially because of the third patch.
> 
> Looks very nice, thanks Frederic!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Pulled, thanks guys!

	Ingo
