Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXDOJHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXDOJHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXDOJHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:07:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57869 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbXDOJHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:07:13 -0400
Date: Sun, 15 Apr 2007 11:06:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415090616.GF24886@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <20070415083616.GA29878@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415083616.GA29878@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> On Sun, Apr 15, 2007 at 08:43:04AM +0200, Mike Galbraith wrote:
> > [...]
> > 
> > Demystify what?  The casual observer need only read either your 
> > attempt
> 
> Here's the problem. You're a casual observer and obviously not paying 
> attention.

guys, please calm down. Judging by the number of contributions to 
sched.c the main folks who are not 'observers' here and who thus have an 
unalienable right to be involved in a nasty flamewar about scheduler 
interactivity are Con, Mike, Nick and me ;-) Everyone else is just a 
happy bystander, ok? ;-)

	Ingo
