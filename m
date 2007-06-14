Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbXFNRPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbXFNRPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXFNROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:14:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35065 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753628AbXFNROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:14:52 -0400
Date: Thu, 14 Jun 2007 19:15:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614171504.GT3588@stusta.de>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net> <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net> <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu> <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 09:01:32AM -0700, Linus Torvalds wrote:
> On Thu, 14 Jun 2007, Adrian Bunk wrote:
> > 
> > Here in Germany, the rules at court are roughly "the loser pays 
> > everything including the costs of the winner", so if a big company is 
> > sure they will win at court there's no reason not to go there.
> 
> Well, the thing is (and I've said this before), a lawsuit is (and _should_ 
> be) very much a last resort.
> 
> I think that the Open Source community (and the FSF too) is much better 
> off *not* concentrating so much on "legal rules" of what can and cannot be 
> done, and instead spend much more effort on showing people why the whole 
> "Open Source" thing actually works.

I'm wondering more and more why you choose the GPL and not the BSD 
licence for the Linux kernel...

Companies are violating the GPL and this only works as long as noone 
starts taking legal actions against them.

And taking legal actions easily takes all of your fortune at risk.

> And in fact, I think that's _exactly_ what Linux has been doing for the 
> last decade!
> 
> A lot of companies are actually doing the Right Thing (tm).
> 
> Not because of anybody "forcing" them, but because they have literally 
> bought into the whole "Open Source can do things better" mentality. 

And there are some companies for whom it's better if they can take the 
open source code and turn it into some closed thing. There's a reason 
why TiVo warned it's investors that the GPLv3 might hurt their business.

> In fact, the whole "coercive" approach is counter-productive. It makes 
> people dislike you. It makes companies _resist_ open source, rather than 
> see it as a potential ally. 

And what are the risk of your allies actions?

Consider e.g. that your ally AMD offers legally questionable non-GPL 
modules and Debian shipping binaries.

If one of the many copyright holders of the kernel wants to take legal 
actions against this suing AMD might simply be out of reach due to 
financial reasons.

But legal actions against the maintainers of ftp.<your_country>.debian.org 
distributing binaries of these legally questionable modules have a good 
chance of success.

The legal risks might not be a problem for a big company like AMD, but 
anyone seeking an easy legal win will _naturally_ attack mirrors.

And considering the lucratice "cease and desist letter" business in 
Germany, it really seems to be only a matter of time until mirrors will 
have to pay (the lawyer costs of the ones sending the cease and desist 
letters) for the actions of your "allies".

> And no, I'm not speaking out of my *ss. Anybody who goes back fifteen 
> years and looks at how the FSF was acting wrt the GPL (v2, back then), and 
> how many friends - and enemies - they were making, should see that as a 
> big clue. Linux really *did* change the landscape - for the better (*). By 
> being much less contrary.
> 
> So look at Intel in the open source space. They're doing well. Look at 
> Sun. They aren't _forced_ to open-source, they see others open-sourcing, 
> and they see that it works damn well.

Look at AMD.
Look at NVIDIA.

Will they ever switch from providing illegal modules to open source?

> In the "Tivo space", look at Neuros. 
> 
> In other words, we're just *much* better off with a friendly license and 
> not trying to force people to choose sides, than with the rabid idealism 
> that was - and still is - the FSF. The FSF always makes for this horrible 
> "you're with us, or you're against us" black-and-white mentality, where 
> there are "evil" companies (Tivo) and "good" companies (although I dunno 
> if the FSF really sees anybody as truly "good").
> 
> I'd much rather just see "individuals" and "companies". They're not evil 
> or good, they are all in it for their own reasons (and their reasons are 
> *NOT* the same reasons they are for me, you, or anybody else), and we 
> should show them that the whole "Open Source" approach really does work 
> for them.
>...

Until someone starts to attack ftp mirrors and other people distributing 
the questionable code.

There are so many copyright holders of the Linux kernel (including e.g. 
the former Caldera), and if someone wants to spread fear among Linux 
users legal actions against people maintaining ftp mirrors or selling 
their old Linux distribution at ebay will be the cheap and effective way 
to achieve this goal.

> 			Linus
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

