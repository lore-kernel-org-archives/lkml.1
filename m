Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZHFMWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZHFMWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZHFMWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:22:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZHFMWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:22:00 -0400
Date: Thu, 6 Aug 2009 14:21:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL][2.6.31] ring-buffer/tracing: various
	fixes
Message-ID: <20090806122132.GA13995@elte.hu>
References: <20090806025206.306150861@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806025206.306150861@goodmis.org>
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
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (3):
>       ring-buffer: fix check of try_to_discard result
>       ring-buffer: do not disable ring buffer on oops_in_progress
>       tracing: do not use functions starting with .L in recordmcount.pl
> 
> ----
>  kernel/trace/ring_buffer.c |    4 ++--
>  scripts/recordmcount.pl    |    5 ++++-
>  2 files changed, 6 insertions(+), 3 deletions(-)

Pulled, thanks Steve!

	Ingo
