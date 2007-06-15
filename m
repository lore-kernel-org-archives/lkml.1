Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbXFODXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbXFODXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXFODXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:23:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbXFODXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:23:39 -0400
Date: Thu, 14 Jun 2007 20:22:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Poole <mdpoole@troilus.org>
cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <878xal2a0q.fsf@graviton.dyn.troilus.org>
Message-ID: <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <200706142049.41819.dhazelton@enter.net> <87fy4u0xty.fsf@graviton.dyn.troilus.org>
 <200706142246.57583.dhazelton@enter.net>
 <878xal2a0q.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Michael Poole wrote:
>
> If the DRM signature and program executable are coupled such that they
> are not useful when separated, the implication to me is that they form
> one work that is based on the original Program.  This is beyond the
> GPL's permission for "mere aggregation".

So you want to make things like a 160-bit SHA1 hash of a binary be a 
"derived work" of that software?

Trust me, you *really* don't want to go there. It's an insane legal 
standpoint, and if you were right, we'd be in a *world* of trouble.

Think about something as simple as security software that creates 
filesystem checksums for verifying the integrity of the filesystem, and 
protects against tampering.

Do you *really* want to claim that the SHA1 checksum of your "oracle" 
binary is owned by Oracle, and you need to have a special license to copy 
that checksum around and verify it?

Do you *really* want to claim that the RIAA owns the CDDB checksums (well, 
I guess "feedb", these days) of the CD's that get uploaded for music 
databases? 

Do you realize that in your INSANE world, there is no notion of "fair 
use", and you just tried to extend the notion of copyright so far that you 
turned your utopia into a total distopia.

In other words, anybody who claims that copyright in a program extends to 
the cryptographic hash of the binary, and at the same time makes a "free 
software" kind of argument is so damn clueless that it's not even funny. 
You're arguing for "freedom" by using logic that is the very *antithesis* 
of freedom.

That's just incredibly stupid and incredibly short-sighted. 

If that were to seriously be an FSF argument, then I would officially lump 
the FSF as a *much*worse* danger to the free world than the RIAA and the 
MPAA combined!

I seriously doubt you really thought your idea through! Because it goes 
beyond stupid.

			Linus
