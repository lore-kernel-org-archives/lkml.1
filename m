Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbXFNVY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbXFNVY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXFNVYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:24:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbXFNVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:24:46 -0400
Date: Thu, 14 Jun 2007 14:23:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orvedq9s0d.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706141402400.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net>
 <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
 <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org>
 <ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org>
 <orvedq9s0d.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>
> On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> >  - I chose the GPLv2, fully understanding that the Tivo kind of
> >  situation is ok.
> 
> Wow, do you remember the date when you first thought of this business
> model?

You know what? I'm intelligent. That's what you call people who see th 
consequences of their actions. I didn't see the *details* of what all the 
GPLv2 could result in, but yes, I claim that I knew what I was setting 
myself up for (in a license way) pretty much from the beginning.

Did it take me by surprise how people actually ended up using Linux? It 
sure did. But has the GPLv2 itself ever surprised me? Not really. I read 
it back then, and yes, I understood what it meant.

>From the very beginning of Linux, even before I chose the GPLv2 as the 
license, the thing I cared about was that source code be freely available. 
That was the first license, but more importantly, it was why I started 
Linux in the first place - my frustrations with Minix, and my memories of 
how painful it was to find an OS that I wanted to use and work with.

(That, btw, was not Minix-only: I actually originally was thinking about 
literally buying a commercial Unix for my PC too. The price factor kept me 
away from the commercial unixes, and in retrospect I'm obviously very 
happy).

So my first goal was "source must be available and it must be free (as 
in beer)". Which my first copyright license reflects very directly.

What happened a few months into the thing was that some people actually 
wanted to make floppy images of Linux available to Linux users groups, but 
they didn't want to have to actually *fund* the floppies and their work 
themselves, so they wanted to sell them at cost (which the first license 
actually didn't allow!).

And I realized that the money angle really wasn't what I ever really cared 
about. I cared about availability, but people sure could get paid for 
their effort in distributing the thing, as long as the source code 
remained open. I didn't want money, I didn't want hardware, I just wanted 
the improvements back.

So given that background, which license do you _think_ I should have 
chosen?

And given that background, do you see why the GPLv2 is _still_ better than 
the GPLv3? I don't care about the hardware. I'll use it, but it's not what 
Linux is all about. Linux is about something much bigger than any 
individual device.

And yeah, maybe I'm just better at abstracting things. Maybe I prefer 
seeing the big picture, and that the individual devices don't matter. What 
matters is the improvement in the *software*, because while each physical 
device is a one-off thing, in the long term, it's the *development* that 
matters.

And the GPLv2 protects that. 

It's a bit like evolution: individual organisms matter to *themselves* and 
to their immediate neighborhood, but in the end, the individuals will be 
gone and forgotten, and what remains is the development.

In those terms, I care about the DNA, and the *process* or recombination 
and the bigger picture. Any individual organism? Not so much. It's all 
part of a much bigger tapestry, and closed hardware is more like an eunuch 
(or a worker bee): it won't pass on its legacy, but it might help the 
people who do.

So instead of thinking of Tivo as something "evil", I think of Tivo as the 
working bee who will never pass on its genes, but it actually ended up 
helping the people who *do* pass on their genes: the kernel (to a small 
degree - not so much because of the patches themselves, as the *mindshare* 
in the PVR space) and projects like MythTV (again, not so much because of 
any patches, but because it helped grow peoples understanding of the 
problem space!).

Let's take another example: BitKeeper. The FSF follower people seem to 
view BitKeeper as something "evil". To me, BitKeeper was not just a great 
tool, but it also ended up being something that showed others how things 
*could* be done. And the world - including the open source world - is a 
better place for it!

See? In the big picture, individual devices and even projects won't 
matter. In a hundred years, I'll be long dead, and nobody will care. But 
in a hundred years, I hope that the "live and let live" open source 
mentality will still flourish, and maybe "Linux" itself won't live on, but 
some of the memories and impact may. And *that* is what matters.

A Tivo? It's just a toy. Who cares? It's not important. But source code 
that evolves? THAT can change the world!

			Linus
