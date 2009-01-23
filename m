Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbZAWKJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbZAWKJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZAWKJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:09:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZAWKJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:09:32 -0500
Date: Fri, 23 Jan 2009 11:09:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] ftrace: updates for tip
Message-ID: <20090123100920.GB15188@elte.hu>
References: <20090122202030.210768976@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122202030.210768976@goodmis.org>
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
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (2):
>       trace: remove internal irqsoff disabling for trace output
>       trace: fix logic to start/stop counting
> 
> ----
>  kernel/trace/trace.c         |   13 ++++++-------
>  kernel/trace/trace_irqsoff.c |   34 ++--------------------------------
>  2 files changed, 8 insertions(+), 39 deletions(-)

Pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
