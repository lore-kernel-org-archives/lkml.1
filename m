Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbZCXPkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbZCXPkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZCXPjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:39:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZCXPjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:39:51 -0400
Date: Tue, 24 Mar 2009 16:38:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH][GIT PULL] function-graph: add option for include sleep
	times
Message-ID: <20090324153822.GB31143@elte.hu>
References: <20090324135422.026619569@goodmis.org> <20090324135610.441707783@goodmis.org> <20090324135833.GB32043@elte.hu> <alpine.DEB.2.00.0903241127290.22830@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903241127290.22830@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (1):
>       function-graph: add option for include sleep times
> 
> ----
>  kernel/trace/ftrace.c |    7 +++++++
>  kernel/trace/trace.c  |    3 ++-
>  kernel/trace/trace.h  |    1 +
>  3 files changed, 10 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
