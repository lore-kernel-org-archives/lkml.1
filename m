Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbZKYIDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbZKYIDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934552AbZKYIDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:03:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934515AbZKYIDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:03:49 -0500
Date: Wed, 25 Nov 2009 09:03:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: rebase of TRACE_EVENT_TEMPLATE
Message-ID: <20091125080342.GA20495@elte.hu>
References: <20091125043811.603607335@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125043811.603607335@goodmis.org>
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

> 
> Ingo,
> 
> This is the rebase to resolve the conflicts with perf.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (3):
>       tracing: Create new TRACE_EVENT_TEMPLATE
>       tracing: Create new DEFINE_EVENT_PRINT
>       tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT
> 
> ----
>  include/linux/tracepoint.h   |    6 +
>  include/trace/define_trace.h |   11 ++
>  include/trace/events/sched.h |  170 ++++++++-------------------
>  include/trace/ftrace.h       |  266 +++++++++++++++++++++++++++++++++++-------
>  4 files changed, 292 insertions(+), 161 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
