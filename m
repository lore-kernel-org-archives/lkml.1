Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbZFLQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbZFLQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZFLQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:45:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZFLQpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:45:07 -0400
Date: Fri, 12 Jun 2009 18:45:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] kmemcheck for mainline
Message-ID: <20090612164503.GA23608@elte.hu>
References: <20090612132443.GA24002@damson.ad.medicalresearch.no> <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 12 Jun 2009, Vegard Nossum wrote:
> > 
> > Please consider pulling the kmemcheck tree;
> 
> No.
> 
> This seems to be 99% merges o fother branches.
> 
> I'm no longer pulling from people who can't keep their branches 
> clean and develop without pulling from me every other day, or 
> pulling from other random branches. If it gets that many 
> conflicts, I just don't want to see it - there's something 
> seriously wrong with it.
> 
> And if you just merge for some random reason, I don't want to pull 
> it either.
> 
> So in either case, I'm not pulling this.
> 
> Just _look_ at that gitk thing. It has several stretches of just 
> "Merge branch 'linus' into kmemcheck". WITH NO OTHER DEVELOPMENT 
> IN BETWEEN!

This is an ancient one year old tree :-/

Vegard, i suspect you are best off by creating a clean, rebased 
(same-content) series linear tree out of the patches - with all 
fixes backmerged and there being a good logical order of patches.

Since it will be same-content it should be doable in short order. I 
can do it too if you dont have the time.

	Ingo
