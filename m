Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbXFNGg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbXFNGg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXFNGgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:36:52 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50313 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXFNGgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:36:51 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 02:36:39 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706132347.42371.dhazelton@enter.net> <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140236.39394.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 01:51:13 Alexandre Oliva wrote:
> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > I've never had a reason to want to change the way any device like a TiVO
> > works. So I can't comment on this.
>
> Have you never wanted to improve any aspect of the software in your
> cell phone?  In your TV, VCR, DVD player, anything?  In the microwave
> oven, maybe?

Nope. I've been tempted several times, but decided that the extra bits I'd 
thought about wouldn't add anything to the device.

> > On Wednesday 13 June 2007 22:38:05 Alexandre Oliva wrote:
> >> In 95% of the desktop computers, you can't make changes to the OS that
> >> runs on it.  Whom is this good for?
> >
> > Faulty logic. I have yet to find a computer that I couldn't change the OS
> > on.
>
> I was not talking about installing another OS, I was talking about
> making changes to the OS.  As in, improving one particular driver,
> avoiding a blue screen, stuff like that.

Ah, well... In the case of "Windos" and other proprietary OS's I try to 
educate people and get them to switch. I don't, personally, have any 
computers that run Windows (and I switched my Palm back to PalmOS because it 
wasn't getting the same performance under Linux - which rather surprised me. 
And rather than fight with it I just switched it back.

> > Or do you mean "transferring the recorded copies off the TiVO
> > and on to a different medium"?
>
> Sure.  Such that I can watch shows while wasting time in public
> transportation, in an airplane, whatever.

Under the US Copyright law I'm not sure that making a "second copy" like that 
is legal. IIRC, "Fair Use" only allows for one copy.

> > DRM, I do agree, gets in the way of "Fair Use".
>
> And the fact that TiVO can be, and has been modified remotely to add
> restrictions on what users could do, means nothing you do with it is
> safe.  You, and everything you've recorded with the TiVO, are at the
> mercy of this one company.

As has been noted in their TOS and the licenses for the hardware from the 
start. The FSF itself explicitly reserves the right to change the GPL at any 
time - which is no different. (when you remove all the bits explaining the 
purpose of the license)

> > So you're not concerned that you're potentially pushing companies
> > that would otherwise be major consumers of GPL'd software away? That
> > doesn't make sense to me.
>
> What would their consuming GPL software buy us, if they won't respect
> users' freedoms, which is the very reason behind the GPL?

I'm not referring to companies that are embedding GPL'd software in their 
products. The companies I'm referring to are the ones that would like to use 
GPL'd software internally. A lot of them would probably have private 
modifications that would never be distributed - and under the GPLv2 it is 
clear that you can keep modifications private as long as you don't distribute 
them. "Pushing them away" means that they'd not do that because they would be 
concerned that the license will change under them in such a way that even 
those private modifications need to be released to the public.

(and don't try to argue that even though those modifications are truly private 
(to the company) they should be released anyway to comply with the "spirit" 
of the license. It is made clear that it isn't by the text of the license 
itself)

> Heck, if they don't want to play by the rules, that's up to them.  But
> then they shouldn't use the software at all.
>
> Yeah, I wish they'd rather play by the rules, but if they don't want
> to, too bad, for us and for them.
>
> > Why should I repeat Linus' explanation of the ways that GPLv3 violates
> > the spirit of GPLv2?
>
> Don't worry about parrotting here, he hasn't provided that explanation
> yet ;-)  Please give it a try.

But he has. Whether you have accepted that his explanations are valid or not 
doesn't change the fact.

