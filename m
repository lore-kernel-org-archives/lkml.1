Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbXFOF5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbXFOF5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXFOF52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:57:28 -0400
Received: from keil-draco.com ([216.193.185.50]:50356 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbXFOF51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:57:27 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 01:57:13 -0400
User-Agent: KMail/1.9.6
Cc: Florin Malita <fmalita@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <4671F127.40000@gmail.com> <or8xal6h1f.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or8xal6h1f.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150157.13631.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 23:19:24 Alexandre Oliva wrote:
> On Jun 14, 2007, Florin Malita <fmalita@gmail.com> wrote:
> > On 06/14/2007 05:39 PM, Alexandre Oliva wrote:
> >> Back when GPLv2 was written, the right to run was never considered an
> >> issue.  It was taken for granted, because copyright didn't control
> >> that in the US (it does in Brazil), and nobody had thought of
> >> technical measures to stop people from running modified copies of
> >> software.  At least nobody involved in GPLv2, AFAIK.
> >>
> >> The landscape has changed, and GPLv3 is meant to defend this
> >> freedom that was taken for granted.
> >
> > Then you agree that GPLv2 does not protect your freedom (taken for
> > granted) to run a modified copy on any particular device, or am I
> > misreading?
>
> IANAL, but AFAICT it doesn't.  Still, encoded in the spirit (that
> refers to free software, bringing in the free software definition), is
> the notion of protecting users' freedoms, among them the freeom #0, to
> run the software for any purpose.

And where in GPLv2 is "Freedom #0"?

As a simple matter of fact, the *only* activities covered by the GPLv2 
are "copying, distributing and modifying". It says so in the license itself.

> That's why I believe it's in the spirit of the license to defend this
> freedom.
>
> And that's why lawyers in Brazil believe that, even though the GPL
> does not affirm the right to run the software, it fits the bill,
> because, under the light of the preamble, the free software
> definition, and the US copyright law, it should be interpreted as an
> intent to grant permission to run the software.

Then they have made a bad decision. While it can be argued that "the right to 
run the software" is guaranteed, the truth is that the license is very clear 
about what it covers. That's *DIRECTLY* in section 0 of the license. If 
someone has interpreted it to cover something besides what it explicitly 
states then it has been badly interpreted.

In case you don't remember, GPLv2, section 2, paragraph 2:

"Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does."

In other words, the license cannot be sanely interpreted to cover *execution* 
of the program. Yes, it says that the *license* doesn't restrict you from 
running the program, but that *DOESN'T* matter, because the opening sentence 
says: "Activities other than copying, distribution and modification are not 
covered by this License; they are outside its scope." QED: The intent of the 
license is clear and it is to guarantee those three stated rights.

DRH

> > Hence, Tivo is not really *modifying* the copies it distributes with
> > the device - they're *installing* brand new copies instead. They
> > also choose not to offer everybody the same privilege :-|
>
> Got it.  That's bad.  :-(



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
