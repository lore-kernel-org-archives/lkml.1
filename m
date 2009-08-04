Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbZHDIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbZHDIJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbZHDIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:09:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbZHDIJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:09:19 -0400
Date: Tue, 4 Aug 2009 10:09:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] trace: stop tracer in oops_enter()
Message-ID: <20090804080903.GC18635@elte.hu>
References: <alpine.DEB.2.00.0907241533540.29550@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907241533540.29550@gandalf.stny.rr.com>
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

> Ingo or Thomas,
> 
> This is on top of the previous pull requests I made for 31.
> 
> Please pull the latest tip/tracing/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent-2
> 
> 
> Thomas Gleixner (1):
>       trace: stop tracer in oops_enter()
> 
> ----
>  kernel/panic.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo
