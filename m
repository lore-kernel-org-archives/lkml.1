Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbYD0HRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbYD0HRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYD0HRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:17:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYD0HRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:17:11 -0400
Date: Sun, 27 Apr 2008 09:16:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch] ftrace, v15
Message-ID: <20080427071659.GA13036@elte.hu>
References: <20080427063019.GA23295@elte.hu> <20080426.233240.252075490.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.233240.252075490.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0087]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 27 Apr 2008 08:30:19 +0200
> 
> >       sched: fix rq->clock overflows detection with CONFIG_NO_HZ
> >       sched: make sure jiffies is up to date before calling __update_rq_clock()
> 
> You're getting sloppier and sloppier each and every bogus pull request 
> you send out this week Ingo.

this is not a pull request David ...

> What is all of this non-ftrace crap in the shortlog?

other changes in my tree ...

	Ingo
