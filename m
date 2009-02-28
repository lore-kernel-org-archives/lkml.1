Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZB1JTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZB1JTD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZB1JSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:18:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbZB1JSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:18:42 -0500
Date: Sat, 28 Feb 2009 10:17:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net
Subject: Re: [PATCH 00/10] [git pull] for tip/tracing/ftrace
Message-ID: <20090228091735.GC20533@elte.hu>
References: <20090228090646.265765024@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228090646.265765024@goodmis.org>
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
> Steven Rostedt (10):
>       tracing: move trace point formats to files in include/trace directory
>       tracing: add subsystem level to trace events
>       tracing: make the set_event and available_events subsystem aware
>       tracing: add subsystem irq for irq events
>       tracing: add subsystem sched for sched events
>       tracing: add interface to write into current tracer buffer
>       tracing: add raw trace point recording infrastructure
>       tracing: add raw fast tracing interface for trace events
>       tracing: create the C style tracing for the sched subsystem
>       tracing: create the C style tracing for the irq subsystem

Great stuff!

Pulled into tip:tracing/ftrace, thanks Steve!

	Ingo
