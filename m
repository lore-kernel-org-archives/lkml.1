Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXKLRQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXKLRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbXKLRQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:16:46 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:48352 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759259AbXKLRQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:16:45 -0500
Date: Mon, 12 Nov 2007 19:16:26 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112171626.GA8838@jolt.modeemi.cs.tut.fi>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <20071112160254.GA31972@jolt.modeemi.cs.tut.fi> <20071112165616.GM9771@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071112165616.GM9771@stusta.de>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-11-12 17:56 +0100, Adrian Bunk wrote:
> Yes, by asking immediately
>   Is this issue still present with $latest_upstream_version?

That's still a user complaining about problems fixed ages ago,
and a couple more who never even bothered complaining, just
decided that the software is crap because it doesn't work.

> Let's check your statement against reality:
> 
> They are called linux-*

I have various kernel-image packages.

> Open source development does not work by whining and trying to spread 
> your opinion through fake "polls" - either you implement what you want
> yourself or it won't happen.

I did not post this "poll".

I'll just complain how shoddy FOSS has become, and fix to Windows. 
There's little point in using FOSS these days, when nothing is done
better, and many things worse, than in closed source. I simply don't
have the time to fix all the woeful FOSS crap by myself.

> But an important observation is that when you start something other 
> people consider worthwhile there will be other people who participate in 
> what you do, or who even continue it when you decide to switch to other 
> projects instead.

Typically they write a clone from scratch, because the right
herd-approved language or the right license wasn't originally used,
or so. They expect the author to maintain their shoddy patches that 
would be better implemented as separate modules -- taking example
from the monolithic unbuildable kernel [1] -- and when you ask for 
quality, they disappear or threaten with a fork. It's very difficult
to get quality contributions. And then there are projects that would
really demand a lot of input before even starting the actual coding
work, but the FOSS herd works on the worse-is-better fallacy that 
results in crappy software that it has become too late to fix the
fundamental flaws in, when you notice the it. Essential core software
needs a lot of input before starting the work, instead of a small
(one-man) elite creating it and then the herd uncritically adopting
it based on the "oooh! shiny!" factor, after which it will be very
difficult to fix.

  [1]: http://iki.fi/tuomov/b/archives/2007/04/01/T19_09_22/

-- 
Tuomo
