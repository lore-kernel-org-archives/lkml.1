Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXFNTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXFNTOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXFNTOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:14:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbXFNTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:14:14 -0400
Date: Thu, 14 Jun 2007 12:13:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
cc: Alexandre Oliva <aoliva@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070614204725.cdf790a7.diegocg@gmail.com>
Message-ID: <alpine.LFD.0.98.0706141204330.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net>
 <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
 <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070614204725.cdf790a7.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Diego Calleja wrote:
> 
> And the FSF is trying to control the design and licensing of hardware throught
> the influence of their software. And I think it's wrong. I'm all to forbid hardware
> that imposes restrictions on hardware, but software licenses are NOT the way
> to make it. That's a task for a "Free Hardware Foundation", not the FSF.

Amen. And btw, opencores.org does actually exist.

I don't even think open hardware is a big issue: the worry-warts about 
hardware are likely wrong, and hardware today is a lot more open than it 
used to be even just a decade ago. You can much more easily design your 
own (FPGA's are cheap and powerful), and yes, it's more complex today, but 
that's actually an argument _for_ openness rather than against it (open 
processes work better in complex environments!).

The real issue is "open content", and we do actually have various 
organizations that support that in particular. I would heartily encourage 
people to get involved with the Creative Commons, and the EFF, and I think 
Larry Lessig is a really smart and articulate person, who you should 
listen to.

> What the FSF is trying to do is EVIL.

I wouldn't go that far (although, in the heat of the moment I probably 
_have_ gone that far. Oops ;).

I don't think the FSF is evil. They're just too single-minded, and look 
too much at one issue, and only care about the one thing they care about, 
and in the process, they tend to have a really hard time seeing the other 
side of the coin.

They define "freedom" one way, and by defining it in a very particular 
way, they miss the fact that what is "freedom" to them is not "freedom" to 
somebody else.

They have a very particular agenda, and in having that agenda and a very 
strict view of how the world should look (according to the FSF), they 
dismiss the fact that other people have _other_ agenda's, and see the same 
world totally differently.

And I think that kind of single-mindedness is silly and 
counter-productive. 

I literally think that the GPLv2 has worked so well exactly because you 
can strip it of its high-falutin' morality and the FSF Kool-Aid, and just 
see it as a "tit-for-tat" license. It allows everybody to see that the 
work they put in (into the _software_) is protected, and people cannot 
make improved versions of that software and distribute those improved 
versions without giving you the right back to use those improvements (to 
the _software_).

So the GPLv2 may have come out of a very single-minded endeavor, but I 
think it ended up being capable of so much more than rms really even 
envisioned, exactly because you don't have to _view_ it in that manner.

		Linus
