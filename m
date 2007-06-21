Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbXFUEz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbXFUEz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbXFUEzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:55:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbXFUEzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:55:21 -0400
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706171436x6b9f2f13pf115d97fee3b1525@mail.gmail.com>
	<ory7iidtrs.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706201344kbe3ec9j6bfd4c184f7747f6@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 01:54:23 -0300
In-Reply-To: <9a8748490706201344kbe3ec9j6bfd4c184f7747f6@mail.gmail.com> (Jesper Juhl's message of "Wed\, 20 Jun 2007 22\:44\:01 +0200")
Message-ID: <or4pl1sy9s.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, "Jesper Juhl" <jesper.juhl@gmail.com> wrote:

> On 18/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
>> Your analysis stopped at the downside of prohibiting tivoization.  You
>> didn't analyze the potential upsides,

> Maybe that's because I don't really see any up sides.

You do:

> a few vendors that currently tivoize hardware may open up their
> hardware but I doubt that will be very many

You just don't think they'd prevail over the downsides.  *This* is an
opinion I can respect, even if it's as much of a guestimate as mine.
I'm sure both are highly influenced by personal opinions, wishful
thinking and fears.  This is all very human.

>> so you may indeed come to different conclusions, and they may very
>> well be wrong.

> Just because I come to a different conclusion than you doesn't
> nessesarily make it wrong.

Agreed.  I didn't say they were.  I said they could be.  Can you prove
they're right?  Do you even have any supporting evidence to back your
guestimates?  Heck, you may even have more than I do.

I openly admit mine is mostly theoretical.  I extrapolate the initial
success of GNU+Linux on the PC environment, due in a large part to the
ability for users to tinker with their computers, and expect it not to
be so significantly different for other kinds of computers.

For sure you'll get a far lower *percentage* of hackers in consumer
devices than on PCs, whose users used to be far more
technically-inclined and thus more propense to become hackers when
GNU+Linux started than these days.

But then I think of all of these computer users who helped make
GNU+Linux what it is today, and other hackers that hadn't discovered
this inclination before because they haven't had access to hackable
computers.  They could be tinkering with their DVRs, cell phones,
wireless routers et al, and bringing the same kind of exciting
community development to these kinds of computers.

I'm saddened that the major Linux developers are willing to trade all
of this (which I openly admit may be just a figment of my imagination,
or just a tip of an iceberg) for some professional contributions
(good) and some additional exposure that won't do justice to their
software (bad), because these users will miss a big part of the
picture by not being able to tinker with the software in the
environment where they use the software.

>> It's very human to look only at the potential downside of an action
>> and conclude it's a bad action.

> And you believe yourself to be immune to that - right?

Last I looked, I was still human.  So no.  I try to use logic to
reason out such behaviors when I realize they might be in action.
But, as the saying goes, logic is a tool we use to justify our
intutions.  Or, logical reasoning is a tool to make the wrong
decisions with a greater amount of confidence ;-)

>> You can create the device using GPLv3 software in it.

> Not as long as I want to prevent the user from tampering with it, no.

<broken record>mumble ROM mumble</broken record>

> But do you really expect a vendor to put a device on the market where
> they also lock themselves out of upgrading it and releasing new
> software for it?

Depends on how badly they want to use the GPLed software.

Don't you guys think Linux is so technically superior that some
vendors might prefer to stick with it (should it move to GPLv3, or
tivoization be found to be already forbidden by GPLv2 in a US court or
elsewhere) even if this means going to ROM or respecting users'
freedoms?

Or are Linux advantages so thin and fragile (if they exist at all)
that you're just hoping nobody realizes there are better choices out
there, and you're desperate for vendors not to realize this?

> For a few select individuals that may be true. But for the majority of
> the population it won't mean a thing.

Agreed.  You're thinking of percentages (fewer percent hackers among
consumers of user products than among PC users).  I'm thinking all
hackers in PCs could become hackers of such devices as well, and then
some.

>> This is the upside that you left out from your analysis, and from
>> every other analysis that set out to "prove" that anti-tivoization is
>> bad that I've seen so far.

> I'm sorry, but I don't think it holds water.

Fair enough.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
