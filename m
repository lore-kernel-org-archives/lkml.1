Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbZJHNgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbZJHNgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZJHNgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:36:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40938 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbZJHNgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:36:05 -0400
Date: Thu, 8 Oct 2009 15:35:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] [GIT PULL][for 2.6.32] tracing: some more fixes
Message-ID: <20091008133515.GA8938@elte.hu>
References: <20091008020625.084181867@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008020625.084181867@goodmis.org>
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
> Please pull the latest tip/tracing/urgent2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent2
> 
> 
> Steven Rostedt (1):
>       tracing: user local buffer variable for trace branch tracer
> 
> Zhenwen Xu (1):
>       tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c
> 
> ----
>  kernel/trace/trace_branch.c      |    8 +++++---
>  kernel/trace/trace_hw_branches.c |    8 +++++---
>  2 files changed, 10 insertions(+), 6 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
