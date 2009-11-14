Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZKNJj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZKNJj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZKNJj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:39:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46485 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbZKNJj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:39:27 -0500
Date: Sat, 14 Nov 2009 10:39:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing: Fix event format export
Message-ID: <20091114093915.GE10969@elte.hu>
References: <1258115870.6167.4.camel@johannes.local>
 <20091113224009.GB23942@elte.hu>
 <1258171964.22249.234.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258171964.22249.234.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
> Johannes Berg (1):
>       tracing: Fix event format export
> 
> ----
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
