Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbXFNXED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbXFNXED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXFNXDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:03:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbXFNXDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:03:53 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "Chris Friesen" <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <46718044.1040108@nortel.com>
	<orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141848.55378.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 20:03:06 -0300
In-Reply-To: <200706141848.55378.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 18\:48\:55 -0400")
Message-ID: <or8xam87h1.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Thursday 14 June 2007 15:13:31 Alexandre Oliva wrote:
>> On Jun 14, 2007, "Chris Friesen" <cfriesen@nortel.com> wrote:
>> > Alexandre Oliva wrote:
>> >> It's your position that mingles the issues and permits people to use
>> >> the hardware to deprive users of freedom over the software that
>> >> they're entitled to have.

>> > The software license controls the software.  If the hardware has
>> > restrictions on it that limit what software it will run, then that is
>> > unrelated to the software license.

>> As in, the license controls the software.  If a patent creates
>> restrictions that limit what you can do with the software, then that
>> is unrelated to the software license.

> No - because this case is covered in GPLv2. Lose the straw-men.

It's not a straw man.  See, I was just showing that there's precedent
to ensuring that other tricks can't be used to deny users the freedoms
that the GPL is meant to defend.

By pointing out this is in the GPLv2, you acknowledge the point I
wanted to make.


So what is it that makes hardware so different that it can be used as
a trick to deny users freedoms, if other tricks can't?

> But that right has never been guaranteed by the GPL. It might have been the 
> *intent* of RMS when he wrote GPLv1 and the *intent* of the FSF when they 
> wrote GPLv2, but intent is worth exactly *NOTHING* in the law *UNLESS* that 
> intent is spelled out.

That's the different between legal terms and the spirit.  And the
promise of the GPL is to retain the spirit, to defend the freedoms.

>> That would be an unfortunate machine to have, but if Linux or some
>> other GPLed software was not shipped in it, then I don't see how this
>> is relevant to this discussion.  It's not about the hardware, it's
>> about the software in it, and about passing on the freedoms related
>> with it.

> Exactly. However, you are making it about the hardware by making the claim 
> that "replacing a program, in its entirety, with another is a modification". 
> It isn't. A modification is when you replace or change a *portion* of a 
> program. By your logic I could write an operating system that is 100% binary 
> compatible with Linux and I'd be *required* to release it under the GPL, 
> because, even though it *replaces* Linux, it's still a "modification".

I'm not sure I agree with the reasoning here, but I'm already
convinced that the argument about modification by replacement won't
fly.

But then again I ask you: why do you think TiVO is making these
hardware locks?  What do they want to cause or stop?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
