Return-Path: <linux-kernel-owner+w=401wt.eu-S1031071AbXDQEBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031071AbXDQEBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031072AbXDQEBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:01:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:46397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031071AbXDQEBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:01:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18uRUJW4GAu3SLyTCHALvsEC3cE96YVeZnktGz8lB
	lQGfpNKk94jsUt
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070417034050.GD25513@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu>
	 <200704151327.13589.kernel@kolivas.org>
	 <1176619384.6222.70.camel@Homer.simpson.net>
	 <46240F98.3020800@bigpond.net.au>
	 <1176776941.6222.21.camel@Homer.simpson.net>
	 <20070417034050.GD25513@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 06:01:29 +0200
Message-Id: <1176782489.13059.15.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 05:40 +0200, Nick Piggin wrote:
> On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
 
> > Yup, and progress _is_ happening now, quite rapidly.
> 
> Progress as in progress on Ingo's scheduler. I still don't know how we'd
> decide when to replace the mainline scheduler or with what.
> 
> I don't think we can say Ingo's is better than the alternatives, can we?

No, that would require massive performance testing of all alternatives.

> If there is some kind of bakeoff, then I'd like one of Con's designs to
> be involved, and mine, and Peter's...

The trouble with a bakeoff is that it's pretty darn hard to get people
to test in the first place, and then comes weighting the subjective and
hard performance numbers.  If they're close in numbers, do you go with
the one which starts the least flamewars or what?

> Maybe the progress is that more key people are becoming open to the idea
> of changing the scheduler.

Could be.  All was quiet for quite a while, but when RSDL showed up, it
aroused enough interest to show that scheduling woes is on folks radar.

	-Mike

