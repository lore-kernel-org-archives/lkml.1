Return-Path: <linux-kernel-owner+w=401wt.eu-S1763082AbZCQJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763082AbZCQJh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZCQJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:37:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZCQJhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:37:17 -0400
Date: Tue, 17 Mar 2009 10:36:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] update for tip/tracing/ftrace
Message-ID: <20090317093659.GC6477@elte.hu>
References: <20090317034820.400357912@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317034820.400357912@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Frederic Weisbecker (1):
>       tracing/ftrace: fix the check on nopped sites
> 
> Steven Rostedt (2):
>       tracing: protect reader of cmdline output
>       tracing: stop comm recording on tracing off
> 
> ----
>  kernel/trace/blktrace.c              |   23 ++++++++++++++++++-----
>  kernel/trace/ftrace.c                |    2 +-
>  kernel/trace/trace.c                 |   22 +++++++++++++---------
>  kernel/trace/trace.h                 |    2 +-
>  kernel/trace/trace_functions_graph.c |   12 ++++++------
>  kernel/trace/trace_output.c          |   18 ++++++++++++------
>  6 files changed, 51 insertions(+), 28 deletions(-)

Pulled, thanks Steve!

	Ingo
