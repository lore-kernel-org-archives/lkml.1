Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbZHEHYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbZHEHYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbZHEHYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:24:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679AbZHEHYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:24:13 -0400
Date: Wed, 5 Aug 2009 09:24:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: various updates for tip
Message-ID: <20090805072404.GA19322@elte.hu>
References: <20090721014528.716901277@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721014528.716901277@goodmis.org>
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

> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Lai Jiangshan (1):
>       tracing/events: add missing type info of dynamic arrays
> 
> Li Zefan (2):
>       tracing/events: record the size of dynamic arrays
>       tracing/filters: improve subsystem filter
> 
> Xiao Guangrong (1):
>       tracing: cleanup for tracing_trace_options_read()
> 
> ----
>  include/linux/ftrace_event.h       |    4 +-
>  include/trace/ftrace.h             |   18 +++--
>  kernel/trace/trace.c               |    6 +-
>  kernel/trace/trace.h               |    3 +-
>  kernel/trace/trace_events_filter.c |  130 ++++++++++++++++++++++++------------
>  5 files changed, 104 insertions(+), 57 deletions(-)

Pulled, thanks Steve!

	Ingo
