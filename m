Return-Path: <linux-kernel-owner+w=401wt.eu-S1423660AbXD3S5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423660AbXD3S5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423673AbXD3S5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:57:38 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33601 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423660AbXD3S5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:57:36 -0400
Date: Mon, 30 Apr 2007 20:57:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430185747.GF23336@stusta.de>
References: <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org> <20070429210505.GS3468@stusta.de> <alpine.LFD.0.98.0704291419310.9964@woody.linux-foundation.org> <20070430180952.GC23336@stusta.de> <alpine.LFD.0.98.0704301113240.3419@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704301113240.3419@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:20:46AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Apr 2007, Adrian Bunk wrote:
> > 
> > My ideal was always that reported bugs should be fixed.
> 
> ..and this is where we differ.
> 
> OF COURSE bugs should be fixed. But you seem to think that there is 
> something magical and special about every single bug-report.
> 
> You have a new home assignment: watch the "every sperm is sacred" thing 
> from Monty Python's "Meaning of Life". Google for it.

I like the Flying Circus and the other Monty Python films (including 
"The Crimson Permanent Assurance"), but "Meaning of Life" didn't impress 
me. But I have the song somewhere if this counts.  ;-)

> And if you cannot appreciate the absurdity and humor of that thing, maybe 
> you should think about it a bit more.
> 
> And once you _can_ appreciate the humor of that song/skit, look yourself 
> in the mirror, and ask yourself: "is every bug report sacred?"
> 
> Really?
> 
> > If you accept that this is anyway impossible because more bugs get added 
> > than could get fixed you might not need any tracking at all.
> 
> That's a TOTALLY IDIOTIC argument.
> 
> That goes from "every sperm is sacred" to "sperm doesn't count at all".
> 
> Can you not see how stupid that statement of yours really is? Can you not 
> see that anybody who thinks in those kinds of black-and-white terms is 
> simply not FUNCTIONAL!
> 
> Bugs are neither sacred, _nor_ should they be ignored. 
> 
> Ponder that, grasshopper. And until you can see that things are not 
> "either-or", "black-and-white", "all or nothing", I don't think I really 
> can have anything worthwhile to add in this discussion to you. People who 
> think in absolutes are simply not worth talking to.

I never expected the reality to be come as white as my ideal or the 
washed things in washing powder ads.

My ideal was white, and the shade of grey of the current reality is 
darker than I think it should be.

At least theoretically reachable are things like:
- every incoming bug report is quickly handled by one or more
  kernel developers who know the drivers and subsystems involved
- there's a last -rc kernel published for a few days of testing,
  and except for the Makefile change the -final is identically to it
  (or a new -rc published)

There are sometimes nonsensical bug reports and "handling" could be 
rejecting a bug e.g. due to a tainted kernel.

And sometimes mysterious bugs are more or less undebuggable.

But these two points would have resulted in 2.6.21 being released more 
or less at the same time, but with a dozen regressions less.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

