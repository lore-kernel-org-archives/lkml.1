Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbZHHP0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbZHHP0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZHHP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:26:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZHHP0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:26:42 -0400
Date: Sat, 8 Aug 2009 17:26:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing/ksys_tracer: misc fixes
Message-ID: <20090808152608.GG28892@elte.hu>
References: <20090724021403.694891838@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724021403.694891838@goodmis.org>
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
> Please pull the latest tip/tracing/hw-breakpoints tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/hw-breakpoints
> 
> 
> Xiao Guangrong (3):
>       tracing/ksym_tracer: fix the output of ksym tracer
>       tracing/ksym_tracer: fix write operation of ksym_trace_filter
>       tracing/ksym_tracer: support quick clear for ksym_trace_filter -- v2
> 
> ----
>  kernel/trace/trace_ksym.c |   70 +++++++++++++++++++++++++++++----------------
>  1 files changed, 45 insertions(+), 25 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
