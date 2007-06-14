Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXFNDsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXFNDsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 23:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXFNDry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 23:47:54 -0400
Received: from keil-draco.com ([216.193.185.50]:50153 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXFNDry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 23:47:54 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 23:47:42 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706132042.02728.dhazelton@enter.net> <ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132347.42371.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 22:38:05 Alexandre Oliva wrote:
> On Jun 13, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Wednesday 13 June 2007 19:49:23 Alexandre Oliva wrote:
> >
> > Exactly. They don't. What TiVO prevents is using that modified version on
> > their hardware. And they have that right, because the Hardware *ISN'T*
> > covered by the GPL.
>
> Indeed, TiVO has this legal right.  But then they must not use
> software under the GPLv3 in it.  And, arguably, they must not use
> software under the GPLv2 either.

Yes. It can be argued. But I cannot find *ANYTHING* in the GPLv2 that stops 
anyone from doing that, unless you add extra meaning to one specific clause. 
(And I am willing to admit that *MOST* people do give it that extra meaning)

> > In the case of 99% of the hardware targeted by the clause of the GPLv3
> > you elucidate on, the "ability to install modified versions of the
> > software" was *NOT* intended for that use, nor was it intended for
> > *ANYONE* *EXCEPT* trained service personell to have *ACCESS* to that
> > functionality. Arguing otherwise is just idiotic - I have never found a
> > piece of "high tech" hardware (like a TiVO) that was designed for the
> > end-user to modify. (yes, installing a new version of the linux kernel is
> > "modifying" the system)
>
> It's about time for a change for better, wouldn't you think?

I've never had a reason to want to change the way any device like a TiVO 
works. So I can't comment on this.

> In 95% of the desktop computers, you can't make changes to the OS that
> runs on it.  Whom is this good for?

Faulty logic. I have yet to find a computer that I couldn't change the OS on. 
I have run Linux on 3 different Mac's, every x86 machine I've ever owned and 
even had it running on my Palm. Whats more is that I have *never* heard of a 
person that knows what they are doing not being able to change the OS on a 
desktop computer.

> > And? They distribute the kernel source - as they recieved it - in
> > compliance with the GPL.
>
> This makes it seem like you think that passing on the source code is
> enough to comply with the GPL.  Check your assumptions.  It's not.

Hrm. Strange, but thats what most companies think. Hell, it even says that you 
have to do just that in the GPL. If you're talking about the fact that it can 
be argued that they are "distributing" Linux by selling their boxes and its a 
modified version then I'll agree with you. 

> >> to prohibit people from removing locks that stop them from doing
> >> things they're legally entitled to do
> >
> > What "Legally Entitled" things?
>
> Time shifting of any shows, creating copies of shows for personal use,
> letting others do so.  Think fair use, and how TiVO software and DRM
> in general gets in the way.

I thought that time shifting and creating personal copies was what the TiVO 
did already. Or do you mean "transferring the recorded copies off the TiVO 
and on to a different medium"? If that is what you mean by "Creating Copies" 
then, IIRC, you're wrong. DRM, I do agree, gets in the way of "Fair Use".

> > And... You do realize that almost every difference between the GPLv2
> > and the GPLv3 is going to cause a hell of a lot of problems?
>
> For those who are not willing to abide by the spirit of the license,
> yes.  Does it look like I'm concerned about them?  If they're willing
> to look for and maybe even find holes in the license to disrespect
> users' freedoms, why should I worry about the problems that plugging
> these holes is going to cause them?  If they'd taken the spirit of the
> GPL for what it is, instead of looking for loopholes, this improved
> wording wouldn't be causing them any problems whatsoever.

Okay. So you're not concerned that you're potentially pushing companies that 
would otherwise be major consumers of GPL'd software away? That doesn't make 
sense to me.

> > The fact that the GPLv3 is designed to prevent things that RMS
> > *PERSONALLY* finds distasteful - DRM and the like - is a big
> > turn-off for a *LOT* of people.
>
> This is a pretty sad accusation.  2/3s of the Free Software packages
> use the GPL with its existing spirit, and you still haven't shown that
> any changes proposed in GPLv3 fail to abide by the same spirit.  That
> some (many?) people misunderstood or disregarded the spirit is an
> unfortunate fact, but trying to pose the patching that's going into
> GPLv3 as if it was a matter of personal taste, rather than improved
> compliance with the spirit, is unfair and uncalled for.

Why should I repeat Linus' explanation of the ways that GPLv3 violates the 
spirit of GPLv2?

And why shouldn't I pose it as a matter of "Personal Taste"? The biggest and 
most powerful voice in the FSF says "I don't like Tivoization" and "I don't 
like DRM" and when the GPLv3 appears it has language that makes those 
violations of the license. Just like people have started using "GNU/Linux" 
or "GNU+Linux" to refer to Linux - a big voice spoke and said "It should be 
GNU/Linux" and it happens. (Not that I really have anything against that - 
though I feel that "GNU/Linux" gives the wrong impression)

