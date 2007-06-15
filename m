Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXFOAuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXFOAuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbXFOAt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:49:58 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50011 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbXFOAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:49:57 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 20:49:41 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706141640.17217.dhazelton@enter.net> <orabv29qtk.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orabv29qtk.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142049.41819.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 17:19:51 Alexandre Oliva wrote:
> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > With GPLv2 and prior there was a simple guarantee that every
> > "Licensee" had exactly the same rights. With GPLv3 you are forcing
> > your ethics and morals on people - and isn't this exactly what the
> > Roman Catholic church did during the Spanish Inquisition?
>
> I fail to see the distinction you're making between GPLv2 and GPLv3.
> AFAICT, with GPLv3, there still is a simple guarantee that every
> licensee has exactly the same rights.
>
> Sure, GPLv3 follows the spirit of the GPLs more strictly than GPLv2
> possibly could.  How is that "forcing ethics and morals" any more than
> GPLv2 was?

Because GPLv2 doesn't enforce limitations on the hardware a GPL'd work can be 
put on. It doesn't make artificial distinctions between "Commercial", 
"Industrial" and "User". What it does is *ATTEMPT* to ensure that nobody 
receiving a copy of a GPL'd work has the same rights as any other person that 
gets a copy. GPLv3 gives people *additional* rights beyond those. In 
the "TiVO" case it forces somebody releasing a HW platform to grant 
*additional* rights if they are going to use software covered by the GPLv3. 
The reason for forcing the giving of those additional rights is "the FSF and 
GPLv3 committees think that what TiVO did is 'morally and ethically' wrong, 
so were are enforcing our morals and ethics".

Note that these are the rights that TiVO got from the GPLv2:
1) The ability to make copies of Linux
2) The ability to modify Linux
3) The ability to distribute Linux
*NOTE* that those are the rights *GUARANTEED* by the GPL - despite what anyone 
*WISHES* it to say, or what the "Intent" or "Spirit" of the license may be, 
those are the only guaranteed rights.

In shipping their devices with an "object code" version of Linux on them they 
exercised their right to perform such a distribution, granted under section 3 
of the GPLv2. They made modifications to the Linux so it functioned properly 
on their devices, as allowed by the GPL. They have made numerous copies of 
Linux, as allowed by the GPL. And, as required by the GPLv2, they made the 
source code form of their changes available. In fact, they went beyond the 
requirements of the GPL (which only requires you make the source available to 
people you have given an "object code" version to) in making it fully 
available to the public *AND* in contributing those changes back to Linux.

What rights did they give to "downstream" recipients of the "object code" 
version? *EXACTLY* those they received from the GPLv2.

What rights do they have as creators of a *PROPRIETARY* hardware platform:
1) The right to restrict what programs it will run
2) The right to update it as they choose, even if it makes it incompatible 
with earlier versions

Does the GPL *require* them to give up those rights? Version 3 does, but not 
any earlier version. Why does version 3 do this? Because one or more of the 
people behind its design and language feel that executing a piece of software 
on any given hardware platform automatically entitles them to all rights to 
the hardware that the creator of the hardware has. 

> > Ah, but I never said I had a GPLv1 program.
>
> I thought you had a copy of Linux and, per what you'd said before,
> there was GPLv1 code in it.  I was just trying to make it easy for
> you.
>
> > If GPLv1 is still valid and available I should be able to find a
> > copy of it *RIGHT* *NOW* to license a new project if I want to use
> > GPLv1 as its license.
>
> http://www.gnu.org/copyleft/copying-1.0.html

Ah, see, I didn't even know it was still there. I hadn't seen it in a complete 
form anywhere.

> >> > And because its a device that connects to their network - and TiVO
> >> > isn't a telecommunications company - they have the right to upgrade
> >> > and configure the software inside however they want. (In the US at
> >> > least)
> >>
> >> But do they have the right to not pass this right on, under the GPL?
> >
> > Yes, they do. It isn't a right they have as "copyright holders" - in
> > fact, it isn't a part of their rights under the copyright at all. It's a
> > part of their rights as the owners of the network.
>
> How about the "no further restrictions" bit?

As applies to the software. The rights that the GPL has (historically) granted 
are what I stated above. TiVO, and companies like them, are *NOT* imposing 
any restrictions on rights granted under GPLv2 and prior. Remember, because 
I'm getting tired of repeating myself: replace != modify

> > Never claimed it was less obscure, just that you've usually got a
> > board-room filled with middle-aged men that might have problems agreeing
> > that it is a clear-cut case.
> >
> > Yes, but the fact that it would cost money to get the suit dropped is a
> > problem.
>
> Again, how are these arguments against GPLv3?  They apply equally to
> any other license, including GPLv2.

Granted. But GPLv2 has been examined and re-examined by lawyer and lay-person 
alike for more than 10 years. If you recall, however, my original statement 
was about the "revise or change the license at any time" clause. If that is 
possible, then it is also possible for the mentioned "frivolous lawsuit" by 
someone applying the "revised" license to something licensed with the 
non-revised version.

Your argument is flawed, however. Most companies have done the work for 
defense with the "other licenses". And if it isn't possible for a "Licensor" 
to say "My work is released under version X of this license only" (with the 
GPL) - as you seem to have argued at several points - then it wouldn't matter 
if they've done the legwork to protect them from all but the most frivolous 
of lawsuits. All that needs to happen is for someone to release the same work 
under a later license (with modifications) and the company is now open to a 
new, unplanned for class of "frivolous lawsuits".

> >> Interpretation as applied to the legal terms, yes.  As for the spirit
> >> of the license, the authors ought to know better than anyone else what
> >> they meant.  Sure, other interpretations might lead to different
> >> understandings as to what the readers *think* it means, but that
> >> doesn't change what it was *intended* to mean.
> >
> > Doesn't matter what the author intended it to mean - at all. What matters
> > is how its interpreted when/if it shows up in court.
>
> You're talking about the legal terms.  The spirit of the license is a
> very different matter.  It can guide the interpretation of the legal
> terms, but the author is at a better position than anyone else to know
> what he meant.

I do agree that the intent can guide interpretation, but in the US it is very 
rare. Consider the "Second Amendment", which states "The formation of 
militias being necessary for the defense of the state, the right of the 
people to keep and bear arms shall not be abridged." The *INTENT* is 
explained by the authors in several places, but the interpretation is still 
argued about. The meaning is *VERY* clear to me - and makes all "Gun Control" 
laws and such in direct violation of the US Constitution. But that doesn't 
matter, because nobody pays attention to the intent.

> >> If you replace a component in the hardware, are you still required to
> >> provide support or offer warranty?  Why should this be different just
> >> because it's a software component?
> >
> > Artificial distinctions in the law
>
> Well, then, lock down the software.  Make it irreplaceable, even by
> yourself.  Problem solved.

Yes, problem solved. But at the cost of taking hardware back 20 years.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
