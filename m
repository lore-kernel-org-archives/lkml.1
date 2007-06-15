Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXFOSAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXFOSAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXFOSAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:00:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbXFOSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:00:32 -0400
Date: Fri, 15 Jun 2007 10:59:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Carlo Wood <carlo@alinoe.com>, Daniel Hazelton <dhazelton@enter.net>,
       Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
       Alexandre Oliva <aoliva@redhat.com>, Sean <seanlkml@sympatico.ca>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070615162216.GG3588@stusta.de>
Message-ID: <alpine.LFD.0.98.0706151030530.14121@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
 <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de>
 <200706150633.51857.dhazelton@enter.net> <20070615130254.GB11830@alinoe.com>
 <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
 <20070615162216.GG3588@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Adrian Bunk wrote:
> 
> US law is only relevant for < 5% of all people.
> 
> How valid would any action based on US copyright law be in other parts 
> of the world?

I tried to explain that in the case of the Linux kernel, we really don't 
care, since in the end, what matters is the GPLv2, and I have bound myself 
to the terms of that license *regardless* of any US law.

So yes, US law is only relevant for < 5% of all people, but in the 
specific case of the kernel, even that US law isn't _really_ all thgat 
relevant at all, not *even* to those 5% ;)

So I *really* hope you took my explanation of why I actually have more 
rights than others as a nitpicking "legal detail", not as a "I own your 
very SOUL, bow down before me!" kind of thing.

But to answer your question by _another_ nitpicking answer, as the 
original author, I probably do have some special legal status even in 
Europe, and probably in other places too. The fact that others *extended* 
on my original work doesn't take away the special place of original 
authorship, even if the extended version has a totally different form (ie, 
a movie based on a book ends up still havign the original author of the 
book holding special rights - and in fact those rights are in some cases 
much *stronger* in Europe than they are in the US).

For example, Europe recognizes "moral rights" in original authorship, in 
ways that it is much harder to enforce (if at all) in the US.

But as mentioned, since I myself has bound myself to the GPLv2, that 
really is a pretty damn theoretical argument. When it comes to the kernel, 
I'm "Primus inter pares", if you wish.

("First among equals", for the non-latin-speaking world ;)

> Does this include GPLv2'ed code not intended to be used in the Linux 
> kernel submitted by people other than the copyright holder for inclusion 
> in the Linux kernel?

In the US sense of "within the compilation", probably yes. Ie that right 
is tied to *linux* as a compilation. In the European sense of "moral 
rights", no - that right is very much tied to original authorship (so I, 
as original author of Linux, have some rights with respect to Linux, but 
on the other hand, they, as the original authors of some specific code, 
have some specific rights wrt that code!)

> If yes, the FSF has exactly the same rights if taking a GPLv2 driver 
> from the Linux kernel and including it in GNU Hurd.

The FSF does indeed have special rights wrt Hurd, regardless of where the 
code in question has come from (as long as it came there *legally*, of 
course!). So when it comes to Hurd, they have the copyright in the 
compilation of that (and Red Hat as their copyright in their RHEL 
distribution - of which the kernel is just a small part!).

It's a confusing set of nesting dolls of different levels of copyrights, 
and the GPLv2 makes it all pretty much irrelevant, by being the thing that 
cuts through all the other licensing issues!

			Linus
