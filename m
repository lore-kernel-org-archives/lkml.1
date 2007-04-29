Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXD2IEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXD2IEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbXD2IEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:04:36 -0400
Received: from 1wt.eu ([62.212.114.60]:2375 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXD2IEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:04:35 -0400
Date: Sun, 29 Apr 2007 10:02:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429080250.GF23638@1wt.eu>
References: <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429073030.GA5253@elte.hu> <20070429073819.GD23638@1wt.eu> <20070429080028.GA9988@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429080028.GA9988@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 10:00:28AM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > > > [...] except for Mike who has not tested recent versions. [...]
> > > 
> > > actually, dont discount Mark Lord's test results either. And it 
> > > might be a good idea for Mike to re-test SD 0.46?
> > 
> > In any case, it might be a good idea because Mike encountered a 
> > problem that nobody could reproduce. [...]
> 
> actually, Mark Lord too reproduced something similar to Mike's results. 

OK.

> Please try those workloads yourself.

Unfortunately, I do not have their tools, environments nor hardware.
That's the advantage of having multiple testers ;-)

> 	Ingo

Willy

