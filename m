Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbXFOCNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbXFOCNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXFOCNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:13:15 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:43426
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbXFOCNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:13:14 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706141640.17217.dhazelton@enter.net>
	<orabv29qtk.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706142049.41819.dhazelton@enter.net>
From: Michael Poole <mdpoole@troilus.org>
Date: Thu, 14 Jun 2007 22:13:13 -0400
In-Reply-To: <200706142049.41819.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 20\:49\:41 -0400")
Message-ID: <87fy4u0xty.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton writes:

> What rights did they give to "downstream" recipients of the "object code" 
> version? *EXACTLY* those they received from the GPLv2.

Doing the e-mail equivalent of yelling about this will not change the
fact that people who think Tivo did something wrong -- legally and/or
morally -- consider DRM locks on a piece of software to be part of the
"work based on the Program" that is governed by the GPL.

The fundamental reason for this is that neither the executable code
nor the digital signature serves the desired function alone.  The user
received a copy of the executable for a particular purpose: to run the
program on a particular platform.  With DRM signatures, only the
combination of program and signature will perform that function, and
separating the two based on strictly read legal definitions is risky.

The question of whether DRM signatures are covered by the license must
be resolved before one can determine whether Tivo gave "*EXACTLY*" the
same rights to object-code recipients as Tivo received.  GPLv2 is
worded such that the answer to this does not depend on whether one is
in file A and the other in file B, or whether one is on hard drive C
and the other is in flash device D, as long as they are delivered as
part of one unit; it *might* matter if, say, one is received on
physical media and the other is downloaded on demand.

(Linus likes to say that FSF counsel thinks that Tivo did not violate
GPLv2.  I suspect the actual situation is that FSF counsel believes
that there is no case law on point, and that it could go either way,
making it improper to publicly claim that Tivo violated any copyright.
Until a court rules on a close-enough case, the question of whether
GPLv2 covers DRM signatures remains open.  In the mean time, it makes
more sense for the FSF to issue a new license that squarely addresses
this -- such as the GPLv3 -- and persuade as many developers as
possible that using it is the best way to protect free software.)

Michael Poole
