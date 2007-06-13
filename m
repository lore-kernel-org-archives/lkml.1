Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXFMXDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXFMXDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbXFMXDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:03:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576AbXFMXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:03:21 -0400
Date: Wed, 13 Jun 2007 16:02:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
 <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
 <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
 <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br> <20070613211432.GH10008@csclub.uwaterloo.ca>
 <orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jun 2007, Alexandre Oliva wrote:
> 
>   [...] Our General Public Licenses are designed to make sure that you have
>   the freedom to distribute copies of free software (and charge for
>   this service if you wish), that you receive source code or can get
>   it if you want it, that you can change the software or use pieces of
>   it in new free programs; and that you know you can do these things.
> 
>   To protect your rights, we need to make restrictions that forbid
>   anyone to deny you these rights or to ask you to surrender the
>   rights.  These restrictions translate to certain responsibilities
>   for you if you distribute copies of the software, or if you modify
>   it.
> 
>   [...] if you distribute copies of such a program, whether gratis or
>   for a fee, you must give the recipients all the rights that you have
> 
> 
> Can anyone show me how any of the provisions of GPLv3 fails to meet
> this spirit?

What kind of logic is that? It sounds like "Can you prove that God doesn't 
exist?"

The fact is, Tivo didn't take those rights away from you, yet the FSF says 
that what Tivo did was "against the spirit". That's *bullshit*.

So the whole "to protect these rights, we take away other rigths" argument 
hinges on the false premise that the new language in GPLv3 is somehow 
needed. It's not. You still had the right to distribute the software (and 
modify it), even if the *hardware* is limited to only one version.

In other words, GPLv3 restricts rights that do not need to be restricted, 
and yes, I think that violates the spirit of the GPLv2 preamble!

Think of it this way: what if the GPLv3 had an addition saying "You can 
not use this software to make a weapon". Do you see the problem? It 
restricts peoples rights, would you agree? Would you _also_ agree that it 
doesn't actually follow that "To protect your rights" logic AT ALL?

And this is exactly where the GPLv3 *diverges* from the above logic. If I 
build hardware, and sell it with software installed, you can still copy 
and modify the software. You may not do so within the confines of the 
hardware I built, but the hardware was never under the license in the 
first place.

In other words, GPLv3 *restricts* peoples freedoms more than it protects 
them. It does *not* cause any additional stated freedoms - quite the 
reverse. It tries to free up stuff that was never mentioned in the first 
place.

And then the FSF has the gall to call themselves the "protector of 
freedoms", and claim that everybody else is evil. What a crock. 

In other words, if you want to argue for the changes in GPLv3, you need to 
CHANGE THE PREAMBLE TOO! You should change:

	When we speak of free software, we are referring to freedom, not
	price.  Our General Public Licenses are designed to make sure that you
	have the freedom to distribute copies of free software (and charge for
	this service if you wish), that you receive source code or can get it
	if you want it, that you can change the software or use pieces of it
	in new free programs, that you can do so in place on your devices, 
        even if those devices weren't licensed under the GPL;  and that 
        you know you can do these things.

where I added the "that you can do so in place on your devices, even if 
those devices weren't licensed under the GPL".

That wasn't there in the original. Yet it's what the GPLv3 tries to shove 
down our throats in the name of "freedom".

I don't know if you've followed US politics very much over the last six 
years, but there's been a lot of "protecting our freedoms" going on. And 
it's been ugly. Maybe you could realize that sometimes "protecting your 
freedom" is *anything*but*!

		Linus
