Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbXFNBJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbXFNBJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbXFNBI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:08:56 -0400
Received: from keil-draco.com ([216.193.185.50]:50914 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbXFNBI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:08:56 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 21:08:49 -0400
User-Agent: KMail/1.9.6
Cc: Bongani Hlope <bhlope@mweb.co.za>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706140215.54179.bhlope@mweb.co.za> <or4plbl5gn.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or4plbl5gn.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132108.50030.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 20:55:52 Alexandre Oliva wrote:
> On Jun 13, 2007, Bongani Hlope <bhlope@mweb.co.za> wrote:
> > On Thursday 14 June 2007 01:49:23 Alexandre Oliva wrote:
> >> if you distribute copies of such a program, [...]
> >> you must give the recipients all the rights that you have
> >>
> >> So, TiVo includes a copy of Linux in its DVR.
> >
> > And they give you the same right that they had, which is obtain free
> > software that you can modify and redistribute. There's nothing in there
> > that says they should give you the tools they used after they received
> > the software, which is what you seem to be looking for.
>
> Can they modify the software in their device?
>
> Do they pass this right on?

But this *ISN'T* a right that the GPLv2 *REQUIRES* be passed on. 

> >> TiVo retains the right to modify that copy of Linux as it sees fit.
> >>
> >> It doesn't give the recipients the same right.
> >
> > It does, can't you modify their kernel source?
>
> It's not the kernel source.  That's not where the TiVo anti-tampering
> machinery blocks modifications.
>
> It's about that copy of the kernel that ships in the device in object
> code.  That's the one that TiVo customers ought to be entitled to
> modify, if TiVo can modify it itself.

The GPLv2 makes no real provision for *DIRECTLY* modifying object code. What 
provisions the GPLv2 has apply to the source code.

And no, the end user *SHOULD* *NOT* be entitled to run whatever kernel they 
like on a TiVO. It was designed with the "install new kernel" functionality 
so that the TiVO corporation could update the kernel running on the hardware 
when security problems came up, when bugs were fixed or even when the new 
version gives better performance.

> > Where does it say you should be able to run you modifications on the
> > same hardware?
>
> Where it says that you should pass on all the rights that you have.
>
> While TiVo retains the ability to replace, upgrade, fix, break or make
> any other change in the GPLed software in the device, it ought to pass
> it on to its customers.

It *DOES* *NOT* say "All rights that you have". It says "All rights that are 
granted you by this license". If every piece of software released under the 
GPL had *ALL* rights passed on, then *ANYONE* could do the "I'm granting 
company X the right to use this software outside the GPL for $50,000USD." 
instead of just the *creator* of the software.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
