Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZLOHfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZLOHfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZLOHfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:35:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZLOHe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:34:58 -0500
Date: Tue, 15 Dec 2009 08:34:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix return of trace_dump_stack()
Message-ID: <20091215073440.GA24014@elte.hu>
References: <20091211184018.738768739@goodmis.org>
 <20091214161257.GA20097@elte.hu>
 <20091214162713.GA31060@elte.hu>
 <1260827074.2146.424.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260827074.2146.424.camel@gandalf.stny.rr.com>
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

> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       tracing: Fix return of trace_dump_stack()
> 
> ----
>  include/linux/kernel.h |    1 +
>  kernel/trace/trace.c   |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
