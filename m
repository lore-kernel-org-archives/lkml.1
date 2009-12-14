Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbZLNQNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbZLNQNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbZLNQNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:13:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683AbZLNQNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:13:13 -0500
Date: Mon, 14 Dec 2009 17:12:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: stack tracing
Message-ID: <20091214161257.GA20097@elte.hu>
References: <20091211184018.738768739@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211184018.738768739@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.4
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.4 required=5.9 tests=BAYES_00,URG_BIZ autolearn=no SpamAssassin version=3.2.5
	1.6 URG_BIZ                BODY: Contains urgent matter
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I based this on top of my last tip/tracing/urgent request. These are 
> enhancements and not fixes. But since the merge window is still open and 
> these are very small patches, I figured we try to get them in for 2.6.33.
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Steven Rostedt (2):
>       tracing: Add trace_dump_stack()
>       tracing: Add stack trace to irqsoff tracer
> 
> ----
>  include/linux/kernel.h       |    2 ++
>  kernel/trace/trace.c         |   16 ++++++++++++++++
>  kernel/trace/trace_irqsoff.c |    2 ++
>  3 files changed, 20 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo
