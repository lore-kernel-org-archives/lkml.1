Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZEVIA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZEVIA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZEVIAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:00:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZEVIAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:00:50 -0400
Date: Fri, 22 May 2009 10:00:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/events: show task comms
Message-ID: <20090522080038.GA11438@elte.hu>
References: <20090521141813.123165156@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521141813.123165156@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This is on top of the changes that I posted yesterday (ftrace-1), but
> in its own branch.
> 
> Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-2
> 
> 
> Zhaolei (2):
>       ftrace: Add task_comm support for trace_event
>       ftrace: clean up of using ftrace_event_enable_disable()
> 
> ----
>  kernel/trace/trace_events.c |   42 ++++++++++++++++--------------------------
>  1 files changed, 16 insertions(+), 26 deletions(-)

Pulled, thanks Steve!

	Ingo
