Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZIWRAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZIWRAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIWRAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:00:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57248 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZIWRAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:00:47 -0400
Date: Wed, 23 Sep 2009 19:00:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, acme@redhat.com,
       tglx@linutronix.de, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090923170033.GA7410@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090922.153201.225375909.davem@davemloft.net> <20090923114725.GB4132@elte.hu> <4ABA50C2.6080607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA50C2.6080607@redhat.com>
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
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> >> From: Steven Rostedt <rostedt@goodmis.org>
> >> Date: Wed, 16 Sep 2009 16:16:22 -0400
> >>
> >>> What are people's thoughts about creating a linux-trace-users mailing
> >>> list on vger.kernel.org?
> >>
> >> I've created this list.
> > 
> > Could you please also create the linux-perf-users list, for perf events 
> > and the perf tool related user questions? (We have asked for this before 
> > but must have gotten lost somewhere)
> 
> I thought perf users also talk on the linux tracing list.

No, there's a lot of non-tracing aspects of performance events. It does 
profiling, counting, latency analysis, etc.

> What will linux-tracing-users cover, only ftrace?

It would cover whenever users want to talk about tracing.

	Ingo
