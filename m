Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbXFNPuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbXFNPuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXFNPua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:50:30 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:41386
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbXFNPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:50:29 -0400
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<466BCBBC.90305@netone.net.tr>
	<Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	<f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
	<20070610160531.GA12179@kroah.com>
	<f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	<20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
	<or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070613211432.GH10008@csclub.uwaterloo.ca>
	<orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
	<or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131930120.14121@woody.linux-foundation.org>
	<ory7ingij5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4670F3C5.5090602@gmail.com> <87odji3hmv.fsf@graviton.dyn.troilus.org>
	<4671589F.60306@gmail.com>
From: Michael Poole <mdpoole@troilus.org>
Date: Thu, 14 Jun 2007 11:50:28 -0400
In-Reply-To: <4671589F.60306@gmail.com> (Matt Keenan's message of "Thu\, 14 Jun 2007 16\:02\:55 +0100")
Message-ID: <873b0u358b.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Keenan writes:

> Michael Poole wrote:
>> Matt Keenan writes:
>>
>>   
>>> Alexandre Oliva wrote:
>>>     
>>>> Err, no.  Software, per legal definitions in Brazil, US and elsewhere,
>>>> require some physical support.  That's the hard disk in the TiVO DVR,
>>>> in this case.  I don't see how this matters, though.
>>>>
>>>>   
>>>>       
>>> I'm now intrigued, where are these (Brazilian and US) definitions
>>> stipulated, and under what authority?
>>>     
>>
>> In the US, 17 USC 101 (the "Definitions" section of the title dealing
>> with Copyright) makes this definition:
>>
>>     A "computer program" is a set of statements or instructions to be
>>     used directly or indirectly in a computer in order to bring about
>>     a certain result.
>>
>> As its purpose is to outline the scope of copyright law, this
>> definition is made under the authority granted to Congress by Article
>> I, Section 8 of the United States Constitution.
>>
>>   
> But where is the part that says it "requires some physical support"? It
> says what it is; "a set of statements or instructions", how it should be
> used; "to be used directly or indirectly in a computer", and what
> purpose it serves; "in order to bring about a certain result", but it
> doesn't seem to indicate that it "requires physical support" aka needing
> some physical representation. I suspect this argument boils down to the
> philosophical debate of whether ideas (in this case software) can be
> truely devoid of the physical.

Sets of statements or instructions that cannot "be used directly or
indirectly in a computer in order to bring about a certain result"
are, for the purposes of copyright law, not software.  "A computer" is
a physical device.  It always has been a physical device, except when
"computer" referred to a person who performed computations -- and that
meaning fell out of common use 40 years ago.  Any suggestion that the
requirement to be usable on a physical device is significantly
different from "require[s] some physical support" is laughably stupid.

17 USC 102 requires that copyright protection only subsists in works
that are "fixed in any tangible medium of expression" -- which
obviously includes paper and hard drives, and has been ruled to
include volatile program memory (the 9th Circuit's holding to this
effect in MAI Systems Corp. v. Peak Computer, Inc. is what inspired
the addition of 17 USC 117(c)).  If the set of instructions exist only
in transmission or in someone's head, they are not protected by
copyright law.

Michael Poole
