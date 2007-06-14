Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXFNWwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXFNWwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXFNWwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:52:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbXFNWwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:52:41 -0400
Date: Thu, 14 Jun 2007 15:52:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net>
 <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
 <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <20070614131409.9a5800dc.seanlkml@sympatico.ca>
 <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
 <orzm32cr8v.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org>
 <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141311330.14121@woody.linux-foundation.org>
 <orir9q9rgl.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141424160.14121@woody.linux-foundation.org>
 <orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Alexandre Oliva wrote:
> 
> Hmm...  So, if someone takes one of the many GPLv2+ contributions and
> makes improvements under GPLv3+, you're going to make an effort to
> accept them, rather than rejecting them because they're under the
> GPLv3?

You *cannot* make GPLv3-only contributions to the kernel.

I'm sorry, but that's how it is. You can take some of the code that is 
GPLv2+ in the kernel, and MOVE IT TO ANOTHER PROJECT, and use them there. 
But not within the confines of the Linux kernel. Within the Linux kernel, 
the GPLv2 rules - and "GPLv2+" becomes just "GPLv2", since the GPLv3 is 
not compatible with v2.

This is no different from the fact that we have some drivers that are 
GPLv2/BSD licensed. Within the kernel, they are GPLv2. But on their own, 
you can choose to use them under the BSD license, make your changes to 
them, and release them commercially.

And correct - I cannot (and neither can anybody else) then accept those 
*non*GPLv2 changes back.

> I understand.  I assumed you had some trust that people would abide by
> your wish to permit TiVOization, and that authors of modifications
> were entitled to make "whatever restrictions they wanted" on their
> code.

Actually, normally I *do* have such a trust. It's why I have no problem 
with drivers that are dual-GPL/BSD, and in fact, I've told people that I 
don't want them to turn them into GPL-only, because that is simply not 
polite.

But I hold *myself* to higher standards than I hold others. And in 
particular, when it comes to people with a religious agenda, I don't 
expect them to be polite or take my feelings into account. I expect (from 
good history) that people with a license agenda will consider the license 
agenda more important than any hurt feelings, or any wishes of mine. 

> Pardon me if I think your position is at least somewhat incoherent.
> Can you help me make sense of it?

I'm giving up. I'm moving you to my "flamers" list, so that your emails go 
to a separate mailbox that I read weekly. I've wasted too much time with 
you, your arguments don't make sense, and you seem to refuse to even _try_ 
to understand my position, or respect the fact that my choice of license 
is MY choice, and that I actually have a brain of my own.

		Linus
