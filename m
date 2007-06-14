Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXFNXgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXFNXgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXFNXgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:36:18 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:52321 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXFNXgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:36:16 -0400
Date: Fri, 15 Jun 2007 08:34:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614233449.GA27490@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Alexandre Oliva <aoliva@redhat.com>,
	Daniel Hazelton <dhazelton@enter.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
	"david@lang.hm" <david@lang.hm>,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706132042.02728.dhazelton@enter.net> <ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132347.42371.dhazelton@enter.net> <orfy4vhyni.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614073232.GB22543@linux-sh.org> <ormyz2fp8p.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ormyz2fp8p.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:57:26PM -0300, Alexandre Oliva wrote:
> On Jun 14, 2007, Paul Mundt <lethal@linux-sh.org> wrote:
> > I don't see how you can claim that the vendor is infringing on your
> > freedom, _you_ made the decision to go out and buy the product knowing
> > that the vendor wasn't going to go out of their way to help you hack
> > the device.
> 
> But I also made this decision fully aware that the software included
> in the package was published under a license that said I was entitled
> to modify it.

And you certainly are free to do so. The vendor ships the product with
the binaries, and you get the source as a result. You can in turn modify
that source and do whatever you like with it. If the vendor is more
proactive, they may have even tried to get all of their changes merged by
the time the product hit the market, so they wouldn't be sitting on
anything "special" anyways.

This however has nothing to do with your ability to apply those changes
to the _hardware_. If the vendor doesn't want to, or is unable to support
third-party modifications on their product, they have the basic right to
make that decision, as you have the basic right not to buy the product if
this is something that's going to be a problem for you.

> More than once I purchased a device that claimed to have GNU/Linux
> software on it, only to find out that I couldn't use the freedoms,
> because the distributor was infringing the license in various ways.
> 
In this example, at _no time_ did the vendor infringe on the license.
They haven't given you an easy way to change the hardware, but they're
completely compliant both in terms of the letter and the spirit
(depending on how they work with the community) of the license.

If you're trying to pretend that GPLv2 had _anything_ to say about
hardware, you'd be wrong. In such a situation, there'd hardly be a "need"
(as you seem to see it) for GPLv3 at all. If you think this bizarre
coupling of the hardware/software paradigm is in any way constructive,
you're of course welcome to use the GPLv3, but this does not
retroactively change the terms of the GPLv2 simply because you saw this
as an area that was apparently "lacking".

And on the other hand, you're more than welcome to dual-license all of
your kernel changes under v2/v3 if you really feel that that's the best
way to go, just as I'm welcome to print out and burn the GPLv3 as a
symbolic gesture. Simply because some folks have no intention of ever
supporting v3 doesn't stop you from using it on any of your own changes.
