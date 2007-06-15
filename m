Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbXFOUen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbXFOUen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXFOUe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:34:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758392AbXFOUe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:34:26 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Gerdau <mgd@technosis.de>, Daniel Hazelton <dhazelton@enter.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<orabv29qtk.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706142049.41819.dhazelton@enter.net>
	<200706150825.15491.mgd@technosis.de>
	<alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 17:32:43 -0300
In-Reply-To: <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Fri\, 15 Jun 2007 10\:03\:53 -0700 \(PDT\)")
Message-ID: <or7iq5yn4k.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 15 Jun 2007, Michael Gerdau wrote:
>> 
>> I find it obvious that the GPL was meant to prevent such to be possible.
>> This is what I mean by the "the spirit of the GPL".

> Umm. It may well have been meant by *rms*. But your argument fatally falls 
> down on the fact that rms has had *nothing* to do with the Linux kernel.

You're mixing two separate issues:

1- does GPLv3 change the spirit of the GPL?

2- is GPLv3 better than GPLv2 for Linux?

The answers may be different, and the reason I got into this debate
was to set the record straight on 1.  As the discussion evolved (if
developing into a flamewar can be characterized as evolving ;-), I
realized the motivations for preferring v2 over v3 were not clear to
me (and they still appear contradictory to me), so I started
investigating that, which is indeed 2., but is not about 3:

3- is Linux going to switch to v3?

>> Living in germany I'm also used to the courts valueing the
>> intention over the exact wording of a contract (a licence after all
>> is a contract). So I _think_ in germany TiVo would have lost a
>> lawsuit if they had tried it.

> Ehh. The intent that matters is not the intent of the person who
> authored the license, but the intent of the person who *chose* the
> license.

+1

> So clearly, the whole "modify in place" argument is simply *wrong*.

When you leave an essential portion of the reasoning out, which you
repeatedly did, this conclusion is obvious.  But it's also obviously
wrong to try to apply this conclusion to the argument that I phrased.

> It cannot *possibly* be a valid reading of the GPLv2! When the GPLv2
> talks about "legal permissions to copy, distribute and/or modify"
> the software, it does *not* mean that you have to have the ability
> to modify it in place!

Isn't a restriction on in-place modification a further restriction on
the permission to modify granted by the license?  A further
restriction that is not permitted by the license?

Again, this is not about ROM, CD-ROMs and other unmodifiable media.
In this case, the distributor is not imposing this restriction, it's
not selecting the media with the strict purpose of forbidding
modification.  It doesn't retain the ability to modify without failing
to pass it on.  This is the key distiction that you repeatedly
dropped.  And then, presented it as if it were a separate argument.

> 	  rights", but it is "all rights" ONLY AS FAR AS THE GPLv2 itself 
> 	  is concerned! It's not about any _other_ additional rights you 
> 	  may have outside the GPLv2!

I agree, and I don't think I've ever claimed otherwise.  It's rights
as far as the software is concerned, and even this might be pushing it
a bit too far.  That's why the spirit gives the intuition, but the
legal terms are precise in turning that into "no further
restrictions", as I'd already explained long before you did.

But then, again, the license grants the right to modify, and prohibits
further restrictions to it, so I claim that saying "you can modify,
just not in place, because I won't let you do it" (rather than because
it's impossible), that's a further restriction of a freedom granted by
the license, which turns into a license violation.


Now we can turn into the debate on whether replacing is modifying, and
the conclusion is quite possibly that, in legal terms, it isn't.  I
don't care.  I'm not here to debate the legal terms.  I'm in this
debate to set the record straight on whether GPLv3 changes the spirit
of the GPL.

> See? Both of Alexandre's arguments about why Tivo did something "against 
> the license" were actually totally bogus.

Actually...  What you name as two separate arguments were two parts of
*one* of the 3 arguments I've raised so far.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
