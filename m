Return-Path: <linux-kernel-owner+w=401wt.eu-S966343AbXEKUBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966343AbXEKUBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760406AbXEKUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:01:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53300 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbXEKUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:01:45 -0400
Date: Fri, 11 May 2007 22:01:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spelling fixes: kernel/
Message-ID: <20070511200125.GA6235@elte.hu>
References: <4644C79D.40803@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4644C79D.40803@simon.arlott.org.uk>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Arlott <simon@fire.lp0.eu> wrote:

> kernel/sched.c            |   20 ++++++++++----------

> --- a/kernel/sched.c
> +++ b/kernel/sched.c

>  * This is how migration works:
>  *
> - * 1) we queue a struct migration_req structure in the source CPU's
> - *    runqueue and wake up that CPU's migration thread.
> + * 1) we queue a struct migration_req structure in the source CPUs
> + *    runqueue and wake up that CPUs migration thread.

the original is correct - this is a possessive form.

> - * their home CPUs. So we just add the counter to another CPU's counter,
> + * their home CPUs. So we just add the counter to another CPUs counter,

ditto.

all the other spelling fixes to sched.c are fine, thanks!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
