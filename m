Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZLVHTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZLVHTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 02:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZLVHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 02:19:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZLVHTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 02:19:45 -0500
Date: Tue, 22 Dec 2009 08:19:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix setting tracer specific options
Message-ID: <20091222071937.GA26467@elte.hu>
References: <1261454404.25193.471.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261454404.25193.471.camel@gandalf.stny.rr.com>
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

> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       tracing: Fix setting tracer specific options
> 
> ----
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
