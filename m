Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab0BPVGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:06:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab0BPVGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:06:34 -0500
Date: Tue, 16 Feb 2010 22:06:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3][GIT PULL][v2.6.34] tracing: updates
Message-ID: <20100216210623.GC9051@elte.hu>
References: <20100216164122.891864374@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216164122.891864374@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
> Li Zefan (1):
>       ftrace: Allow to remove a single function from function graph filter
> 
> Steven Rostedt (2):
>       tracing: Add correct/incorrect to sort keys for branch annotation output
>       tracing: Add notrace to TRACE_EVENT implementation functions
> 
> ----
>  include/trace/ftrace.h      |   31 +++++++++++++++-----------
>  kernel/trace/ftrace.c       |   51 ++++++++++++++++++++++++++----------------
>  kernel/trace/trace.h        |    3 +-
>  kernel/trace/trace_branch.c |   19 ++++++++++++++-
>  4 files changed, 68 insertions(+), 36 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
