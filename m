Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbXIQWKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbXIQWKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbXIQWJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:09:57 -0400
Received: from smtp2.rz.uni-karlsruhe.de ([129.13.185.218]:52437 "EHLO
	smtp2.rz.uni-karlsruhe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbXIQWJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:09:56 -0400
X-Greylist: delayed 1813 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 18:09:55 EDT
Date: Mon, 17 Sep 2007 23:39:40 +0200
From: Ingo Schwarze <schwarze@usta.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: misc@openbsd.org, linux-kernel@vger.kernel.org
Subject: Re: Wasting our Freedom
Message-ID: <20070917213939.GA21548@selene.usta.de>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070916231633.GB10339@SDF.LONESTAR.ORG> <Pine.LNX.4.64.0709161632500.24221@asgard.lang.hm> <20070917093011.GX32213@nudo.bsws.de> <20070917125714.GI18232@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917125714.GI18232@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote on Mon, Sep 17, 2007 at 02:57:14PM +0200:

> But stating in your licence that noone has to give back but then 
> complaining to some people on ethical grounds that they should give
> back is simply dishonest.
> 
> Is your intention to allow people to include your code into GPL'ed code 
> and never give back, or is your intention that this shouldn't happen?
> 
> And whatever your intention is should be stated in your licence.

As this is a recurring argument in the present discussion, let's
address it, even though it lies somewhat beside the main topic.
What i wish and what i try to enforce by legal contracts are two
completely different things.  In particular, it is _not_ a smart
idea to try to enforce all one's wishes by legal means.

For example, i wish that as much as possible of the code i write be
freely available such that others can use it, too, and i wish that
others write useful code and make it free such that i can use it.
When i publish code, i wish bugfixes to be fed back to me, and i
hope that others might free their derivative works, too.  Besides,
i might hope that people at large behave in human and rational ways
and refrain from doing harm to others.  In particular i might wish
the fruits of my work not to be abused to harm or oppress people.
Quite probably, lots of software developers share similar wishes,
whatever licenses they happen to be employing.

But this doesn't imply i should be putting any of the above into
the license for my code.  Once people attach additional conditions
to their licences, sooner or later i get stuck when trying to
combine different code covered by different licences.  However well
intentioned, in practice, those additional conditions habitually
turn out to be incompatible - even when, regarded seperately, all
of them might appear to make some sense.

Now doubtless, the two main additional conditions imposed by the GPL -
derivative works may only be distributed if they are made as open and
as free as the original - are among those making the most sense of all
the additional conditions you might imagine, in the sense that nearly
any developer of free software will wish that anybody holding the
copyright on a derivative work would make that free.  Still, when
trying to combine code with different licences, even the GPL at times
turns out to be a bother.  This does not only apply to the case of
non-free closed-source commercial code, but also to cases where
authors intended to make their code free, but, be it by inexperience
or because they failed to restrain themselves, unfortunately added
some uncommon condition to the license.  Combining such code with ISC
or BSD code is hardly ever problem, combining such code with GPL code
may well be.

Thus, even when wishing derivative works to be free in their turn,
i still see a strong theoretical and a strong practical argument to
choose the ISC license over the GPL: Theoretically, it's just the
categorical imperative: If everybody would be adding her or his
favorite condition to her or his license, we would not end up in
free software, but in chaos.  Practically, i'm quite fed up with
GPL license incompatibility issues always popping up at the most
inconvenient places, and still more, with all those license
compatibility discussions.  With the ISC license, there are no
incompatibility issues and no incompatibility discussions, it just
works.  Of course, i lose the option to sue people to open up
derivative works, but i keep the hope that some people (especially
those engaged in free software themselves) understand and keep up
the spirit, and above all, i avoid lots of legalese worries.
Ultimately, it's kind of a trade-off.

To summarize, there are valid reasons to wish that people would make
derivative works free, but to not require it in the license.  Just
like there are valid reasons to wish that people should not use the
code for waging war, but to not require that in the license.
