Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZIPTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZIPTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZIPTRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:17:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbZIPTRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:17:10 -0400
Date: Wed, 16 Sep 2009 21:17:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: more update for 2.6.32
Message-ID: <20090916191700.GA29072@elte.hu>
References: <20090916185546.986682049@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916185546.986682049@goodmis.org>
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
> These patches are still for v2.6.32. They fix bugs and add documentation.
> Including the patches in core, core2, and core3, which this is built upon.
> 
> Please pull the latest tip/tracing/core4 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core4
> 
> 
> Atsushi Tsuji (1):
>       tracing: Fix minor bugs for __unregister_ftrace_function_probe
> 
> Steven Rostedt (1):
>       tracing: remove notrace from __kprobes annotation
> 
> ----
>  include/linux/kprobes.h |    4 ++--
>  kernel/trace/ftrace.c   |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Pulled, thanks Steve!

	Ingo