> > (Personally I don't like *ANY* version of the GPL, because there are
> > chunks I have problems with)
>
> What are you doing lurking and spreading confusion in a list about a
> project that chose to use it, then?

Just because I don't like the license doesn't make disqualify me from liking 
something that uses the license. And I doubt I've "confused" anyone - where I 
have someone has caught it and called me on it.

> >> Do you expect Linux would have flourished if computers had locks that
> >> stopped people from modifying Linux in them?
> >
> > But you aren't talking about a "computer" here. You're talking about
> > a mass-market device that must comply with both US and International
> > copyright law - and that's just a TiVO.
>
> Oh, sorry.  I missed when the meaning of the word computer was
> narrowed from "machine with a general-purpose microprocessor, memory
> and other peripherals" to whatever you decide it is.

The word "Computer", in the manner I used it there, means "General Purpose 
Computational Device". A "TiVO" is not, and has never been, a "General 
Purpose Computational Device". 

(Perhaps I should have made the above clear)

> And then, the GPL doesn't talk about computers at all.  It's not about
> the hardware, it's about the software, remember? ;-)

Exactly. And I don't see anything about a TiVO (or any device that, like a 
TiVO, requires binaries that run on it to be digitally signed) that stops you 
from exercising the "freedoms" guaranteed by the GPL. As I said before, what 
it does is stop you from violating the license on the hardware.

> > if you upload a modified linux kernel to your wireless router that
> > gives it a 2000 foot range, you've just broken the law
>
> At which point, you get punished by the law system.

But the GPLv2 gives companies a chance to protect themselves from legal 
actions by people that are sure to follow. With the GPLv3 they have none, 
because it becomes a case of "I was just doing what I have the right to do 
under the license for the software. If I wasn't supposed to do it, they 
shouldn't have made it possible."

> > *AND* violated the license on the hardware which states that you
> > "won't modify it or the controlling software"
>
> Err..  The hardware licensor who includes software under the GPL be
> supposed to be a licensee of the software in order to have legal
> permission to distribute it, at which point the following provision
> kicks in:
>
>   6. Each time you redistribute the Program (or any work based on the
>   Program) [...] You may not impose any further restrictions on the
>   recipients' exercise of the rights granted herein. [...]

Hrm... I'd forgotten that clause entirely. That must be why I can't find a 
WRT-54GL anywhere in the US anymore...

> And here's one of the rights granted herein that would be restricted
> by this hardware license:
>
>   2. You may modify your copy or copies of the Program or any portion
>   of it, thus forming a work based on the Program,
>
> So such a restriction in the hardware license seems to be failure to
> comply with the GPL, which means the violator may lose the license.

My apologies. As I said above I totally forgot about section 6. 

> > even things like the connectors used to upload the operating
> > software at the factory that people now cannot have in a device that
> > runs GPL(v3) covered software unless they ship the related
> > "Installation Information".
>
> This sounds like a reasonable point.  Please bring it up at
> gplv3.fsf.org.  If it requires specialized hardware to modify the
> software in the device, the hardware manufacturer can't modify the
> software without cooperation from the user, and then perhaps it would
> be fair for the user to need cooperation from the manufacturer.

Will do. I'm surprised that this situation never came up before, actually. 

> > That, to me, reads like RMS got mad about TiVO and said "I don't
> > like it, lets add a clause making it wrong to the next GPL". Hell,
> > that *IS* what happened, and nothing the FSF or Eben Moglen says
> > will convince me otherwise.
>
> If you've already made your mind about this, in spite of not having
> the facts, I guess it doesn't make sense for me to waste my time
> trying to convince you, does it?

You've made some well reasoned and supported arguments here. I respect RMS and 
Eben Moglen because of what they've done, but that doesn't mean I have to 
like them. However, you are free to (try) to change my mind about them.

> >> What's under the license is the software in it.  And that license
> >> spirit requires the distributor to pass on the right to modify the
> >> software.
> >
> > And since when did they have to enable people to use their hardware in
> > violation of the licensing agreement they implicitly agree to when
> > opening the package?
>
> Since they got permission to distribute the software under the
> condition of passing on the freedoms without imposing further
> restrictions on their exercise.

Okay. Given the interpretation of GPLv2 you seem to have I will grant you this 
point. Personally, I do not feel that the "spirit" of the GPLv2 has anything 
to do with running modified binaries on a "closed" hardware platform (like a 
TiVO). But, as I said, I'll grant you the point, because our views on 
the "spirit" of the GPL and interpretations of it seem to be completely 
incompatible.

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
