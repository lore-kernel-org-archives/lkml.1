Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZB0IJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZB0IJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZB0IJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:09:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbZB0IJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:09:14 -0500
Date: Fri, 27 Feb 2009 09:08:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [git pull] for tip/tracing/ftrace
Message-ID: <20090227080852.GA3609@elte.hu>
References: <20090227053410.928389664@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227053410.928389664@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
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
> Steven Rostedt (5):
>       tracing: add options directory and core option files
>       tracing: add tracer dependent options to options directory
>       tracing: add protection around open use of current_tracer
>       tracing: use pointer error returns for __tracing_open
>       tracing: use newline separator for trace options list
> 
> ----
>  kernel/trace/trace.c |  368 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 333 insertions(+), 35 deletions(-)

Pulled into tip:tracing/ftrace, thanks Steve!

	Ingo
