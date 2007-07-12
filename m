Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbXGLNLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbXGLNLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763795AbXGLNLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:11:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759011AbXGLNLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:11:06 -0400
Date: Thu, 12 Jul 2007 15:09:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: pwil3058@bigpond.net.au, jim.houston@ccur.com, joe.korty@ccur.com,
       rostedt@goodmis.org, tglx@linutronix.de, dwalker@mvista.com,
       David Bahi <DBahi@novell.com>, Moiz Kohari <MKohari@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, dsaxena@plexity.net,
       williams@redhat.com, abogani@texware.it, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
Message-ID: <20070712130958.GB17494@elte.hu>
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4695E5BB0200005A0002763E@mcclure.wal.novell.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> On Thu, 2007-07-12 at 14:07 +0200, Ingo Molnar wrote:
> > * Gregory Haskins <ghaskins@novell.com> wrote:
> > 
> > > Hi Ingo, Thomas, and the greater linux-rt community,
> > >   
> > > 	I just wanted to let you guys know that our team has a port of 
> > > the 21.5-rt20 patch for the 2.6.22 kernel available. [...]
> > 
> > great! We had the upstream -rt port to .22 in the works too, it was just 
> > held up by the hpet breakage - which Thomas managed to fix earlier 
> > today. I've released the 2.6.22.1-rt1 patch to the usual place:
> > 
> >     http://redhat.com/~mingo/realtime-preempt/
> 
> Thats awesome, Ingo!  Thanks!  Could you publish a broken out version 
> as well?  We found it extremely valuable to be able to bisect this 
> beast while working on the 21-22 port.

we are working on something in this area :) Stay tuned ...

	Ingo
