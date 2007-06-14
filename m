Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXFNXu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXFNXu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXFNXuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:50:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXFNXuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:50:19 -0400
Date: Fri, 15 Jun 2007 01:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614235004.GA14952@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexandre Oliva <aoliva@redhat.com> wrote:

> On Jun 14, 2007, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Alexandre Oliva <aoliva@redhat.com> wrote:
> 
> > you are not "entitled" to dictate the hardware's design (or any 
> > other copyrighted work's design),
> 
> Agreed.

hey, that's progress. If you concede this single point then your 
arguments about the Tivo situation all fall like domino stones. Just 
watch it happen please:

> > By your argument we'd have to put the following items into the 
> > license too:
> 
> No, you're confusing two very different situations.
>
> In the case of TiVO, it's getting out of its way to make sure users 
> can't enjoy one of the freedoms that the license says it ought to pass 
> on.

the GPLv2 license says no such thing, and you seem to be mighty confused 
about how software licenses work.

the GPL applies to software. It is a software license.

the Tivo box is a piece of hardware.

a disk is put into it with software copied to it already: a bootloader, 
a Linux kernel plus a handful of applications. The free software bits 
are available for download.

the Tivo box is another (copyrighted) work, a piece of hardware.

so how can, in your opinion, the hardware that Tivo produces, "take 
away" some right that the user has to the GPL-ed software? Because they 
distribute the software and the hardware in the same package, and 
because the hardware (as _ALL_ hardware on this planet) has certain 
limitations? It was _your_ choice to buy that particular 
hardware+software combination, with whatever limitations the hardware 
has. One such limitation of the hardware might be that its color is 
butt-ugly pink. Another limitation might be that the buttons on it are 
too small for elderly people to press. A third limitation might be that 
it's not a general purpose computer and that it's not freely 
programmable by the end user. Bugger, what did you expect? Why didnt you 
buy a green PVR? Why didnt you buy a PVR with larger buttons? Why didnt 
you buy a general purpose computer? Did perhaps the Tivo look like a 
nice general purpose PC to you when you bought it?

> In the cases you mentioned, the company would have to get out of its 
> way to put the other parties on equal grounds.

how about quoting what i wrote and rebutting it specifically if you 
disagree with it, instead of writing a non-sequitor generality? You are 
involved in compiler development, so you should have the mental ability 
to follow logical arguments and you should be able to conduct a 
meaningful and objective discussion. Lets look at one of the examples i 
gave you:

> > - free access to all the hardware diagnostics tools that the 
> > hardware maker has. (Without that it might be impossible to modify 
> > the software as efficiently as the hardware maker's own engineers 
> > can do it.)

by your argument, the user has some "right to modify the software", on 
that piece of hardware it bought which had free software on it, correct? 
By your argument, the "right to modify the software" becomes meaningless 
if you cannot soft-upgrade your Tivo, if you have solder off the ROM to 
install your own ROM with a bootloader that does not do the SHA1 check, 
correct?

But by that _very same argument_, you are hindered _much more_ by not 
having proper hardware diagnostics tools and no access to hardware 
specifications. If you dont know how the hardware works, you cannot fix 
bugs in the software. So by your argument, the user has an inherent 
right to get on equal footing with the hardware manufacturer to modify 
the software on that specific hardware? There's no ifs and when. "having 
to solder off the ROM" is a "restriction on modifiability" just as much 
as "having less information about the hardware's inner workings". In 
fact, ask any kernel developer, "having to solder off the ROM" is a lot 
_smaller_ restriction than "having no information about the hardware's 
inner workings".

	Ingo
