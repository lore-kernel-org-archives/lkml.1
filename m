Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXFNCio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXFNCio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXFNCig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:38:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbXFNCif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:38:35 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
	<or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132042.02728.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 23:38:05 -0300
In-Reply-To: <200706132042.02728.dhazelton@enter.net> (Daniel Hazelton's message of "Wed\, 13 Jun 2007 20\:42\:02 -0400")
Message-ID: <ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Wednesday 13 June 2007 19:49:23 Alexandre Oliva wrote:

> Exactly. They don't. What TiVO prevents is using that modified version on 
> their hardware. And they have that right, because the Hardware *ISN'T* 
> covered by the GPL.

Indeed, TiVO has this legal right.  But then they must not use
software under the GPLv3 in it.  And, arguably, they must not use
software under the GPLv2 either.

> In the case of 99% of the hardware targeted by the clause of the GPLv3 you 
> elucidate on, the "ability to install modified versions of the software" was 
> *NOT* intended for that use, nor was it intended for *ANYONE* *EXCEPT* 
> trained service personell to have *ACCESS* to that functionality. Arguing 
> otherwise is just idiotic - I have never found a piece of "high tech" 
> hardware (like a TiVO) that was designed for the end-user to modify. (yes, 
> installing a new version of the linux kernel is "modifying" the system)

It's about time for a change for better, wouldn't you think?

In 95% of the desktop computers, you can't make changes to the OS that
runs on it.  Whom is this good for?

> And? They distribute the kernel source - as they recieved it - in
> compliance with the GPL.

This makes it seem like you think that passing on the source code is
enough to comply with the GPL.  Check your assumptions.  It's not.

>> to prohibit people from removing locks that stop them from doing
>> things they're legally entitled to do

> What "Legally Entitled" things?

Time shifting of any shows, creating copies of shows for personal use,
letting others do so.  Think fair use, and how TiVO software and DRM
in general gets in the way.

> And... You do realize that almost every difference between the GPLv2
> and the GPLv3 is going to cause a hell of a lot of problems?

For those who are not willing to abide by the spirit of the license,
yes.  Does it look like I'm concerned about them?  If they're willing
to look for and maybe even find holes in the license to disrespect
users' freedoms, why should I worry about the problems that plugging
these holes is going to cause them?  If they'd taken the spirit of the
GPL for what it is, instead of looking for loopholes, this improved
wording wouldn't be causing them any problems whatsoever.

> The fact that the GPLv3 is designed to prevent things that RMS
> *PERSONALLY* finds distasteful - DRM and the like - is a big
> turn-off for a *LOT* of people.

This is a pretty sad accusation.  2/3s of the Free Software packages
use the GPL with its existing spirit, and you still haven't shown that
any changes proposed in GPLv3 fail to abide by the same spirit.  That
some (many?) people misunderstood or disregarded the spirit is an
unfortunate fact, but trying to pose the patching that's going into
GPLv3 as if it was a matter of personal taste, rather than improved
compliance with the spirit, is unfair and uncalled for.

> (Personally I don't like *ANY* version of the GPL, because there are
> chunks I have problems with)

What are you doing lurking and spreading confusion in a list about a
project that chose to use it, then?

>> Do you expect Linux would have flourished if computers had locks that
>> stopped people from modifying Linux in them?

> But you aren't talking about a "computer" here. You're talking about
> a mass-market device that must comply with both US and International
> copyright law - and that's just a TiVO.

Oh, sorry.  I missed when the meaning of the word computer was
narrowed from "machine with a general-purpose microprocessor, memory
and other peripherals" to whatever you decide it is.

And then, the GPL doesn't talk about computers at all.  It's not about
the hardware, it's about the software, remember? ;-)

> if you upload a modified linux kernel to your wireless router that
> gives it a 2000 foot range, you've just broken the law

At which point, you get punished by the law system.

> *AND* violated the license on the hardware which states that you
> "won't modify it or the controlling software"

Err..  The hardware licensor who includes software under the GPL be
supposed to be a licensee of the software in order to have legal
permission to distribute it, at which point the following provision
kicks in:

  6. Each time you redistribute the Program (or any work based on the
  Program) [...] You may not impose any further restrictions on the
  recipients' exercise of the rights granted herein. [...]

And here's one of the rights granted herein that would be restricted
by this hardware license:

  2. You may modify your copy or copies of the Program or any portion
  of it, thus forming a work based on the Program,

So such a restriction in the hardware license seems to be failure to
comply with the GPL, which means the violator may lose the license.

> even things like the connectors used to upload the operating
> software at the factory that people now cannot have in a device that
> runs GPL(v3) covered software unless they ship the related
> "Installation Information".

This sounds like a reasonable point.  Please bring it up at
gplv3.fsf.org.  If it requires specialized hardware to modify the
software in the device, the hardware manufacturer can't modify the
software without cooperation from the user, and then perhaps it would
be fair for the user to need cooperation from the manufacturer.

> That, to me, reads like RMS got mad about TiVO and said "I don't
> like it, lets add a clause making it wrong to the next GPL". Hell,
> that *IS* what happened, and nothing the FSF or Eben Moglen says
> will convince me otherwise.

If you've already made your mind about this, in spite of not having
the facts, I guess it doesn't make sense for me to waste my time
trying to convince you, does it?

>> What's under the license is the software in it.  And that license
>> spirit requires the distributor to pass on the right to modify the
>> software.

> And since when did they have to enable people to use their hardware in 
> violation of the licensing agreement they implicitly agree to when opening 
> the package?

Since they got permission to distribute the software under the
condition of passing on the freedoms without imposing further
restrictions on their exercise.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
