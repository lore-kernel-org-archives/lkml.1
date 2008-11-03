Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYKCH7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYKCH7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYKCH70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:59:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbYKCH70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:59:26 -0500
Date: Mon, 3 Nov 2008 08:59:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: trace sched.c
Message-ID: <20081103075916.GE13727@elte.hu>
References: <alpine.DEB.1.10.0810311122540.20404@gandalf.stny.rr.com> <1225494829.21456.19.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225494829.21456.19.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> 
> Subject: ftrace: trace sched.c
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Oct 31 16:32:54 CET 2008
> 
> Its useful to see what happens in sched.c
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/Makefile |    1 -
>  1 file changed, 1 deletion(-)

applied to tip/sched/core, thanks!

	Ingo
