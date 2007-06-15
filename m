Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXFOPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXFOPqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbXFOPqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:46:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbXFOPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:46:45 -0400
Date: Fri, 15 Jun 2007 08:45:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Daniel Hazelton <dhazelton@enter.net>, Bernd Paysan <bernd.paysan@gmx.de>,
       Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070615130254.GB11830@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
 <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de>
 <200706150633.51857.dhazelton@enter.net>
 <20070615130254.GB11830@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Carlo Wood wrote:

> On Fri, Jun 15, 2007 at 06:33:51AM -0400, Daniel Hazelton wrote:
> > Incorrect. Read section 9 of the GPLv2. It's pretty clear that the "any later 
> > version" clause is optional. Whats more is that since the modern linux kernel 
> > *IS* a "composite work" composed of Linus' original code with changes 
> > contributed by other people - Linus retains copyright to the work as a whole. 
> 
> Huh - surely not to files added to the kernel that were written by
> others from scratch!

Actually, yes. Even to those - when they are part of "the whole".

I'm sorry, but I've learnt more about copyright law, and talked to more 
lawyers about licensing that probably most of the rest of the people 
involved in this discussion have *combined*.

And yes, at least under US copyright law, and at least if you see Linux as 
a "collective work" (which is arguably the most straightforward reading og 
copyright law, but perhaps not the only one) I am actually the sole owner 
of copyright in the *collective* work of the Linux kernel.

The way "collective works" work, there are two separate copyrights: there 
is the copyright in the "separate contribution", which is vests ininitally 
in the author of that contribution (unless he signs over his copyrights, 
often by virtue of working for somebody else).

And then there is the copyright in the "collective work", which would be 
me.

Of course, owning coyright in the "collective work" doesn't actually give 
me complete control anyway. I cannot relicense things in ways that go 
against the rules of the individual works. But in a very real sense, yes, 
I actually do own a certain (*limited*) copyright over even the parts that 
have not been explicitly signed over to me.

And yes, there are other potential ways to describe Linux, and in the end, 
it doesn't really matter. Because the way the GPLv2 works, it makes it 
clear that as long as a piece is a part of the whole, it has to be 
licensed under the GPLv2 and nothing else.

And btw, just to make you feel safe - I cannot do anything about that, 
even if I *do* own the copyright in the collective, because of the 
limitations on what that colletive work copyright implies (it says that I 
have the right to reproduce and distribute, but I don't have the right to 
*modify* except as given to me by the original author!)

So don't worry. I *technically* have certain special rights, but I 
practically speaking gave up most all of those rights by accepting code 
from others under the GPLv2 - since in order to do that, I had to agree to 
be bound by the GPLv2 license myself.

> This is totally new to me - if this is true - I'd really like to be sure!

It would be generally held to be true at least in the US, but it doesn't 
really matter.

> I always thought that it would be necessary to get signatures of each
> and every contributor before you can change a license of a file.

You are mostly correct. The "mostly" comes because I would not say "every 
contributor", but would clarify it by saying "every copyright holder". The 
difference? Not all contributions are necessarily copyrightable. If you 
send in trivial one-liners, we will credit you for them, but that does not 
automatically mean that you necessarily own copyright in something.

But yes, somebody who wrote an original file (that has some artistic 
expression, and isn't just a list of PCI ID's, for example) will be the 
copyright owner in that file. Some *very* few people have actually sent me 
paperwork to transfer the ownership of copyrights, but they seem to have 
done that because they were just used to doing it with the FSF, and I 
actually don't care. 

				Linus
