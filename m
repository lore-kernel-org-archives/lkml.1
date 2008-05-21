Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbYEUWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbYEUWDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbYEUWDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:03:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59440 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYEUWDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:03:30 -0400
Date: Wed, 21 May 2008 23:03:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, tytso@mit.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: CFD: linux-wanking@vger.kernel.org
Message-ID: <20080521220301.GQ28946@ZenIV.linux.org.uk>
References: <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu> <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521.124954.193695735.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521.124954.193695735.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:49:54PM -0700, David Miller wrote:

> It's only a half-story to talk about future contributors when current
> trends on this list are making things bad for existing folks doing
> useful work.
> 
> You make it sound like it's this one sided story where we have to be
> all nicey nicey to everybody so that new contributors aren't discouraged,
> and that's where it ends.
> 
> But we're currently encouraging a society of bottom feeders.  And
> bottom feeders, although erroneously perceived as being good for the
> fish tank, actually end up making the tank more dirty in the end.
> So this is a trend we have to reverse now.

Sigh...  <mode=Andrew> Let me make it clear that Davem is not speaking for
me </mode>.

It's NOT about personalities of people submitting patches.  I don't know
them and I absolutely do not believe that either personality per se or
expected future behaviour can be derived from the fact of having sent this
kind of junk.

So "bottom-feeders" is IMO uncalled for - it presumes far more personal
and permanent features that simply are not in evidence.

Moreover, I'm less concerned about demoralizing effects of any description on
the existing developers.  Sure, that stuff is annoying, but it takes more than
that to really screw us.

I *am* concerned about new contributors.  Especially ones doing janitor-style
work, and yes, it's a great way to get started and it's very much needed.
What I've been seeing during the last months is continued devaluation of
such work in general.  By mixing really worthwhile things with more and more
pointless ones in the same bag and by trends that make the low-end side of
that more visible at the expense of those newbies who actually do something.
I'll abstain from naming names, since I rather doubt that anyone would
appreciate being brought into this flamefest in any capacity, let alone as
an exhibit of what one _should_ do in opinion of some participants, but
we still get new people who move on to doing sane work.

Look at that as a dynamic system.  Most of us do different kinds of work -
a mix of various tree- or subsystem-wide janitorial stuff, diving into
isolated drivers, API cleanups, bug hunting of various kinds, regression
tracking, development of new code, be it individual drivers or new features
in subsystems, etc.  The mix varies from person to person and from week
to week.  Right?  Maintaining subsystems is just one more thing in the
mix - it's not something inherently special or permanent, BTW.

We all keep moving on to some extent; what matters is the dynamics of that.
At some point things get interesting enough to encourage one to keep going -
and to go for non-trivial work, simply because one stumbles across the
things that need to be done, because one gets a neat idea and knows enough
to start making it work, because one runs into things that are challenging
enough to make it tempting to pull them off and see what else becomes
possible.  That's the steady state.

Again, that applies to newbies as well as those who'd been at that for
more than a decade.  Hell, for more than a decade and half, while we
are at it.  And we need more people entering and staying in that state -
I hope everyone agrees with that.

Now look at what's outside that area; for one thing, there are all kinds
of burnouts.  Some are handled by changing the area, with or without
pyrotechnical effects; some end up with developer simply walking away.
Some simply switch to lower and lower activity levels without anything
burnout-like and fade away, completely or not.

On the other end there are folks who hadn't entered the aforementioned
steady state yet, but are interested in trying to do something.  And
*that* is where we have a growing mess that scares the living hell out
of me.  We are getting another self-contained area.  Namely, "pick a
pointless mechanical work out of ever-growing pile, do it, learn nothing,
pick more, maybe look into finding new classes of such mindless stuff".
Of course it always had been there; what changes is that now it's not
just a transient state one might hit on the way in to be slightly embarrassed
about years later.  It gets more visible, it gets self-sustained and it
gets more and more sticky - it became a subculture in its own right and
as far as I can see it is offering more and more incentives to stay in it
instead of moving on.

And it sits right on the way (OK, one of the ways - the widest one) into
the community.  Andrew, please realize that it's not a rethorical exercise -
I'm trying to explain what is really, honestly scaring me a lot about the
current situation.  Do you see any ways to deal with that mess?  Do you
at least agree that we have a problem there?
