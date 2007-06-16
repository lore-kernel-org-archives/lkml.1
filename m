Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXFPBa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXFPBa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 21:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXFPBaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 21:30:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbXFPBaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 21:30:13 -0400
Date: Fri, 15 Jun 2007 18:29:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rob Landley <rob@landley.net>
cc: Michael Gerdau <mgd@technosis.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <200706152103.06921.rob@landley.net>
Message-ID: <alpine.LFD.0.98.0706151814380.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <200706150825.15491.mgd@technosis.de> <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
 <200706152103.06921.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Rob Landley wrote:
> 
> Technically what they're holding back is _trademark_ rights, which are a 
> different area of IP law and not addressed by the GPL.  (I know you know 
> this, but just for the record...)

No, technically Red Hat really *does* have copyrights of their own.

Red Hat owns the "compilation copyright" on their distribution. That 
means, for example, that even if they have _only_ open source programs on 
their DVD image, you still are not necessarily able (without their 
permission) to set up a "cheap-cd's" kind of operation, and sell their 
CD-ROM/DVD images for a lower price.

So yes, they do own the Red Hat trademark too, but they fundamentally do 
own copyrights over and beyond those of the individual programs they 
distribute!

Now, I think it so happens that the RHEL DVD's contains other programs 
than just open source, and that you couldn't legally copy them *anyway*, 
but that's a different issue.

Also, happily, a lot of vendors do not *want* to exercise their 
copyright in the compilation, so you can go to cheapbytes.com, and you'll 
find Fedora CD's, OpenSuSE CD's, Ubuntu CD's, etc, and as far as I know, 
they're all perfectly legal. Exactly because open-source vendors usually 
don't want to look nasty by limiting the compilation, when they can't 
really limit the individual parts anyway.

> The five main areas of IP law as I understand them are copyright, patent, 
> trademark, contract, and trade secret.

I'd not put contract there, but fair enough. But what I was really trying 
to point out is that there are many different "levels" of copyright.

So you can own a "copyright in the compilation" - which just means that 
you own the details of how you set it all together - _without_ actually 
necessarily owning the copyrights in any of the individual packages 
(although you obviously have to have a license to _make_ a compilation of 
them - but the GPLv2 is one such license).

			Linus
