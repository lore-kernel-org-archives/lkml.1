Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab0CKMmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:42:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595Ab0CKMmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:42:19 -0500
Date: Thu, 11 Mar 2010 13:40:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4][GIT PULL] tracing: updates and fixes
Message-ID: <20100311124027.GF31354@elte.hu>
References: <20100306022140.320536991@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306022140.320536991@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
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
> Arnaldo Carvalho de Melo (1):
>       tracing: Update the comm field in the right variable in update_max_tr
> 
> Steven Rostedt (2):
>       function-graph: Fix unused reference to ftrace_set_func()
>       function-graph: Use comment notation for func names of dangling '}'
> 
> Tim Bird (1):
>       function-graph: Add tracing_thresh support to function_graph tracer
> 
> ----
>  kernel/trace/ftrace.c                |    6 ++----
>  kernel/trace/trace.c                 |   24 ++++++++++++++++++++----
>  kernel/trace/trace.h                 |    3 ++-
>  kernel/trace/trace_functions_graph.c |   27 ++++++++++++++++++++++++---
>  4 files changed, 48 insertions(+), 12 deletions(-)

Pulled, thanks Steve!

	Ingo
