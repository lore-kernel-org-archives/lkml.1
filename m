Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbXFOWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbXFOWK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbXFOWKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:10:15 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50724 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbXFOWKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:10:13 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 18:09:58 -0400
User-Agent: KMail/1.9.6
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Friesen" <cfriesen@nortel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706151715.55218.dhazelton@enter.net> <orfy4sx577.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orfy4sx577.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151809.58404.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 17:45:16 Alexandre Oliva wrote:
> On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Friday 15 June 2007 15:37:04 Alexandre Oliva wrote:
> >> On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> >> > On Friday 15 June 2007 02:59:31 Jesper Juhl wrote:
> >> >> it doesn't say anything about being able to run a compiled version
> >> >> of that source on any specific hardware.
> >> >
> >> > And you are correct. It is also clear, thanks to language directly
> >> > in the GPLv2 itself, that there is no "intent" of the license to
> >> > cover that situation.
> >>
> >> You're again confusing legal terms with the intent.  The legal terms
> >> provide an indication of the intent, but the preamble, along with the
> >> free software definition it alludes to, do an even better job at that.
> >
> > And the preamble, not being part of the active portion of the license,
> > has absolutely *ZERO* bearing. Just as it is not the *intent* of RMS, the
> > FSF or *ANY* person (or legal entity) that had a hand in crafting the
> > GPLv2 or GPLv3 which is looked at when determining the "intent" of the
> > license. It is the intent of the person and/or "legal entity" that has
> > placed their work under said license.
>
> No disagreement.  You keep forgetting that I'm not here to say what
> Linux licensing means or doesn't mean.
>
> I'm here to point out that GPLv3 does not break the spirit of the GPL.

And you have been given evidence that it does. It may not break the spirit as 
you, or anyone else that believes that the FSF is the singular fountain of 
truth, see it. But it does break the spirit as a large fraction of the 
populace see it. Why do they like GPL3? Because they don't like what TiVO 
did - they see it and say "but that's not fair", so when they see that GPL3 
makes it a license violation they accept GPL3 without understanding the 
bigger picture.

To *anyone* who is considered an "Adult" in *ANY* nation and still wants to 
scream "its not fair" when something doesn't go their way or somebody does 
something they don't like I have this to say: Grow up! Life *ISN'T* fair - at 
all.

> > What is so hard to understand about that ?
>
> /echo
>
> > (Note that, since the "signing" of the TiVO kernel is part of the
> > installation they *should* be including the script that does the
> > signing. However, since the SHA1 key that is part of the signing
> > process is *not* a "script" (even in the loosest possible definition
> > of the term) they do not have to provide it.)
>
> It's not build script, it's just regular source code, indeed.

Not even. If it's anything it's "input to a program". QED: It isn't covered by 
the license. Hell, give me a week and access to a signed TiVO kernel and I'll 
produce a signed kernel that is functionally equivalent - it won't run on a 
TiVO, but I'll have replicated the "signing script" and process that TiVO 
uses. It isn't until you start extending the definition of source code in 
strange ways that the key becomes "source code". Hell, for all *anyone* knows 
(that isn't employed by TiVO) they could enter the key *manually* - ie: 
interactive input.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
