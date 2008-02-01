Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYBAJll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYBAJll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbYBAJlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:41:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36713 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbYBAJlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:41:21 -0500
Date: Fri, 1 Feb 2008 10:40:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Valdis.Kletnieks@vt.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: using LKML for subsystem development
Message-ID: <20080201094057.GA27910@elte.hu>
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net> <479A75D4.6070607@s5r6.in-berlin.de> <479A8203.40804@s5r6.in-berlin.de> <20080126112820.GA10563@elte.hu> <479B42C4.7020507@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479B42C4.7020507@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(a late reply - the merge window made me ignore this thread ;-)

* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > (or if that's still too much, follow the time-deferred lkml updates 
> > of lwn.net)
> > 
> > Realize it: it's _far_ easier to filter down a too verbose source of 
> > information, than to put scattered, inaccessible pieces of 
> > information back together. It's far easier to get a cup of water 
> > from the open firehose than it is to gather the drops once they 
> > spilled on the ground.
> 
> Correct.

so you agree with me on this one? Even though you clearly do not realize 
it, you've in essence conceded my whole point.

The "off-lkml" practice makes us lose information, in a largely 
irreversible way - and that's the end of the argument. Q.E.D.

just let me show you an example of the conflict of logic in your 
argument:

> [ people ]
>
>   - who are afraid of subscribing to a high-volume mailinglist (even 
>     if they have the technical means at their disposal to manage that 
>     volume),

on one side you have people who are _willing_ to participate, who'd like 
to help out, who'd like to follow the development of Linux, but cannot 
for some areas because it's split into 150 small mailing lists with no 
coherent way to access and manage them.

on the other side you talk about people who are 'afraid' of 
participating in Linux development, even though "they have the technical 
means at their disposal to manage that volume". I.e., they "could" 
participate, but they "dont want to" - for time constraints or just 
excuses like "it's difficult to filter".

and your solution: you advocate destroying information by pulling it off 
lkml for the sake of the _second_ group of people? That's perverse.

all the other arguments you say are just totally immaterial. Yes, we 
could and should make lkml a better place (you could have volunteered to 
summarize lkml discussions of your favorite topic on a separate list, 
you could forward interesting topics to people you know dont read all of 
it, etc. etc.,) but your proposed solution of _destroying lkml_ by 
pulling off development into those lists is just about the most stupid 
solution a person could have come up with.

	Ingo
