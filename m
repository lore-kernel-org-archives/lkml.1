Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYJVJoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYJVJoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYJVJkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:40:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbYJVJkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:40:42 -0400
Date: Wed, 22 Oct 2008 11:40:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/4] pending scheduler updates
Message-ID: <20081022094019.GG12453@elte.hu>
References: <20081017172701.047939625@chello.nl> <20081020120538.GD10594@elte.hu> <20081021173529.GG11679@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021173529.GG11679@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Mon, Oct 20, 2008 at 02:05:38PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > Please apply
> > 
> > applied these to tip/sched/urgent:
> > 
> >  f9c0b09: sched: revert back to per-rq vruntime
> >  a4c2f00: sched: fair scheduler should not resched rt tasks
> >  ffda12a: sched: optimize group load balancer
> > 
> > (will wait with 4/4 until you and Mike come to a verdict.)
> 
> Is there any conclusion on Patch 4/4? It looks sane to me!

Mike?

	Ingo
