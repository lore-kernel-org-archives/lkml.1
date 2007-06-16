Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXFPScW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXFPScW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 14:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXFPScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 14:32:14 -0400
Received: from keil-draco.com ([216.193.185.50]:50299 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXFPScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 14:32:13 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 16 Jun 2007 14:31:58 -0400
User-Agent: KMail/1.9.6
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616103130.GD32405@brong.net> <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161431.58245.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 13:14:29 Alexandre Oliva wrote:
> On Jun 16, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> > On Sat, Jun 16, 2007 at 05:22:21AM -0300, Alexandre Oliva wrote:
> >> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> >> > because it could easily be argued that they linked the BIOS with the
> >> > Linux kernel
> >>
> >> How so?
> >
> > Er, they installed it in the same piece of equipment, and the kernel
> > couldn't function without it in that work.
>
> I see what you're getting at.  You're thinking of a license that
> doesn't respect the idea of "mere aggregation", right?
>
> For starters, this wouldn't evidently not qualify as an Open Source
> license, and I'm pretty sure it wouldn't qualify as a Free Software
> license either.

This situation is a general description that actually fits what TiVO has done. 
The difference in the TiVO case is that you (and everyone that thinks like 
you - ie: believes that the "tivoization" language in GPLv3 is good) 
equate "replace entirely" with "modification" when, in fact, the two are 
entirely separate acts.

> > By using GPLix as part of their boot process along with their
> > non-GPL BIOS, they're subverting the freedoms that the user should
> > have in being able to control the entire boot process.
>
> You're pushing the "freedom to change" too far.  Sure, I'd like to be
> able to do that, and I prefer hardware that lets me do it, but it's
> not like this BIOS in the scenario you described is being used as a
> means to stop me from modifying the GPLed software.
>
> I have never said that including a GPLed piece of software should
> grant users the right to modify anything whatsoever in the system, or
> grant them control over the entire system.  Others have, but it's not
> true, it just shows how much mis-information is floating around.
>
> All the GPL stands for is to defend the freedom of the users over the
> particular program it applies to.  You can't impose further
> restrictions on the user's ability to modify what *that* software
> does.

"You can't impose further restrictions on the user's ability to modify what 
*that* software does."

I don't see how TiVO has done this. They have placed no restrictions on 
*modification* at all. What they have done is placed a restriction on 
*REPLACEMENT* of the program. If you're going to argue that "replacement == 
modification" then it is an *easy* argument to make that every time someone 
*replaces* linux with a proprietary system the proprietary system magically 
becomes GPL'd.

And no, this isn't a logical fallacy on my part. It's on your part - all I've 
done is take the logic you have provided and extend it to cover a different 
situation.

DRH

> If you wanted to change something else, but this something else is not
> covered by the license, and is not being used to contradict the terms
> of the license, well, too bad, you lose.
>
> > b) deny themselves the ability to every offer a patch to said BIOS if
> >    bugs are found
> >
> > Point (b) is also exactly on topic for the discussion of enforcing
> > legal safety obligations in hardware on a peripheral rather than the
> > software drivers.
> >
> > It's requiring that these limitations be placed in a technically
> > inferior location to hack around a legal "bug".
>
> I don't think this last sentence is true.  If you implement hardware
> locks that prevent modification of the software even by yourself, then
> you're in compliance with the terms of the GPLv3dd4.  But IANAL.



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
