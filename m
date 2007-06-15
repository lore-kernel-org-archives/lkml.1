Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbXFOVst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbXFOVst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbXFOVsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:48:36 -0400
Received: from keil-draco.com ([216.193.185.50]:50623 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbXFOVse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:48:34 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 17:48:18 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706150114.28068.dhazelton@enter.net> <orfy4tyog0.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orfy4tyog0.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151748.19231.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 16:04:15 Alexandre Oliva wrote:
> On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Thursday 14 June 2007 23:39:50 Alexandre Oliva wrote:
> >> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> >> > You're making an artificial distinction based on whether the
> >> > *SOFTWARE* has a certain license or not.
> >>
> >> What matters to me is that, when the GPL says you can't impose further
> >> restrictions, then you can't, no matter how convoluted your argument
> >> is
> >
> > Convoluted? Not in the least.
>
> I didn't say your arguments were convoluted, and I know I didn't mean
> to say that.  But I've heard enough arguments about excuses to escape
> the obligations of the GPL (and other licenses and obligations, FWIW)
> to know that such arguments can get very convoluted.
>
> That said, I was actually trying to quote Eben Moglen, who once spoke
> about this, but the word he used was "elaborate", not "convoluted".
> Unfortunately, the right word escaped me ATM.

Thanks for the clarification.

> >> > If the intent of a law (or license) is to do A but it doesn't say
> >> > that, then how is the intent to be known?  Your answer: Ask the
> >> > author.
> >>
> >> No, you interpret based on what the author wrote then.
> >
> > Really? Well I must say I'm surprised at the sudden change of heart. I
> > have several mails here in which you have either said "You ask the
> > author" or that line has been quoted.
>
> It's no change.  You interpret what's there.  If it's clear, good.  If
> there's a dispute, you have to ask the author, only s/he knows what
> s/he meant.  It's really that simple.

And as I have hopefully given good proof for, asking the author is not a good 
solution. The author can change their mind about their intent at any point in 
time - even during the process of writing the license.

> > Show me where in the preamble that this issue of "it must run on any
> > given piece of hardware"
>
> Why is the burden of the proof on me?
>
> You show me where it says "one may impose restrictions on what
> particupar pieces of hardware the program can run", to override the
> general spirit of "passing on all the rights one has".

It's "pass on all rights granted under this license". If I had to pass on "all 
rights I have" I'd have to pass on my right to change the license on my code. 
Since that isn't a right I'm obligated to pass on - and you could never 
convice me it is - I'm not "passing on all the rights I have" at *all*.

> > (And, by the way, if the FSF decided to release a GPLv4 that had an
> > active section that said "You must turn over all copyright rights to a
> > work released under this license to the FSF" it wouldn't "break spirit"
> > with the GPL (v2 or v3).
>
> Can't.  These terms wouldn't apply to the copyright holder (the only
> person who could make the transfer), only to licensees.

It's part of the preamble, in which the "We" refers to the FSF. If the 
preamble determines the "intent" and "spirit" of the license, then part of 
the "intent" and "spirit" of the license is collective aggregation of all 
copyright rights to all software released under the GPL by the FSF.

> > If "tivoization" was against the spirit, then all that would have been
> > needed was one extra clause clearly explaining that. Instead there are
> > more than 6 extra sections in the GPLv3.
>
> Erhm...  How did you get the (completely flawed, BTW) impression that
> tivoization was all GPLv3 was about?

I've looked through the GPLv3 and "tivoization" and DRM are the only things 
that are functionally different. In reading the GPLv3 *again* today I got the 
impression that there are more restrictions than grants of rights.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
