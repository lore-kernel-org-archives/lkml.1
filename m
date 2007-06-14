Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXFNHGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXFNHGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXFNHF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:05:57 -0400
Received: from keil-draco.com ([216.193.185.50]:50373 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbXFNHFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:05:55 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 03:05:49 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org> <ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140305.50095.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 02:36:12 Alexandre Oliva wrote:
> On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Thu, 14 Jun 2007, Adrian Bunk wrote:
> >> "For an executable work, complete source code means all the source code
> >> for all modules it contains, plus any associated interface definition
> >> files, plus the scripts used to control compilation and installation of
> >> the executable."
> >>
> >> The question is whether this includes private keys.
> >
> > No. That's the question as the FSF would like to frame it.
>
> No.  The FSF actually does *not* want to take this position.  That's
> why it chose the formulation of Installation Instructions.  It doesn't
> share my view that the keys needed to sign a binary in order for it to
> work are part of the source code.
>
> > And you could actually replace their copy of Linux with another one. It
> > would have to have the same SHA1 to actually start _running_, but that's
> > the hardware's choice.
>
> That's the hardware imposing a restriction on modification of the
> software.  It doesn't matter how elaborate the excuse is to justify
> denying users' freedoms: it's against the spirit of the GPL, and the
> GPL will be amended as needed to plug such holes.

And? There is *absolutely* *nothing* in any version of the GPL *prior* to 3 
that says that hardware cannot impose restrictions. What the GPL *does* say 
is that you can't "add additional restrictions to the license" - (IMHO) a 
piece of hardware having a restriction isn't an "additional restriction added 
to the license". As well, as Linus stated, there is nothing *anywhere* - 
AFAICT, not even in GPLv3 - that says that you have to be able to run the 
software "in place" or "on the same hardware".

If a hardware manufacturer - like TiVO - uses GPL'd code in their product - 
and complies with the terms of the license - they aren't required to allow 
you to run modified code on that hardware. Without it mentioned anywhere in 
the GPL *OR* the assorted writings of RMS (who founded the FSF and wrote the 
original GPL) that "modified software must be able to run on the same 
hardware" then it cannot be in the "spirit" of the license to allow this.

> > So take another example: I obviously distribute code that is copyrighted
> > by others under the GPLv2. Do I follow the GPLv2? I sure as hell do! But
> > do I give you the same rights as I have to modify the copy on
> > master.kernel.org as I have? I sure as hell DO NOT!
>
> That's an interesting argument.
>
> People don't get your copy, so they're not entitled to anything about
> it.
>
> When they download the software, they get another copy, and they have
> a right to modify that copy.

But you get the TiVO corporations copy of the software? I smell a logical 
fallacy here, but can't remember the name for it.

> > And here's a big clue for people: anybody who thinks that I'm violating
> > the GPLv2 by not giving out my private SSH key to master.kernel.org is a
> > f*cking moron!
>
> Agreed, except I'd probably use a lighter term.
>
> > See any parallels here? Any parallel to a CD-ROM distribution, or a Tivo
> > distribution?
>
> Yes.  You see how TiVO is different?  It is modifyable, and I actually
> receive the copy that TiVO can still modify, but I can't.

I don't. You don't get the TiVO corporations copy of the software. You get 
your own copy, with all the rights that TiVO had when receiving the software. 
The right to install and run the kernel in the TiVO device is independent of 
the rights to copy, modify, distribute and run the software. (because the GPL 
never guarantees you the right to run the software on a particular piece of 
hardware.)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
