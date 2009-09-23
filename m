Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbZIWTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbZIWTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZIWTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:50:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZIWTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:50:28 -0400
Date: Wed, 23 Sep 2009 21:49:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, acme@redhat.com, mhiramat@redhat.com,
       postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090923194957.GA19358@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090922.153201.225375909.davem@davemloft.net> <20090923114725.GB4132@elte.hu> <20090923.111444.247045711.davem@davemloft.net> <20090923193020.GA20934@elte.hu> <520f0cf10909231240g11f5cafei5cbb4ed494eba76d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10909231240g11f5cafei5cbb4ed494eba76d@mail.gmail.com>
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


* John Kacur <jkacur@gmail.com> wrote:

> On Wed, Sep 23, 2009 at 9:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * David Miller <davem@davemloft.net> wrote:
> >
> >> From: Ingo Molnar <mingo@elte.hu>
> >> Date: Wed, 23 Sep 2009 13:47:25 +0200
> >>
> >> > Could you please also create the linux-perf-users list, for perf
> >> > events and the perf tool related user questions? (We have asked for
> >> > this before but must have gotten lost somewhere)
> >>
> >> I think your communities are similar enough and small enough that you
> >> could share this list.
> >
> > It's two separate subsystems. There's a lot of non-tracing aspects of
> > performance events: it does profiling, counting, latency analysis, etc.
> > The tool is named 'perf', the subsystem is named 'performance events',
> > and the most typical workflows dont do any tracing.
> >
> > And i beg to differ about the size of the communities. It's just been
> > added upstream...
> >
> > Also, what is the policy for adding new lists to vger.kernel.org? If a
> > subsystem maintainer asks for a list named after a core kernel
> > subsystem, how frequently is it rejected, and on what basis?
> >
> > I find it sad that such an arbitrary looking negative decision from you
> > forces a user list away from vger. I wouldnt mind it to be closed if it
> > has no significant traffic after a year or lifetime or so - many vger
> > lists have almost no traffic to begin with.
> >
> > Also, i cannot help but to observe the fact that you've fought the 
> > original perfcounters project in a very ugly and public way less 
> > than a year ago. Dont you think that you 'deciding' this matter in 
> > such a negative fashion is a conflict of interest?
> >
> > ? ? ? ?Ingo
> 
> Yikes - Ingo, I don't want to spawn a long thread here about what to 
> call the list, but as a native English speaker, I think that 
> "linux-trace-users" sounds much nicer than "linux-tracing-users".

That argument i can and will accept of course ...

The "sorry, i ignored you twice and now it's unfortunately too late" 
excuse given by David i will not ;-)

Note that this mail you replied to was about 
linux-perf-users@vger.kernel.org, which David refused to create, 
suggesting that perf users should mail to 
linux-trace-users@vger.kernel.org instead. (which is a curious argument 
- if you use a tool named 'perf', or if you are using PAPI to count 
events, would it occur to you to mail to that list?)

	Ingo
