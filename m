Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbZIWTlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbZIWTlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZIWTll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:41:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39510 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZIWTlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:41:40 -0400
Date: Wed, 23 Sep 2009 21:41:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux@elte.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, acme@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090923194122.GB20934@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090922.153201.225375909.davem@davemloft.net> <20090923114823.GC4132@elte.hu> <20090923.111245.193724900.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923.111245.193724900.davem@davemloft.net>
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
> Date: Wed, 23 Sep 2009 13:48:23 +0200
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> >> From: Steven Rostedt <rostedt@goodmis.org>
> >> Date: Wed, 16 Sep 2009 16:16:22 -0400
> >> 
> >> > What are people's thoughts about creating a linux-trace-users 
> >> > mailing list on vger.kernel.org?
> >> 
> >> I've created this list.
> > 
> > btw., could you please change the name to linux-tracing-users? 
> > That's the name of the subsystem and the name of the activity as 
> > well. A 'trace' is just (one) end result of that activity.
> 
> No, the name is arbitrary and people are already propagating the 
> existience of the name that has been chosen already.
> 
> SOrry.

David, i have asked for the proper name _BEFORE_ you have created it, 
yesterday. I also asked you again today to change the name _minutes_ 
after you mailed about the sucky 'linux-trace-users@vger.kernel.org' 
name. You ignored all that.

I dont know about you, but the activity is 'tracing' not 'trace'. People 
mailing to that list want to talk about 'tracing' - not about a 'trace'. 
What is a 'trace user'? It makes no sense and is a misnomer.

The subsystem entry in MAINTAINERS clearly says:

TRACING
M:      Steven Rostedt <rostedt@goodmis.org>
M:      Frederic Weisbecker <fweisbec@gmail.com>
M:      Ingo Molnar <mingo@redhat.com>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
S:      Maintained

It's no secret that you and me dont get along too well and have been 
involved in a number of very public spats in the past year or so.

I do think your actions here are designed to hurt the tracing (and also 
the perf events) subsystems just because i'm co-maintaining them, and i 
think that you are in a heavy conflict of interest over it.

You should have recused yourself from this decision - i suspect there's 
other, less biased people outside of you who can create new mailing 
lists on vger.kernel.org. They might refuse my request with some real 
reason.

	Ingo
