Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbXFOVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbXFOVQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXFOVQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:16:12 -0400
Received: from keil-draco.com ([216.193.185.50]:50466 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbXFOVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:16:11 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 17:15:54 -0400
User-Agent: KMail/1.9.6
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Friesen" <cfriesen@nortel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706150308.20148.dhazelton@enter.net> <or1wgd102n.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wgd102n.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151715.55218.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 15:37:04 Alexandre Oliva wrote:
> On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Friday 15 June 2007 02:59:31 Jesper Juhl wrote:
> >> it doesn't say anything about being able to run a compiled version
> >> of that source on any specific hardware.
> >
> > And you are correct. It is also clear, thanks to language directly
> > in the GPLv2 itself, that there is no "intent" of the license to
> > cover that situation.
>
> You're again confusing legal terms with the intent.  The legal terms
> provide an indication of the intent, but the preamble, along with the
> free software definition it alludes to, do an even better job at that.

And the preamble, not being part of the active portion of the license, has 
absolutely *ZERO* bearing. Just as it is not the *intent* of RMS, the FSF or 
*ANY* person (or legal entity) that had a hand in crafting the GPLv2 or GPLv3 
which is looked at when determining the "intent" of the license. It is the 
intent of the person and/or "legal entity" that has placed their work under 
said license.

What is so hard to understand about that ?

> That said, the letter of the GPL explicitly says that the act of
> running the program is not restricted, and that this is outside the
> scope of the license.  It's a copyright license, and per US law,
> running software is not regulated by copyright; this is not so
> elsewhere, and local interpretation indicates that the intent of the
> license is indeed to grant unlimited permission to run the program and
> modified versions thereof, based on the free software definition.

And that may be what courts in Brazil believe, independent of the fact that 
the license itself *intentionally* limits itself to "copying, distribution 
and modification". That legal decision, in fact, may not have been motivated 
by the actual belief that that was the intent of the license - it could (and, 
from looking at the situation and available facts, might actually have been) 
motivated by political reasons.

>
> But then, when someone says "I won't let you run modified versions of
> this software on this hardware I'm selling you", is this not a further
> restriction on the exercise of the rights granted in the license?

In Brazil, because the courts there have rendered a judgment that the license 
requires the unlimited running of the covered work. But that is *unfairly* 
applying a license on a piece of software to the hardware on which it runs. 
Based on your logic the hardware manufacturer would have to enable people to 
run code compiled for an entirely different processor. Not that it matters in 
the least.

> And, per the spirit, if the manufacturer can still install and run
> modified versions of the software on that hardware, is it not failing
> to comply with the spirit of passing on all the rights that you have?

Not in the least. They have the rights to "copy, modify and distribute" 
the "source code for a work". That is *EXACTLY* the set of rights they have 
to the code, and it is *EXACTLY* the set of rights they pass on. The GPL does 
not apply to any *BINARY* form of the work, except for the fact that you are 
required to provide the source code that was used to generate the binary.

The GPL *clearly* defines "source code" as:
"the preferred form of the work for making modifications to it"
It goes on to state:
"For an executable work, complete source code means all the source code for 
all modules it contains, plus any associated interface definition files, plus 
the scripts used to control compilation and installation of the executable."

(Note that, since the "signing" of the TiVO kernel is part of the installation 
they *should* be including the script that does the signing. However, since 
the SHA1 key that is part of the signing process is *not* a "script" (even in 
the loosest possible definition of the term) they do not have to provide it.)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
