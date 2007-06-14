Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbXFNXcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbXFNXcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXFNXbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:31:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbXFNXby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:31:54 -0400
Date: Thu, 14 Jun 2007 16:31:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Daniel Hazelton <dhazelton@enter.net>, Chris Friesen <cfriesen@nortel.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <or8xam87h1.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706141616530.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <46718044.1040108@nortel.com>
 <orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br> <200706141848.55378.dhazelton@enter.net>
 <or8xam87h1.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Damn. I moved you to my flamers list, and then I started reading it. I'm 
  addicted to flaming. Sue me. I really do enjoy it too much. If I didn't 
  do software development, my full-time job would probably be to troll 
  various internet sites and try to set up flame wars. I'm bad, I know. 

  It's an addiction. I'm not proud. ]

On Thu, 14 Jun 2007, Alexandre Oliva wrote:
> 
> But then again I ask you: why do you think TiVO is making these
> hardware locks?  What do they want to cause or stop?

Actually, they didn't want to lock down the hardware at all. The first 
versions of the Tivo was really quite hackable - and people started 
hacking them.

They were basically forced to add lockdown by the content vendors. You can 
call them evil for "caving in", but hey, it was their whole market. They 
really had no choice. Being a company actually limits you in some ways..

If you don't want to cave in to content providers, use a regular PC and 
soemthing like MythTV. You will probably also have to use the analogue 
hole, and will have a really hard time unscrambling digital cable TV 
signals of your own, but hey, you can see it as a challenge. At least in 
places where it's not illegal.

And yes, there are bad laws in the US. But blaming Tivo for them is 
ludicrous. And the *laws* won't get fixed by software licensing either, 
quite the reverse. The GPLv3 will just make free software that uses it 
*less* relevant in that space, rather than more.

For example, I'd rather have some GPLv2'd DVD player software that does 
*not* come with a de-css key (I can get that key myself quite easily), and 
that thus gets distributed in a "useless" form, than have a GPLv3'd DVD 
player that cannot be distributed at all, because it needs the magic 
unlocking key, and distributing the css key is illegal in some countries.

Or if I was an mplayer developer (which I'm not - so I have absolutely 
*zero* say in the mplayer license - please don't take this as anythign 
like that), I'd prefer for mplayer to be GPLv2, simply because that way I 
could see my software in some high-end (legal) DVD players that actually 
complied with the insane laws that exist. Sure, to comply with the laws 
and not get sued, they might have to limit the hardware, but hey, in other 
saner places of the world (like Finland), you can use the GPLv2'd software 
legally *without* those concerns.

See? The more permissive license actually allows more people to get 
involved. And the only thing that really *matters* (the source code) can 
be distributed and improved on by all these different people, even if some 
of them may have their hands bound by legal issues.

Btw, the same is true of things like FCC rules in the US. All that is evil 
does not come from the RIAA and MPAA. It's entirely possible that a 
cellphone manufacturer would have to lock down the control logic that sets 
the power levels - and that is something that is against the license of 
the GPLv3.

So the GPLv3 actually _hinders_ people who might otherwise help the 
community from helping, by making the license so strict that those people 
(who are nice people, but have their options limited by stupid laws and 
regulations) cannot use the GPLv3.

			Linus
