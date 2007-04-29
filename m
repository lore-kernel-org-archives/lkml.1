Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbXD2KUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbXD2KUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXD2KUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:20:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:45951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755142AbXD2KUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:20:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jjOtyBYxjIMsDKfjTSjay27Wy669KIP0CsDnjWj
	2rjSN6rQNFh6xu
Subject: Re: [patch] CFS scheduler, -v6
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <200704291952.22840.kernel@kolivas.org>
References: <1177618164.14496.5.camel@localhost>
	 <20070429073819.GD23638@1wt.eu> <20070429080028.GA9988@elte.hu>
	 <200704291952.22840.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 12:19:51 +0200
Message-Id: <1177841991.8943.18.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 19:52 +1000, Con Kolivas wrote:
> On Sunday 29 April 2007 18:00, Ingo Molnar wrote:
> > * Willy Tarreau <w@1wt.eu> wrote:
> > > > > [...] except for Mike who has not tested recent versions. [...]
> > > >
> > > > actually, dont discount Mark Lord's test results either. And it
> > > > might be a good idea for Mike to re-test SD 0.46?
> > >
> > > In any case, it might be a good idea because Mike encountered a
> > > problem that nobody could reproduce. [...]
> >
> > actually, Mark Lord too reproduced something similar to Mike's results.
> > Please try those workloads yourself.
> 
> I see no suggestion that either Mark or Mike have tested, or for that matter 
> _have any intention of testing_, the current version of SD without fancy 
> renicing or anything involved. Willy I grealy appreciate you trying, but I 
> don't know why you're bothering even trying here since clearly 1. Ingo is the 
> scheduler maintainer 2. he's working on a competing implementation and 3. in 
> my excellent physical and mental state I seem to have slighted the two 
> testers (both?) somewhere along the line. Mike feels his testing was a 
> complete waste of time yet it would be ludicrous for me to say that SD didn't 
> evolve 20 versions further due to his earlier testing, and was the impetus 
> for you to start work on CFS. The crunch came that we couldn't agree that 
> fair was appropriate for mainline and we parted ways. That fairness has not 
> been a problem for his view on CFS though but he has only tested older 
> versions of SD that still had bugs.

The crunch for me came when you started hand-waving and spin-doctoring
as you are doing now.  Listening to twisted echoes of my voice is not my
idea of a good time.

	-Mike

