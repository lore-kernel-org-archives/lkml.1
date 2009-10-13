Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbZJMKFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbZJMKFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbZJMKFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:05:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933748AbZJMKFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:05:12 -0400
Date: Tue, 13 Oct 2009 12:04:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/core updates
Message-ID: <20091013100410.GC26846@elte.hu>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
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

> Ingo,
> 
> Please pull the tracing/core branch that can be found at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>       tracing: Rename set_ftrace to set_bootup_ftrace
>       tracing: Remove unused ftrace_trace_addr helper
> 
> Stefan Assmann (1):
>       ftrace: add kernel command line graph function filtering
> 
>  Documentation/kernel-parameters.txt |    7 +++++++
>  kernel/trace/ftrace.c               |   34 ++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                |    4 ++--
>  kernel/trace/trace.h                |    4 ----
>  4 files changed, 43 insertions(+), 6 deletions(-)

Pulled, thanks Frederic!

	Ingo
