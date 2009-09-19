Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbZISRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbZISRV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZISRVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:21:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZISRVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:21:25 -0400
Date: Sat, 19 Sep 2009 19:21:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: cleanups for 2.6.32
Message-ID: <20090919172123.GC5366@elte.hu>
References: <20090919155203.005861436@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919155203.005861436@goodmis.org>
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
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Li Zefan (3):
>       function-graph: use ftrace_graph_funcs directly
>       tracing: remove max_tracer_type_len
>       tracing/events: use list_for_entry_continue
> 
> ----
>  kernel/trace/ftrace.c       |   23 +++----------------
>  kernel/trace/trace.c        |   49 ++++++++++++++-----------------------------
>  kernel/trace/trace_events.c |   49 +++++++++++++-----------------------------
>  3 files changed, 35 insertions(+), 86 deletions(-)

Pulled into tracing/urgent, thanks Steve!

	Ingo
