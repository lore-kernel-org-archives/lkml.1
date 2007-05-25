Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXEYK1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXEYK1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXEYK1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:27:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbXEYK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:27:10 -0400
Date: Fri, 25 May 2007 12:27:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525102657.GA12131@elte.hu>
References: <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525094640.GL8094@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> It's done slightly differently now due to conflicting earlier changes, 
> but the end result should be about what you intended.  You're also 
> still credited in the cleanup patch of course.

you totally misunderstood me. My problem isnt credit. I've got enough 
credit for a lifetime ;-) I'd be equally upset if this happened with 
someone else's patches (in fact i'd be _more_ upset about it, because 
then i'd also be worried about us losing a contributor).

My problem is that (and this might just be an issue of communication) 
you often appear as treating the x86_64 code as 'your code' instead of 
treating it as 'our code'. Dropping part of my patch, not even telling 
whether you took the patches or not, not reacting to patches in a 
positive way are all external signs of that.

	Ingo
