Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZIWTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZIWTaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZIWTah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:30:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZIWTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:30:37 -0400
Date: Wed, 23 Sep 2009 21:30:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, acme@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090923193020.GA20934@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090922.153201.225375909.davem@davemloft.net> <20090923114725.GB4132@elte.hu> <20090923.111444.247045711.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923.111444.247045711.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 23 Sep 2009 13:47:25 +0200
> 
> > Could you please also create the linux-perf-users list, for perf 
> > events and the perf tool related user questions? (We have asked for 
> > this before but must have gotten lost somewhere)
> 
> I think your communities are similar enough and small enough that you 
> could share this list.

It's two separate subsystems. There's a lot of non-tracing aspects of 
performance events: it does profiling, counting, latency analysis, etc. 
The tool is named 'perf', the subsystem is named 'performance events', 
and the most typical workflows dont do any tracing.

And i beg to differ about the size of the communities. It's just been 
added upstream...

Also, what is the policy for adding new lists to vger.kernel.org? If a 
subsystem maintainer asks for a list named after a core kernel 
subsystem, how frequently is it rejected, and on what basis?

I find it sad that such an arbitrary looking negative decision from you 
forces a user list away from vger. I wouldnt mind it to be closed if it 
has no significant traffic after a year or lifetime or so - many vger 
lists have almost no traffic to begin with.

Also, i cannot help but to observe the fact that you've fought the 
original perfcounters project in a very ugly and public way less than a 
year ago. Dont you think that you 'deciding' this matter in such a 
negative fashion is a conflict of interest?

	Ingo
