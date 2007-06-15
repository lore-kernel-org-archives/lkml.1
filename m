Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbXFOMlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbXFOMlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXFOMk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:40:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbXFOMky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:40:54 -0400
Date: Fri, 15 Jun 2007 14:40:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Poole <mdpoole@troilus.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615124039.GB21120@elte.hu>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org> <200706150127.18069.dhazelton@enter.net> <87sl8tzaj1.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sl8tzaj1.fsf@graviton.dyn.troilus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Poole <mdpoole@troilus.org> wrote:

> > However, since the signing is an automated process it cannot 
> > generate a "new" work - at least, not under the laws of the US - so 
> > the signature itself cannot have a copyright at all.
[...]
> 
> I do not suggest that copyright subsists in the signature or in the 
> signing key.  Whether it does is irrelevant to the signing key being 
> part of the source code (when the signature is needed for the binary 
> to work properly).

it is very much relevant. By admitting that the key is not part of the 
"work", you have lost all moral basis to claim control over it. Cutely 
"defining it" into the source code just hides what this really is: the 
key is a "payment" in exchange for the license, which payment goes 
outside the scope of the software itself. It has no relevance to the 
software work being "free", it reaches for paymeant beyond the work to 
advance the FSF's agenda.

yes, a copyright license can be used to control other works, it can be 
used to control the movement of non-copyrightable items as well (such as 
money), but the GPL always tried to stay out of that kind of business.

Where does this "reach out for more resources in exchange for the 
license" process stop? As the value of free software increases, will the 
FSF iterate the GPL to ask for more and more consideration for the 
privilege to license that software? (All in the name of achieving more 
freedom of course.)

> Similarly, copyright might not subsist in a simple linker script -- 
> its content being determined by the operating system and perhaps the 
> rest of the program's source code -- but under the GPL, the linker 
> script would be part of the source code for a compiled version.

the linker script is still part of the whole work though - even if that 
particular element might not be copyrightable in isolation. Likewise, 
the kernel contains code that is in the public domain - to which 
copyright protection does not extend either. But you cannot argue that 
the Tivo 'key' is part of the whole work. It is part of the _hardware_. 
The Tivo box is a compilation (at most a collection) of multiple works, 
and allowing the GPL to jump over derivation/modification lines is 
wrong. The GPLv2 certain doesnt do that land-grab.

	Ingo
