Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbZHLJL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbZHLJL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbZHLJL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:11:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbZHLJL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:11:57 -0400
Date: Wed, 12 Aug 2009 11:11:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812091133.GA21655@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Ingo,
> 
> This pull request integrate one cleanup/fix for ftrace and an 
> update for syscall tracing: the migration from old-style tracer to 
> individual tracepoints/trace_events and the support for perf 
> counter.
> 
> I've tested it with success either with ftrace (every syscall 
> tracepoints enabled at the same time without problems) and with 
> perfcounter.
> 
> May be one drawback: it creates so much trace events that the 
> ftrace selftests can take some time :-)

Pulled, thanks a lot!

	Ingo
