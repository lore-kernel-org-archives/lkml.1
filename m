Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbXFNGhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbXFNGhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXFNGhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:37:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXFNGhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:37:40 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org>
	<orejkfla3l.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706131946.15714.dhazelton@enter.net>
	<20070614004419.GL3588@stusta.de>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 03:36:12 -0300
In-Reply-To: <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 13 Jun 2007 20\:09\:26 -0700 \(PDT\)")
Message-ID: <ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Adrian Bunk wrote:
>> 
>> "For an executable work, complete source code means all the source code 
>> for all modules it contains, plus any associated interface definition 
>> files, plus the scripts used to control compilation and installation of 
>> the executable."
>> 
>> The question is whether this includes private keys.

> No. That's the question as the FSF would like to frame it.

No.  The FSF actually does *not* want to take this position.  That's
why it chose the formulation of Installation Instructions.  It doesn't
share my view that the keys needed to sign a binary in order for it to
work are part of the source code.

> And you could actually replace their copy of Linux with another one. It 
> would have to have the same SHA1 to actually start _running_, but that's 
> the hardware's choice. 

That's the hardware imposing a restriction on modification of the
software.  It doesn't matter how elaborate the excuse is to justify
denying users' freedoms: it's against the spirit of the GPL, and the
GPL will be amended as needed to plug such holes.

> So take another example: I obviously distribute code that is copyrighted 
> by others under the GPLv2. Do I follow the GPLv2? I sure as hell do! But 
> do I give you the same rights as I have to modify the copy on 
> master.kernel.org as I have? I sure as hell DO NOT!

That's an interesting argument.

People don't get your copy, so they're not entitled to anything about
it.

When they download the software, they get another copy, and they have
a right to modify that copy.

> And here's a big clue for people: anybody who thinks that I'm violating 
> the GPLv2 by not giving out my private SSH key to master.kernel.org is a 
> f*cking moron!

Agreed, except I'd probably use a lighter term.

> See any parallels here? Any parallel to a CD-ROM distribution, or a Tivo 
> distribution?

Yes.  You see how TiVO is different?  It is modifyable, and I actually
receive the copy that TiVO can still modify, but I can't.

> The rights that the GPLv2 gives to "the software", is to something
> much bigger than "the particular copy of the software".

Indeed, it's something bigger.  But this doesn't exclude the smaller
things, does it?

> Can people really not see the difference between "the software" and "a 
> particular encoded copy of the software"? 

There is a difference.  But the GPL doesn't limit itself to the
former.  It explicitly talks about "copies".

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
