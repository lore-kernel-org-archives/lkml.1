Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbXFOBog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbXFOBog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXFOBo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:44:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbXFOBo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:44:28 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706141003550.14121@woody.linux-foundation.org>
	<or8xame64u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141918.15954.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 22:43:07 -0300
In-Reply-To: <200706141918.15954.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 19\:18\:15 -0400")
Message-ID: <ormyz26lhw.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Thursday 14 June 2007 14:35:29 Alexandre Oliva wrote:
> <snip>
>> > So let's look at that "section 6" that you talk about, and quote the
>> > relevant parts, will  we:
>> >
>> > 	You may not impose any further restrictions on the recipients'
>> > 	exercise of the rights granted herein.
>> >
>> > and then let's look at Red Hat sending me a CD-ROM or a DVD.
>> >
>> > Now, Red Hat clearly *did* "further restrict" my rights as it pertains TO
>> > THAT COPY ON THE CD-ROM! I cannot change it! Waa waa waa! I'll sue your
>> > sorry ass off!
>> 
>> Red Hat is not stopping you from making changes.  The media is, and
>> that's not something Red Hat can control.

> TiVO isn't stopping you from making changes - the *media* is.

TiVO made it so, that's the difference.

I'll give you that it's not so much about making changes per se, or
even installing them, as it is about running the modified versions for
any purpose.

>> Compare this with the TiVO.  TiVO *designs* the thing such that it can
>> still make changes, but customers can't.

>> That's the difference.

> No, it isn't. Look at any motherboard. The Bios on the last three or four 
> motherboards I've purchased check for a digital signature on the Bios 
> updates. The motherboard manufacturer can make changes, but the customer 
> can't. Is there any difference? Nope.

Is the BIOS code under the GPL?

> The fact is that claiming it was "the spirit" doesn't matter at all
> - this isn't philosophy you're arguing, its *LAW*, and in law, if it
> isn't clearly spelled out, it doesn't exist.

That's exactly what makes for the difference between the spirit and
the precise legal terms, and why GPLv3 is fixing these divergences.

> And where does it say that you even have the right to run the "work based on 
> the Program", or even a self-compiled copy of the "verbatim copy of the code" 
> on any given piece of hardware?

It doesn't.  The license can't demand the software, or modified
versions thereof, to run.  The only thing it can demand is that
licensees don't impose restrictions on others' abilities to do so.

>> > But by "the software", the license is not talking about a particular
>> > *copy* of the software, it's talking about the software IN THE ABSTRACT.
>> 
>> Please read it again.

> Done.

  2. You may modify your copy or copies of the Program or any portion
  of it                  ^^^^

> If this has been the "intent and spirit" of the license from the
> beginning, it should be there somewhere.

I think you're missing what 'spirit' means.  It's guidance, it's not
the legal terms.  And it's precisely because the implementation (the
legal terms) failed to meet that design (the spirit, encoded in the
preamble) that the license needs patching.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
