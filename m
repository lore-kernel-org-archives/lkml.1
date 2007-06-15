Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXFOByE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXFOByE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXFOBxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:53:55 -0400
Received: from keil-draco.com ([216.193.185.50]:50361 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXFOBxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:53:54 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 21:53:40 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706141424160.14121@woody.linux-foundation.org> <orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142153.40879.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 18:35:01 Alexandre Oliva wrote:
> On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > I want to be able to use other peoples improvements. If they release
> > improved versions of the software I started, I want to be able to merge
> > those improvements if I want to.
>
> Hmm...  So, if someone takes one of the many GPLv2+ contributions and
> makes improvements under GPLv3+, you're going to make an effort to
> accept them, rather than rejecting them because they're under the
> GPLv3?

Doesn't matter at all. GPLv3 requires that any project incorporating GPLv3 
code be licensed under the GPLv3. Linus is, as he has shown, intelligent 
enough to know this. The *second* he actually accepted GPLv3 code into the 
kernel it would either be "change the license or start getting lawsuits for 
breach of the terms of the GPLv3".

> > Your *IDIOTIC* suggestion is explicitly against the whole POINT! By
> > saying that I shouldn't accept contributions like that, you just
> > INVALIDATED the whole point of the license in the first place!
>
> I understand.  I assumed you had some trust that people would abide by
> your wish to permit TiVOization, and that authors of modifications
> were entitled to make "whatever restrictions they wanted" on their
> code.
>
> Pardon me if I think your position is at least somewhat incoherent.
> Can you help me make sense of it?

You are making a distinction between "part" and "whole". When separate from 
the kernel the code can have whatever restrictions the creator pleases. If he 
has said "I want this in the "official" Linux Kernel" (ie: I want this in 
Linus' Linux Kernel source tree) then the creator of the code has stated a 
willingness to abide by Linus' decision about the whole work.

It's a moot point, though. The Linux Kernel is licensed under GPLv2, which 
means that *all* code in it has to be under the same license *and* that no 
code in it can have any restrictions *NOT* in the GPLv2.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
