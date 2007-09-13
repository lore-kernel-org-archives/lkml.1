Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbXIMHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbXIMHxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXIMHxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:53:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXIMHxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:53:08 -0400
Date: Thu, 13 Sep 2007 09:52:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913075258.GA9173@elte.hu>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709120242040.1817@scrub.home>
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


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> Out of curiousity: will I ever get answers to my questions?

the last few weeks/months have been pretty hectic - i get more than 50 
non-list emails a day so i could easily have missed some. (and to take a 
line from Linus: my attention span is roughly that of a slightly 
retarded golden retriever ;)

so it would be helpful if you could please re-state any questions you 
still have, in context of our latest CFS-devel queue. I tried to answer 
the error/rounding worries you had - which seemed to be the main theme 
of your patch. There are lots of good kernel hackers on lkml who know 
the new scheduler code pretty well and who might be able to provide an 
answer even if i dont manage to answer. (Perhaps asking the questions 
without heavy math will also help more people be able to understand and 
answer your questions and their practical relevance.) In any case - if 
you see packet loss on my side then please resend :) That would be 
hugely helpful. Thanks,

	Ingo
