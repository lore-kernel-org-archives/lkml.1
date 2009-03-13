Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZCMFav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZCMFav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZCMFaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:30:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZCMFaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:30:39 -0400
Date: Fri, 13 Mar 2009 06:30:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/4] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090313053019.GB20562@elte.hu>
References: <20090313050446.277065036@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313050446.277065036@goodmis.org>
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
> Steven Rostedt (4):
>       tracing: left align location header in stack_trace
>       tracing: add comment for use of double __builtin_consant_p
>       tracing: move binary buffers into per cpu directory
>       softirq: no need to have SOFTIRQ in softirq name
> 
> ----
>  kernel/softirq.c           |    5 ++---
>  kernel/trace/trace.c       |   26 +++++---------------------
>  kernel/trace/trace.h       |    5 +++++
>  kernel/trace/trace_stack.c |    4 ++--
>  4 files changed, 14 insertions(+), 26 deletions(-)

Pulled, thanks Steve!

	Ingo
