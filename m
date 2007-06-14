Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXFNFvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXFNFvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXFNFvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:51:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbXFNFvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:51:37 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706132042.02728.dhazelton@enter.net>
	<ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132347.42371.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 02:51:13 -0300
In-Reply-To: <200706132347.42371.dhazelton@enter.net> (Daniel Hazelton's message of "Wed\, 13 Jun 2007 23\:47\:42 -0400")
Message-ID: <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> I've never had a reason to want to change the way any device like a TiVO 
> works. So I can't comment on this.

Have you never wanted to improve any aspect of the software in your
cell phone?  In your TV, VCR, DVD player, anything?  In the microwave
oven, maybe?

> On Wednesday 13 June 2007 22:38:05 Alexandre Oliva wrote:
>> In 95% of the desktop computers, you can't make changes to the OS that
>> runs on it.  Whom is this good for?

> Faulty logic. I have yet to find a computer that I couldn't change the OS on. 

I was not talking about installing another OS, I was talking about
making changes to the OS.  As in, improving one particular driver,
avoiding a blue screen, stuff like that.

> Or do you mean "transferring the recorded copies off the TiVO 
> and on to a different medium"?

Sure.  Such that I can watch shows while wasting time in public
transportation, in an airplane, whatever.

> DRM, I do agree, gets in the way of "Fair Use".

And the fact that TiVO can be, and has been modified remotely to add
restrictions on what users could do, means nothing you do with it is
safe.  You, and everything you've recorded with the TiVO, are at the
mercy of this one company.

> So you're not concerned that you're potentially pushing companies
> that would otherwise be major consumers of GPL'd software away? That
> doesn't make sense to me.

What would their consuming GPL software buy us, if they won't respect
users' freedoms, which is the very reason behind the GPL?

Heck, if they don't want to play by the rules, that's up to them.  But
then they shouldn't use the software at all.

Yeah, I wish they'd rather play by the rules, but if they don't want
to, too bad, for us and for them.

> Why should I repeat Linus' explanation of the ways that GPLv3 violates the 
> spirit of GPLv2?

Don't worry about parrotting here, he hasn't provided that explanation
yet ;-)  Please give it a try.

BTW, what license is Linux licensed under?  It's GPLv2 plus userland
exception, right?  (There's some additional module exception, right?)

> And why shouldn't I pose it as a matter of "Personal Taste"? The
> biggest and most powerful voice in the FSF says "I don't like
> Tivoization" and "I don't like DRM" and when the GPLv3 appears it
> has language that makes those violations of the license.

Have you ever wondered *why* he doesn't like them?

Could it possibly be because they harm the goal of his life, which is
to enable people to live their digital lives in freedom?

> Just like people have started using "GNU/Linux" or "GNU+Linux" to
> refer to Linux

No, no, you got it wrong.  Linux is the kernel.  GNU was the
nearly-complete operating system it fit in.  GNU+Linux is a complete
operating system.

And you don't have to believe me, believe Linus, the initial author of
Linux:

http://www.kernel.org/pub/linux/kernel/Historic/old-versions/RELNOTES-0.01

  Although linux is a complete kernel

  Sadly, a kernel by itself gets you nowhere. To get a working system
  you need a shell, compilers, a library etc. These are separate parts
  and may be under a stricter (or even looser) copyright. Most of the
  tools used with linux are GNU software and are under the GNU
  copyleft.

> A "TiVO" is not, and has never been, a "General Purpose
> Computational Device".

Err...  Last I looked it was a bunch of general-purpose components,
packaged in a way that made it not look like a general-purpose
computer.  Who gets to decide?  And with what motivations?

> Exactly. And I don't see anything about a TiVO (or any device that, like a 
> TiVO, requires binaries that run on it to be digitally signed) that stops you 
> from exercising the "freedoms" guaranteed by the GPL.

  2. You may modify your copy or copies of the Program or any portion
  of it

>> > if you upload a modified linux kernel to your wireless router that
>> > gives it a 2000 foot range, you've just broken the law

>> At which point, you get punished by the law system.

> But the GPLv2 gives companies a chance to protect themselves from legal 
> actions by people that are sure to follow.

So does the GPLv3.  It might be a bit narrower, to cut on other kinds
of abuses, but all constraints I'm aware of that are mandated by law
can still be achieved.  The point is to forbid disrespecting users'
freedoms to modify the software.  Configuration parameters for the
hardware, needed to comply with regulations, can be easily taken care
of without disrespecting users' freedoms.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
