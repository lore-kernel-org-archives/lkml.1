Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbXFNAmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbXFNAmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 20:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXFNAmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 20:42:16 -0400
Received: from keil-draco.com ([216.193.185.50]:50831 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbXFNAmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 20:42:15 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 20:42:02 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org> <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200706132042.02728.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 19:49:23 Alexandre Oliva wrote:
<snip>
> > The fact is, Tivo didn't take those rights away from you, yet the FSF
> > says that what Tivo did was "against the spirit". That's *bullshit*.
>
> Oh, good, let's take this one.
>
>   if you distribute copies of such a program, [...]
>   you must give the recipients all the rights that you have
>
> So, TiVo includes a copy of Linux in its DVR.
>
> TiVo retains the right to modify that copy of Linux as it sees fit.
>
> It doesn't give the recipients the same right.
>
> Oops.
>
> Sounds like a violation of the spirit to me.
>
> Sounds like plugging this hole would retain the same spirit.

Are you an idiot, or do you just choose to ignore all proof that doesn't fit 
your preconceived beliefs? TiVO gives you every right to the Linux kernel 
that they recieved. What they don't give you the right to do is use modified 
versions on their *HARDWARE* - which they have *NEVER* given you any rights 
to, except for "normal use". (And no, it isn't legal to put those 200G hard 
drives in your TiVO no matter what you think) 

> > In other words, GPLv3 restricts rights that do not need to be restricted,
>
> That's correct.  They don't need to be restricted.  The whole idea of
> copyleft, implemented through the GPL, is not based on needs, but
> rather on the wish to defend the freedoms established in the preamble
> from those who would rather not respect them.
>
> Do you deny that TiVo prevents you (or at least a random customer)
> from modifying the copy of Linux that they ship in their DVR?

Exactly. They don't. What TiVO prevents is using that modified version on 
their hardware. And they have that right, because the Hardware *ISN'T* 
covered by the GPL.

Do you understand that, or do I need to break out the finger-puppets next ?

> Do you deny that they can still do it themselves?
>
> > Think of it this way: what if the GPLv3 had an addition saying "You can
> > not use this software to make a weapon".
>
> This would make GPLv3 a non-Free Software license.
>
> But the GPLv3 last call draft doesn't say anything along these lines.
>
> You can use the software as much as you like, even in DVRs, and even
> to implement DRM in them, as long as you respect the users' freedoms
> to change and share the software.  Per the GPLv3 (paraphrased), if it
> is possible to install modified versions of the covered program in the
> device, you must tell the recipient how to do it.  Otherwise, the
> freedom to modify the program is being too severely limited.

And this unnaturally restricts the freedom of hardware manufacturers. If they 
add a custom, internal connector so a repair shop can restore the hardware to 
its *FACTORY* state then it is "possible to install modified versions", 
provided the person doing it has the specialized hardware needed.

And this is what the FSF, RMS and yes, *YOU*, Alexandre, fail to realize - the 
GPL covers *ONLY* the software. It has *ZERO* legal standing when applied to 
hardware. Not even the most draconian of MS EULA's tries to apply itself to 
the hardware.

In the case of 99% of the hardware targeted by the clause of the GPLv3 you 
elucidate on, the "ability to install modified versions of the software" was 
*NOT* intended for that use, nor was it intended for *ANYONE* *EXCEPT* 
trained service personell to have *ACCESS* to that functionality. Arguing 
otherwise is just idiotic - I have never found a piece of "high tech" 
hardware (like a TiVO) that was designed for the end-user to modify. (yes, 
installing a new version of the linux kernel is "modifying" the system)

> And, in the particular case of TiVo, it's a case of distributing
> incomplete source code, of refraining from including functional
> portions of the source code.

And? They distribute the kernel source - as they recieved it - in compliance 
with the GPL. Their additions - whether they be "modules" or just the UI - do 
not, necessarily, fall under the GPL. (Yes, there have been discussions about 
whether a kernel module is a derived work, but most of the time those 
discussions ended "Legally they aren't, even though I feel they should be")

> > In other words, GPLv3 *restricts* peoples freedoms more than it
> > protects them.
>
> While you look at it from the point of view of TiVo, who wants to be
> free to prohibit people from modifying the workings of the device it
> sells while it can still modify it itself, and it does that in order
> to prohibit people from removing locks that stop them from doing
> things they're legally entitled to do, I see a lot more prohibitions
> than freedoms in what TiVo does.  I don't understand why you'd stand
> up for it.  Is it more important that a single company be allowed to
> impose prohibitions on others in order for its business model to work,
> than to maintain the spirit of hacking and sharing that enabled Free
> Software and Linux to flourish?

What "Legally Entitled" things?

And... You do realize that almost every difference between the GPLv2 and the 
GPLv3 is going to cause a hell of a lot of problems? The fact that the GPLv3 
is designed to prevent things that RMS *PERSONALLY* finds distasteful - DRM 
and the like - is a big turn-off for a *LOT* of people. (Personally I don't 
like *ANY* version of the GPL, because there are chunks I have problems with)

> Do you expect Linux would have flourished if computers had locks that
> stopped people from modifying Linux in them?

But you aren't talking about a "computer" here. You're talking about a 
mass-market device that must comply with both US and International copyright 
law - and that's just a TiVO. Other devices have other laws they have to 
comply with - in the US the FCC's regulations control all radio devices, so 
if you upload a modified linux kernel to your wireless router that gives it a 
2000 foot range, you've just broken the law *AND* violated the license on the 
hardware which states that you "won't modify it or the controlling 
software" - in most cases "the controlling software" is just the firmware, 
but with modern wireless hardware, the firmware is loaded by the OS.

> > where I added the "that you can do so in place on your devices, even if
> > those devices weren't licensed under the GPL".
>
> You're mistakenly focusing on the device.  As you say, the device is
> not under the license.

But he isn't. The GPLv3 says, and I'll quote you here - "Per the GPLv3 
(paraphrased), if it is possible to install modified versions of the covered 
program in the device, you must tell the recipient how to do it."

>From the latest version of the GPLv3:
"Installation Information" for a User Product means any methods, procedures, 
authorization keys, or other information required to install and execute 
modified versions of a covered work in that User Product from a modified 
version of its Corresponding Source. The information must suffice to ensure 
that the continued functioning of the modified object code is in no case 
prevented or interfered with solely because modification has been made.

and:

If you convey an object code work under this section in, or with, or 
specifically for use in, a User Product, and the conveying occurs as part of 
a transaction in which the right of possession and use of the User Product is 
transferred to the recipient in perpetuity or for a fixed term (regardless of 
how the transaction is characterized), the Corresponding Source conveyed 
under this section must be accompanied by the Installation Information. But 
this requirement does not apply if neither you nor any third party retains 
the ability to install modified object code on the User Product (for example, 
the work has been installed in ROM).

So it's not just a designed in ability to run modified code - ie: running of 
modified code is a feature meant for the user to take advantage of - but even 
things like the connectors used to upload the operating software at the 
factory that people now cannot have in a device that runs GPL(v3) covered 
software unless they ship the related "Installation Information". In other 
words, companies are no longer allowed to have a completely separate license  
for hardware and software.

That, to me, reads like RMS got mad about TiVO and said "I don't like it, lets 
add a clause making it wrong to the next GPL". Hell, that *IS* what happened, 
and nothing the FSF or Eben Moglen says will convince me otherwise. It's the 
same for the bits that were added after Novell signed their agreement with 
MS. 

> What's under the license is the software in it.  And that license
> spirit requires the distributor to pass on the right to modify the
> software.

And since when did they have to enable people to use their hardware in 
violation of the licensing agreement they implicitly agree to when opening 
the package?

There is *NOTHING* stopping you from doing whatever you want with the code 
that runs on a TiVO (or any similar device). You (and everyone that thinks 
like you) are confusing a want to use the *HARDWARE* however you want with 
your GPL granted "right" to do what you want with the *SOFTWARE*.

> > I don't know if you've followed US politics very much over the last
> > six years, but there's been a lot of "protecting our freedoms" going
> > on. And it's been ugly. Maybe you could realize that sometimes
> > "protecting your freedom" is *anything*but*!
>
> Is this why you're overreacting?

No, he's making a point. RMS and the FSF, in drafting GPLv3 to include the 
language and clauses it does, is "protecting your freedom" the way a lot of 
the post 9/11 changes to the US Federal code does it. (ie: by saying "no, you 
can't do that anymore")

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
