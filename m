Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXFNWtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXFNWtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXFNWtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:49:12 -0400
Received: from keil-draco.com ([216.193.185.50]:50315 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbXFNWtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:49:10 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 18:48:55 -0400
User-Agent: KMail/1.9.6
Cc: "Chris Friesen" <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <46718044.1040108@nortel.com> <orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141848.55378.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 15:13:31 Alexandre Oliva wrote:
> On Jun 14, 2007, "Chris Friesen" <cfriesen@nortel.com> wrote:
> > Alexandre Oliva wrote:
> >> But see, I'm not talking about getting permission to hack the
> >> hardware.  I'm only talking about getting permission to hack the Free
> >> Software in it.
> >
> > No you're not...you're talking about being able to hack the software
> > *and load it back onto the original hardware*.
>
> Yes.  You wouldn't impose restrictions on modifying the software like
> that, now would you?  Even though the GPL says you can't impose
> further restrictions on modification and distribution.

replace != modify

>
> >> It's your position that mingles the issues and permits people to use
> >> the hardware to deprive users of freedom over the software that
> >> they're entitled to have.
> >
> > The software license controls the software.  If the hardware has
> > restrictions on it that limit what software it will run, then that is
> > unrelated to the software license.
>
> As in, the license controls the software.  If a patent creates
> restrictions that limit what you can do with the software, then that
> is unrelated to the software license.

No - because this case is covered in GPLv2. Lose the straw-men.

> As in, the license controls the software.  If a discriminatory
> contract limits what you can do with the software, then that is
> unrelated to the software license.

Incorrect. This is, again, covered by the GPLv2. Straw-man argument.

> As in, the license controls the software.  If I send you the source
> code, but it happens to be protected by a key that only the hardware
> can decode, and it won't decode for you, then that is unrelated to the
> software license.

Straw-man. Situation covered by the GPLv2.

> Is that so, really?
>
> > There is nothing stopping you from taking the code for the tivo,
> > modifying it, distributing it, or even running it on other hardware.
>
> True.  But TiVO is still imposing further restrictions on how I can
> modify the software stored in their device, while reserving that
> ability to itself.  This is wrong.  This is not "in kind".  This is
> not "tit-for-tat".  Tit-for-tat is: if they can, then I can too, and
> if I can't, then they can't either.

But that right has never been guaranteed by the GPL. It might have been the 
*intent* of RMS when he wrote GPLv1 and the *intent* of the FSF when they 
wrote GPLv2, but intent is worth exactly *NOTHING* in the law *UNLESS* that 
intent is spelled out.

Anyway, as I've pointed out before: replace != modify

You can *replace* parts of a program and it will be a modification, you can 
*replace* components of a piece of Hardware and it will be a modification but 
replacing one software component of a device with another is *NOT* a 
modification. Why? Because the hardware hasn't changed at all - the hardware 
is merely there so the software can perform its job. And since you are 
*replacing* the *ENTIRE* piece of software, it isn't a modification of the 
software.

> > Suppose I had some machine that will only run microsoft-signed
> > binaries. Would it be at all related to any software license that this
> > machine won't let me run linux?
>
> That would be an unfortunate machine to have, but if Linux or some
> other GPLed software was not shipped in it, then I don't see how this
> is relevant to this discussion.  It's not about the hardware, it's
> about the software in it, and about passing on the freedoms related
> with it.

Exactly. However, you are making it about the hardware by making the claim 
that "replacing a program, in its entirety, with another is a modification". 
It isn't. A modification is when you replace or change a *portion* of a 
program. By your logic I could write an operating system that is 100% binary 
compatible with Linux and I'd be *required* to release it under the GPL, 
because, even though it *replaces* Linux, it's still a "modification".

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
