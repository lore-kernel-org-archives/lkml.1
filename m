Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbXFNPOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbXFNPOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXFNPOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:14:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbXFNPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:14:13 -0400
Date: Thu, 14 Jun 2007 08:13:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bernd Petrovitsch <bernd@firmix.at>
cc: Alexandre Oliva <aoliva@redhat.com>, Daniel Hazelton <dhazelton@enter.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <1181810275.14938.16.camel@tara.firmix.at>
Message-ID: <alpine.LFD.0.98.0706140750290.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> 
 <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org> 
 <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>  <200706132042.02728.dhazelton@enter.net>
  <ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br>
 <1181810275.14938.16.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Bernd Petrovitsch wrote:

> On Wed, 2007-06-13 at 23:38 -0300, Alexandre Oliva wrote:
> > On Jun 13, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > > On Wednesday 13 June 2007 19:49:23 Alexandre Oliva wrote:
> > 
> > > Exactly. They don't. What TiVO prevents is using that modified version on 
> > > their hardware. And they have that right, because the Hardware *ISN'T* 
>        ^^^^^^^^^^^^^^
> BTW as soon as I bought that thing, it is *my* hardware and no longer
> *theirs* (whoever "theirs" was).

You bought *their* design. It was your choice. 

And yes, you own the hardware, and you can hack it any which way you like 
(modulo laws and any other contracts you signed when you bought it). But 
they had the right to design it certain ways, and part of that design may 
be making it _harder_ for you to hack.

For example, they may have used glue to put the thing together rather than 
standard phillips screws. Or poured resin over some of the chips. All of 
which has been done (not necessarily with Linux, but this really is an 
issue that has nothing to do with Linux per se). Making the firmware or 
hardware harder to access or modify is their choice.

Your choice is whether you buy it, despite the fact that you know it's not 
necessarily all that easy to hack.

> > Indeed, TiVO has this legal right.  But then they must not use
> 
> Do they? At least in .at, it is usually impossible to (legally) limit
> the rights of the *owner* a (tangible) thing (and if I bought it, I *am*
> the owner and no one else) - even if you put it in the sales contract
> since this is discussion about/within sales law.

The "when I buy it, I own it" argument is a favourite of the GPLv3 shills, 
but it's irrelevant. The *design* was done long before you bought it, and 
yes, Tivo had the right to design and build it, any which way they wanted 
to. 

> One usual example is "you buy a car and neither the car producer nor the
> (re)seller can restrict the brands of the tires you may use or the brand
> of the fuel etc.".
> 
> And the same holds for pretty much everything. No one can forbid you to
> open a TV set and fix it (or let it fix by whoever I choose to).

You are missing the picture. Sure, you can do whatever you want to (within 
any applicable laws) _after_ you bought it. But that doesn't take away the 
right from the manufacturer to design it his way.

And you're also *wrong*. Tivo doesn't limit the brands of electricity it 
uses or anything idiotic like that. You can put after-market rubber bumps 
on the thing to make it look sleeker, and I seriously doubt that Tivo will 
do aythign at all. It's about going into the innards, and different car 
manufacturers make that harder too, for various reasons.

If the car manufacturer makes things harder to hack, it's your choice. For 
example, car hackers *do* actually prefer certain brands. Apparently the 
Subaru's are popular, and German cars are a pain to try to change. I'm 
told that even somethign as simple as upgrading the sound system is just 
_harder_ in a German car, apparently because they make things fit together 
so tightly, that doing after-market cabling is just much more of a 
problem.

Same goes for things like electronic engine controls. Look it up. Try 
chipping a car lately? For some, it's literally buying a chip online, and 
some fairly simple work. For others, it's almost impossible, and you have 
to take your car in to somebody who really knows what he's doing. And you 
know what? Exactly like with a Tivo, the car manufacturer won't have 
anything to do with the car afterwards. If you broke it by chipping it, 
you voided your warranty.

See? If you are actually looking for a car to hack on, you'd buy a car 
with that in mind. Do the exact same thing with your Tivo. Don't buy it if 
you want to hack it: buy a Neuros OSD device instead!  I'm serious: the 
Neuros people do *not* limit you, and in fact they encourage hacking. 
Instead of whining about Tivo, do something *positive*, and support Neuros 
for their better policies!

				Linus
