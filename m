Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXFOQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXFOQWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbXFOQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:22:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36119 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbXFOQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:22:06 -0400
Date: Fri, 15 Jun 2007 18:22:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlo Wood <carlo@alinoe.com>, Daniel Hazelton <dhazelton@enter.net>,
       Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
       Alexandre Oliva <aoliva@redhat.com>, Sean <seanlkml@sympatico.ca>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615162216.GG3588@stusta.de>
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de> <200706150633.51857.dhazelton@enter.net> <20070615130254.GB11830@alinoe.com> <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 08:45:43AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 15 Jun 2007, Carlo Wood wrote:
> 
> > On Fri, Jun 15, 2007 at 06:33:51AM -0400, Daniel Hazelton wrote:
> > > Incorrect. Read section 9 of the GPLv2. It's pretty clear that the "any later 
> > > version" clause is optional. Whats more is that since the modern linux kernel 
> > > *IS* a "composite work" composed of Linus' original code with changes 
> > > contributed by other people - Linus retains copyright to the work as a whole. 
> > 
> > Huh - surely not to files added to the kernel that were written by
> > others from scratch!
> 
> Actually, yes. Even to those - when they are part of "the whole".
> 
> I'm sorry, but I've learnt more about copyright law, and talked to more 
> lawyers about licensing that probably most of the rest of the people 
> involved in this discussion have *combined*.
> 
> And yes, at least under US copyright law, and at least if you see Linux as 
> a "collective work" (which is arguably the most straightforward reading og 
> copyright law, but perhaps not the only one) I am actually the sole owner 
> of copyright in the *collective* work of the Linux kernel.

US law is only relevant for < 5% of all people.

How valid would any action based on US copyright law be in other parts 
of the world?

> The way "collective works" work, there are two separate copyrights: there 
> is the copyright in the "separate contribution", which is vests ininitally 
> in the author of that contribution (unless he signs over his copyrights, 
> often by virtue of working for somebody else).
> 
> And then there is the copyright in the "collective work", which would be 
> me.
> 
> Of course, owning coyright in the "collective work" doesn't actually give 
> me complete control anyway. I cannot relicense things in ways that go 
> against the rules of the individual works. But in a very real sense, yes, 
> I actually do own a certain (*limited*) copyright over even the parts that 
> have not been explicitly signed over to me.
>...

Does this include GPLv2'ed code not intended to be used in the Linux 
kernel submitted by people other than the copyright holder for inclusion 
in the Linux kernel?

If yes, the FSF has exactly the same rights if taking a GPLv2 driver 
from the Linux kernel and including it in GNU Hurd.

> 				Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

