Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFOCxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFOCxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXFOCxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:53:16 -0400
Received: from keil-draco.com ([216.193.185.50]:50712 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbXFOCxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:53:16 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 22:52:38 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <20070614235004.GA14952@elte.hu> <or645q6jp4.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or645q6jp4.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142252.39315.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 22:21:59 Alexandre Oliva wrote:
> On Jun 14, 2007, Ingo Molnar <mingo@elte.hu> wrote:
> > the GPLv2 license says no such thing, and you seem to be mighty confused
> > about how software licenses work.
> >
> > the GPL applies to software. It is a software license.
> >
> > the Tivo box is a piece of hardware.
> >
> > a disk is put into it with software copied to it already: a bootloader,
> > a Linux kernel plus a handful of applications. The free software bits
> > are available for download.
> >
> > the Tivo box is another (copyrighted) work, a piece of hardware.
> >
> > so how can, in your opinion, the hardware that Tivo produces, "take
> > away" some right that the user has to the GPL-ed software?
>
> Consider egg yolk and egg shells.
>
> I produce egg yolk.  I give it to you under terms that say "if you
> pass this on, you must do so in such a way that doesn't stop anyone
> from eating it"
>
>
> You produce egg shells.  You carefully construct your shell around the
> egg yolk and some white you got from a liberal third party.
>
>
> Then you sell the egg shells, with white and yolk inside, under
> contracts that specify "the shell must be kept intact, it can't be
> broken or otherwise perforated".
>
>
> Are you or are you not disrespecting the terms that apply to the yolk?

Bad analogy. I've already provided all the proof needed to prove that, 
while "tivoization" may be against the "intent" or "spirit" of the GPLv2 it 
is not in violation of it.

> > by your argument, the user has some "right to modify the software", on
> > that piece of hardware it bought which had free software on it, correct?
>
> Yes.  This means the hardware distributor who put the software in
> there must not place roadblocks that impede the user to get where she
> wants with the software, not that the vendor must offer the user a
> sport car to take her there.

Okay. That means that if I ship Linux on a ROM chip I have to somehow make it 
so that the person purchasing the chip can modify the copy of Linux installed 
on the chip *if* I want to follow both the spirit and the letter of the 
GPLv2. And no claiming that I'm missing the point - I'm drawing a logical 
conclusion from your statement above.

> The goal is not to burden the vendor.  The goal is to stop the vendor
> from artificially burdening the user.

I have no objection to this. What I object to is the manner in which it is 
being done. However, I must admit that, at this point, I do not know of a 
better method to achieve this goal.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