> BTW, what license is Linux licensed under?  It's GPLv2 plus userland
> exception, right?  (There's some additional module exception, right?)

The kernel itself is GPLv2 (only). Individual components - even individual 
files - have other licenses or retain the "any later version" clause. 
(Someone pointed out, earlier in this thread, that there is GPLv1.1 code in 
the kernel)

> > And why shouldn't I pose it as a matter of "Personal Taste"? The
> > biggest and most powerful voice in the FSF says "I don't like
> > Tivoization" and "I don't like DRM" and when the GPLv3 appears it
> > has language that makes those violations of the license.
>
> Have you ever wondered *why* he doesn't like them?

Not really. I've always figured he had reasons similar to mine for not liking 
DRM. As to his dislike of "Tivoization", well, that I've always attributed to 
the fact that someone at that company managed to outsmart him. (and no, I 
wasn't being serious with that last line)

> Could it possibly be because they harm the goal of his life, which is
> to enable people to live their digital lives in freedom?
>
> > Just like people have started using "GNU/Linux" or "GNU+Linux" to
> > refer to Linux
>
> No, no, you got it wrong.  Linux is the kernel.  GNU was the
> nearly-complete operating system it fit in.  GNU+Linux is a complete
> operating system.

Yet I still find people that insist that the *ENTIRE* system - kernel and 
all - is a GNU project. Not just the common idiot you'd find on almost any 
street in the US, but also educated people in technical fields. The reason is 
the name. 

*AND* you cut out the bit where I said "I have no problems with it"

> And you don't have to believe me, believe Linus, the initial author of
> Linux:
>
> http://www.kernel.org/pub/linux/kernel/Historic/old-versions/RELNOTES-0.01
>
>   Although linux is a complete kernel
>
>   Sadly, a kernel by itself gets you nowhere. To get a working system
>   you need a shell, compilers, a library etc. These are separate parts
>   and may be under a stricter (or even looser) copyright. Most of the
>   tools used with linux are GNU software and are under the GNU
>   copyleft.

Never claimed otherwise. The problem is that using a composite name like that 
*does* confuse a hell of a lot of people. See my statements above about that.

> > A "TiVO" is not, and has never been, a "General Purpose
> > Computational Device".
>
> Err...  Last I looked it was a bunch of general-purpose components,
> packaged in a way that made it not look like a general-purpose
> computer.  Who gets to decide?  And with what motivations?

And so is every game console. But until the original XBox was released nobody 
tried using one as a "General Purpose" machine. The TiVO wasn't designed as a 
general purpose machine - it was designed for a specific purpose. That the 
*easiest* design to produce uses a bunch of general purpose components is an 
economic choice, nothing else.

I will not, however, argue about this anymore. As with other bits, we've 
reached a point where we disagree and no amount of explanation will change 
the others viewpoint. (I hope you understand mine as well as (I think) I 
understand yours)

> > Exactly. And I don't see anything about a TiVO (or any device that, like
> > a TiVO, requires binaries that run on it to be digitally signed) that
> > stops you from exercising the "freedoms" guaranteed by the GPL.
>
>   2. You may modify your copy or copies of the Program or any portion
>   of it
>
> >> > if you upload a modified linux kernel to your wireless router that
> >> > gives it a 2000 foot range, you've just broken the law
> >>
> >> At which point, you get punished by the law system.
> >
> > But the GPLv2 gives companies a chance to protect themselves from legal
> > actions by people that are sure to follow.
>
> So does the GPLv3.  It might be a bit narrower, to cut on other kinds
> of abuses, but all constraints I'm aware of that are mandated by law
> can still be achieved.  The point is to forbid disrespecting users'
> freedoms to modify the software.  Configuration parameters for the
> hardware, needed to comply with regulations, can be easily taken care
> of without disrespecting users' freedoms.

Let me quote Linus here:

But I think the whole thing is totally misguided, because the fact is, the 
GPLv2 doesn't talk about "in place" or "on the same hardware".

In other words, GPLv3 is breaking with its predecessor - it's adding a 
requirement that doesn't exist in previous versions. *AND* it's dictating 
terms for *HARDWARE* when it isn't a hardware license. If I release software 
under the GPL and somebody modifies it to run on a different hardware 
platform I'll be happy, even if they don't send me a patchset for the new 
version. If I create a piece of hardware and run Linux on it, but have it 
locked to a specific version or versions from a specific source (ie: me) and 
release it to the public, I *WILL* release the version of Linux I'm running 
on it. What I won't do is release whatever tools and such that are needed to 
make the hardware run a different version of the kernel. Why? Because: the 
hardware was designed so that a specific version of the kernel runs without 
problems, there is hardware that is very picky and running a customized 
kernel could cause that hardware to fail, etc... There are more reasons than 
the legal protection I previously mentioned. Not a single one of them 
is "Because I want to restrict peoples freedoms re: the GPL'd software". 

Admittedly the two examples I chose aren't very realistic, but those were the 
first two examples that came to mind.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
