Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbXFNXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbXFNXSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXFNXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:18:35 -0400
Received: from keil-draco.com ([216.193.185.50]:50497 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638AbXFNXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:18:34 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 19:18:15 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706141003550.14121@woody.linux-foundation.org> <or8xame64u.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or8xame64u.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141918.15954.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 14:35:29 Alexandre Oliva wrote:
<snip>
> > So let's look at that "section 6" that you talk about, and quote the
> > relevant parts, will  we:
> >
> > 	You may not impose any further restrictions on the recipients'
> > 	exercise of the rights granted herein.
> >
> > and then let's look at Red Hat sending me a CD-ROM or a DVD.
> >
> > Now, Red Hat clearly *did* "further restrict" my rights as it pertains TO
> > THAT COPY ON THE CD-ROM! I cannot change it! Waa waa waa! I'll sue your
> > sorry ass off!
>
> Red Hat is not stopping you from making changes.  The media is, and
> that's not something Red Hat can control.

TiVO isn't stopping you from making changes - the *media* is. (in this case 
the "Media" isn't even doing as much as a CD-ROM does. The only thing a TiVO 
box restricts is which binaries it will execute as the operating system)

>
> Compare this with the TiVO.  TiVO *designs* the thing such that it can
> still make changes, but customers can't.
>
> That's the difference.

No, it isn't. Look at any motherboard. The Bios on the last three or four 
motherboards I've purchased check for a digital signature on the Bios 
updates. The motherboard manufacturer can make changes, but the customer 
can't. Is there any difference? Nope.

> TiVO is using hardware to "impose further restrictions on the
> recipients' exercise of the rights granted herein", and this violates
> section 6 of GPLv2.

No, they don't. The GPLv2 makes no provisions for you being able to execute a 
modified copy of the code on the same media or hardware that you received it 
on. The fact is that claiming it was "the spirit" doesn't matter at all - 
this isn't philosophy you're arguing, its *LAW*, and in law, if it isn't 
clearly spelled out, it doesn't exist.

> > See the issue? You are continually making the mistake of thinking that
> > the GPLv2 talks about individual copies of software.
>
> It does.  You're making the mistake of thinking that it doens't.  And
> even in the legal terms that you claimed to have understood so
> thoroughly.
>
> > The rights granted are the rights to "distribute and modify the
> > software".
>
> More specifically, some of the rights are:
>
>   copy and distribute verbatim copies of the Program's source code as
>   you receive it
>
>   modify your copy or copies of the Program or any portion of it, thus
>   forming a work based on the Program, and copy and distribute such
>   modifications or work

And where does it say that you even have the right to run the "work based on 
the Program", or even a self-compiled copy of the "verbatim copy of the code" 
on any given piece of hardware?

> > But by "the software", the license is not talking about a particular
> > *copy* of the software, it's talking about the software IN THE ABSTRACT.
>
> Please read it again.

Done. Section 3 of GPLv2 covers the right to distribute "object code" forms of 
a licensed work. At no point does it even *mention* that, if the object code 
form comes on a device capable of executing it, you have to give the right to 
execute a modified form of the work on the same platform. If this has been 
the "intent and spirit" of the license from the beginning, it should be there 
somewhere.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
