Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbXFOF1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbXFOF1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbXFOF1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:27:33 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50218 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbXFOF1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:27:32 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Michael Poole <mdpoole@troilus.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 01:27:17 -0400
User-Agent: KMail/1.9.6
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org>
In-Reply-To: <878xal2a0q.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150127.18069.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 23:04:37 Michael Poole wrote:
> Daniel Hazelton writes:
> > On Thursday 14 June 2007 22:13:13 Michael Poole wrote:
> >> The fundamental reason for this is that neither the executable code
> >> nor the digital signature serves the desired function alone.  The user
> >> received a copy of the executable for a particular purpose: to run the
> >> program on a particular platform.  With DRM signatures, only the
> >> combination of program and signature will perform that function, and
> >> separating the two based on strictly read legal definitions is risky.
> >
> > I agree.
> >
> >> The question of whether DRM signatures are covered by the license must
> >> be resolved before one can determine whether Tivo gave "*EXACTLY*" the
> >> same rights to object-code recipients as Tivo received.  GPLv2 is
> >> worded such that the answer to this does not depend on whether one is
> >> in file A and the other in file B, or whether one is on hard drive C
> >> and the other is in flash device D, as long as they are delivered as
> >> part of one unit; it *might* matter if, say, one is received on
> >> physical media and the other is downloaded on demand.
> >
> > I have read the GPLv2 at least three times since it was pointed out that
> > I had forgotten part of it. At no point can I find a point where Tivo
> > broke the GPLv2 requirement that they give the recipients of the object
> > code the same rights they received when they acquired a copy of the
> > object or source code.
>
> I am trying to reconcile your responses to those two paragraphs.
>
> If the DRM signature and program executable are coupled such that they
> are not useful when separated, the implication to me is that they form
> one work that is based on the original Program.  This is beyond the
> GPL's permission for "mere aggregation".
>
> If they are one work, and the original Program was licensed under the
> GPLv2, the combined work must also be licensed under the terms of the
> GPLv2.
>
> The input files required to generate a DRM-valid digital signature are
> part the preferred form for modifying that work.
>
> If those bits are not distributed along with the rest of the GPL'ed
> work, the distributor is either not giving the same rights to the end
> user, not distributing the source code for the work, or both.  Which
> is it?

Following your logic it would be a "failure to distribute the source code for 
a work".

However, since the signing is an automated process it cannot generate a "new" 
work - at least, not under the laws of the US - so the signature itself 
cannot have a copyright at all.

DRH
PS: This is the exact same reason that the GPL cannot apply to a Bison 
generated parser in the US. The "input" file that causes Bison to generate 
the output can have a copyright, but not the output - no matter what RMS or 
anyone else wants, and no matter what the GPL says about it.

>
> Michael Poole



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
