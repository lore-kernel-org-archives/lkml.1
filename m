Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXFSIGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXFSIGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXFSIGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:06:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbXFSIGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:06:07 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706190221.09067.dhazelton@enter.net>
	<ork5u04f5b.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706190258.56955.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 05:04:52 -0300
In-Reply-To: <200706190258.56955.dhazelton@enter.net> (Daniel Hazelton's message of "Tue\, 19 Jun 2007 02\:58\:56 -0400")
Message-ID: <or7iq04bff.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Tuesday 19 June 2007 02:44:32 Alexandre Oliva wrote:
>> GPLv3 forbids tivoization, therefore developer has requirement for
>> tivoization in the license, therefore GPLv3 forbidding tivoization
>> is bad.

> However, my argument is straight logic, nothing "circular" about it.  :)
> Replacing "X" in my logic path above with "tivoization" and "license" 
> with "GPLv3", as you've done, does produce a valid chain of logic.  

Yes.  Isn't it funny though that tivoization became necessary as a
consequence of GPLv3 forbidding it?

> FWIW the Linux Kernel shouldn't be as homogeneous a population as it
> is.

Nah.  Communities tend to form around similar values.  Linus started
the community.

>> Wait a minute, these figures you made up are for the tivoized hardware
>> (no changes allowed to the GPLed software in it), or for the
>> non-tivoized hardware (changes allowed to the GPLed software in it)?

> Actually, any generic "TiVO"-like hardware - whether it is tivoized or not. 

So your claim is that a user's possibility to scratch her own itches
makes no difference whatsoever as to their amount of contributions she
is likely to make?

Am I the only one who thinks this is utter nonsense?

>> > those who will contribute them back: 38 (25%)

>> Regardless of what you meant, this is 38 developers *on top* of
>> however many the company pays to work on that, unless you're jumping
>> the gun and spoiling the multi-part argument.

> 38ppm is a fairly small amount, regardless.

Yes.  And your estimates are way too low too, FWIW.  Any reason why
you changed your mind as to the 10% before?

>> > What you are arguing is that people should abandon

>> I'm not arguing any such thing.  Where's any such argument above?

>> At this point, I'm only comparing a tivoized device with a
>> non-tivoized device.  Nothing but it.

> You've been making the argument the entire time you've been arguing that 
> the "anti-tivoization" language in the GPLv3 is necessary.

And then I decided that, since the argument wasn't getting through, I
had to break it into pieces.

The piece I've presented so far has no abandonment whatsoever.  It's a
comparison between two different situations, to evaluate which of them
brings more contributions from users, regardless of the contributions
from the vendor, that are assumed to be the same, since there's no
material difference as far as the vendor is concerned (as in, vendor
has no reason to tivoize)

So your arguments bear zero relationship with the piece I've
proposed.  Can you see that?



> I think I'd rather see a guaranteed increase of developers - even if
> it is only 10 - rather than hoping that the potential pool of 38
> actually follows through. Wouldn't you?

Yes.  How does this relate with the piece of the argument I've
proposed so far, or the whole argument I've posted before?

Answer: It doesn't.  At all.  You're just showing you didn't
understand the argument.  Which shows why I have to explain it piece
by piece.  Which suggests you shouldn't try to jump to conclusions.



Once again, now with clearer starting conditions (not intended to
match TiVo in any way, BTW; don't get into that distraction)


Vendor doesn't care about tivoizing, their business works the same
either way.

Vendor's employees will contribute the same, one way or another, so
their contributions are out of the equation.

Users get source code in either case, and they can modify it and share
it.  They're in no way stopped from becoming part of the community.


Given these conditions:

In a tivoized device, users will be unable to scratch their itches.
This doesn't stop them from contributing to the project, but they may
lack self-interest motivation to contribute, because they won't be
able to use their modifications in the device they own.

In a non-tivoized device, users can scratch their itches.  They can
contribute just as much as they would in a tivoized device, but since
they can use the changes they make to make their own devices work
better for them, this works as a motivator for them to make changes,
and perhaps to contribute them.  Therefore, they will tend to
contribute more.


Can you point out any flaw in this reasoning, or can we admit it as
true?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
