Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZJXJIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZJXJIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 05:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZJXJIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 05:08:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbZJXJIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 05:08:22 -0400
Date: Sat, 24 Oct 2009 11:08:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: various fixes
Message-ID: <20091024090815.GA23846@elte.hu>
References: <20091023233615.661789185@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023233615.661789185@goodmis.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Jiri Olsa (4):
>       tracing: updating *ppos instead of filp->f_pos
>       tracing: fix trace_seq_printf return value
>       tracing: comment typo and documentation example fix
>       tracing: removing cpu arg from rb_time_stamp function
> 
> ----
>  Documentation/trace/ftrace.txt |    2 ++
>  include/linux/trace_seq.h      |    2 +-
>  kernel/trace/ftrace.c          |    2 +-
>  kernel/trace/ring_buffer.c     |   12 ++++++------
>  kernel/trace/trace.c           |    8 ++++----
>  kernel/trace/trace_output.c    |    5 ++++-
>  6 files changed, 18 insertions(+), 13 deletions(-)

Applied, thanks Steve!

	Ingo
