Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXFNRr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXFNRr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXFNRrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:47:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXFNRrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:47:48 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706140236.39394.dhazelton@enter.net>
	<orhcpbggcu.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140429.11049.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 14:26:30 -0300
In-Reply-To: <200706140429.11049.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 04\:29\:10 -0400")
Message-ID: <orejkefnw9.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Thursday 14 June 2007 03:11:45 Alexandre Oliva wrote:
>> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
>> > Ah, well... In the case of "Windos" and other proprietary OS's I try to
>> > educate people and get them to switch.

>> Good.  So I presume you'd tell them to switch away from a
>> turned-proprietary GNU/Linux operating system as well, right?

> If that happened I'd be lost. I've tried the various BSD's and found they had 
> problems with hardware support and getting a new version of the BSD kernel to 
> compile and boot is something of a black art.

> The point is moot, though. It can never happen.

Look again, it's already happened in the TiVO and other devices.

The software that ships in them is no longer Free Software.


Consider a new microprocessor.

Consider that Linux is ported to it by the microprocessor
manufacturer.

Consider that the manufacturer only sells devices with that
microprocessor with TiVO-like locks.

How exactly can you enjoy the freedoms WRT the GPLed software you got
from the manufacturer?


Now consider that you have a single computer, and that's built by TiVO.

How exactly can you enjoy the freedoms the author meant you to have,
if the TiVO box won't run the program after you modify it?

> If this "run modified copies on the same hardware you received the
> original on" *IS* the "spirit" of the license, then why isn't it
> stated anywhere before GPLv3?

For the same reasons that the pro-DRM laws weren't mentioned before,
and the patent retaliation clauses weren't mention before: these
specific cases hadn't been studied, only the general idea of
respecting users' freedoms was.

> I'll grant you that. But, at this point, where can I find a copy of
> the GPLv1 without having to dig around the net ?

In the program you received under GPLv1.

Hey, you said there was code under GPLv1.1 in the Linux tree.  Then,
there should be a copy of GPLv1.1 in there, otherwise AFAICT the
distribution of that code is copyright infringement.  IANAL.

>> In contrast, your TiVO may get a software upgrade without your
>> permission that will take your rights away from that point on, and
>> there's very little you can do about it, other than unplugging it from
>> the network to avoid the upgrade if it's not too late already.

> And because its a device that connects to their network - and TiVO
> isn't a telecommunications company - they have the right to upgrade
> and configure the software inside however they want. (In the US at
> least)

But do they have the right to not pass this right on, under the GPL?


>> > A lot of them would probably have private modifications that would
>> > never be distributed - and under the GPLv2 it is clear that you can
>> > keep modifications private as long as you don't distribute them.

>> Likewise with GPLv3.

> I can see this, but will a company see this?

In what sense does the GPLv3 make this particular point any less
obscure?

> True. But that doesn't save them from lawsuits trying to force them
> to obey the terms of the new revision even though they received the
> software under an earlier version.

Nothing saves anyone from silly lawsuits.  This one would likely be
laughed out of court in no time.  Anyone worried about this should
also be concerned about their neighbor suing them for copyright
infringment every time they set their stereo loud enough for the
neighbors to listen and be annoyed.  (Hint: only the copyright holder
would stand a chance of winning such a lawsuit)

>> > (and don't try to argue that even though those modifications are
>> > truly private (to the company) they should be released anyway to
>> > comply with the "spirit" of the license. It is made clear that it
>> > isn't by the text of the license itself)
>> 
>> How could you possibly come to the conclusion that forcing anyone to
>> release private modifications would be in compliance with the spirit
>> of the license?  can != must

> I was trying to be sarcastic and inject a little humor here. Guess I should 
> have used the old <sarcasm> tag :)

Aah.  I'm not sure I'd have understood it either.

>> >> > Why should I repeat Linus' explanation of the ways that GPLv3 violates
>> >> > the spirit of GPLv2?
>> >>
>> >> Don't worry about parrotting here, he hasn't provided that explanation
>> >> yet ;-)  Please give it a try.
>> >
>> > But he has. Whether you have accepted that his explanations are
>> > valid or not doesn't change the fact.
>> 
>> His explanation is based on a reading of the license that doesn't
>> match what its authors meant.  I guess the authors know better what
>> they meant the spirit of the license to be than someone else who
>> studied it a lot but that until very recently couldn't even tell the
>> spirit from the legal terms.

> And his interpretation is no less valid than that of anyone else. In
> fact, after a recent conversation with a couple of lawyers that I
> know, I can state that his interpretation isn't that far off from
> theirs.

Interpretation as applied to the legal terms, yes.  As for the spirit
of the license, the authors ought to know better than anyone else what
they meant.  Sure, other interpretations might lead to different
understandings as to what the readers *think* it means, but that
doesn't change what it was *intended* to mean.

> Then you're lucky. I've had a lot of people say something similar to the 
> following: "Oh, I've heard about that. So which version of the GNU-Linux 
> kernel are you running?" 

Oh my.  That's indeed unfortunate and unfair.

> As I've stated before - I can find nothing in the history of the GPL or the 
> FSF that makes the "on the same hardware" requirement clear and part of 
> the "spirit" of "Free Software".

Put the considerations above, about a single computer or a
uniformly-limited computing platform, and you'll see that this "on the
same hardware" argument is just a means to deny people freedom.  If I
could stop you from running modified versions on one piece of
hardware, then I could on two, and 3, and then soon it's all of them,
and we're back to square zero in terms of freedom.

>> > What I won't do is release whatever tools and such that are needed to
>> > make the hardware run a different version of the kernel. Why? Because:
>> > the hardware was designed so that a specific version of the kernel runs
>> > without problems, there is hardware that is very picky and running a
>> > customized kernel could cause that hardware to fail, etc...

>> Why do you care?  It's no longer your hardware, it's theirs.

> Legal requirements in some countries that require manufacturers to provide 
> support for their product for a period of time after it has been purchased.

If you replace a component in the hardware, are you still required to
provide support or offer warranty?  Why should this be different just
because it's a software component?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
