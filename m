Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZFEOwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZFEOwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZFEOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:52:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33286 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZFEOw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:52:27 -0400
Date: Fri, 5 Jun 2009 16:52:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIP PULL] tracing/events/trace_stack: various
	fixes
Message-ID: <20090605145219.GA14830@elte.hu>
References: <20090603151724.144915858@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603151724.144915858@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace-4 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-4
> 
> 
> Steven Rostedt (1):
>       tracing: add annotation to what type of stack trace is recorded
> 
> Steven Whitehouse (1):
>       tracing: fix multiple use of __print_flags and __print_symbolic
> 
> walimis (3):
>       tracing/trace_stack: fix the number of entries in the header
>       tracing/events: fix output format of kernel stack
>       tracing/events: fix output format of user stack
> 
> ----
>  include/trace/ftrace.h      |    2 ++
>  kernel/trace/trace_output.c |   35 ++++++++++++++++++-----------------
>  kernel/trace/trace_stack.c  |    2 +-
>  3 files changed, 21 insertions(+), 18 deletions(-)

Pulled, (including the previous branches), thanks a lot Steve!

	Ingo
