Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZIWUIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZIWUIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZIWUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:08:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZIWUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:08:08 -0400
Date: Wed, 23 Sep 2009 22:07:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, acme@redhat.com,
       tglx@linutronix.de, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090923200747.GA2169@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090922.153201.225375909.davem@davemloft.net> <20090923114725.GB4132@elte.hu> <4ABA50C2.6080607@redhat.com> <20090923170033.GA7410@elte.hu> <4ABA63C9.9060708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA63C9.9060708@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
> >>>>> What are people's thoughts about creating a linux-trace-users mailing
> >>>>> list on vger.kernel.org?
> >>>>
> >>>> I've created this list.
> >>>
> >>> Could you please also create the linux-perf-users list, for perf events 
> >>> and the perf tool related user questions? (We have asked for this before 
> >>> but must have gotten lost somewhere)
> >>
> >> I thought perf users also talk on the linux tracing list.
> > 
> > No, there's a lot of non-tracing aspects of performance events. It does 
> > profiling, counting, latency analysis, etc.
> 
> So, will it include topics about oprofile,readprof too?

Both oprofile and readprof are obsolete.

> >> What will linux-tracing-users cover, only ftrace?
> > 
> > It would cover whenever users want to talk about tracing.
> 
> Hmm, in that case, on which list should I ask 'how can I
> use perf-trace?' and 'how can I use perf-record'? :-)
> Maybe I'm just a bit confusing ...

Which list do you use if you want to ask about why a networked app 
schedules too much? lkml or netdev? Both if you want to reach everyone 
who is interested.

Note, perf trace is one out of 9 'perf' sub-commands. I dont think it's 
appropriate to name the list after that one subcommand ...

For your question i'd suggest to Cc: both. It might be relevant to the 
tracing engine, or it might be a perf events or perf tool detail.

	Ingo
