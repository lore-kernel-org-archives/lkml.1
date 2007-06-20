Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbXFTDe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbXFTDe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbXFTDeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:34:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:36020 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759717AbXFTDeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LQYFdBZD0m1Zg0cYoBqMl8DvkNieu1zJaBsqHoIuyA9Y8wPvjCtPcqQUHdxe8HaVAfrsNxOYUziqm61+Gdt4NbkzAZ+WYY8uAjmtBxqvpVgfjatKr4OGMwGxj/Vrlw6We+sgTaBerIM3QXoIcYKMzyUX7BAmyekKYmWZg/x518A=
Message-ID: <161717d50706192034l65287cfct58410f6887ec33a3@mail.gmail.com>
Date: Tue, 19 Jun 2007 23:34:03 -0400
From: "Dave Neuer" <mr.fred.smoothie@pobox.com>
To: "Alexandre Oliva" <aoliva@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070620020246.GO14788@delft.aura.cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	 <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070619012517.GL14788@delft.aura.cs.cmu.edu>
	 <orbqfc5wno.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070619200156.GA8812@delft.aura.cs.cmu.edu>
	 <orwsxzzlnr.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070620020246.GO14788@delft.aura.cs.cmu.edu>
X-Google-Sender-Auth: ccfdcd520f743f39
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/07, Jan Harkes <jaharkes@cs.cmu.edu> wrote:
>
> You keep referring to the four freedoms so I googled for them and found
>
>     http://www.gnu.org/philosophy/free-sw.html
>
> So which of the freedoms did Tivo take away?
>
>     * The freedom to run the program, for any purpose (freedom 0).
>
>     * The freedom to study how the program works, and adapt it to
>       your needs (freedom 1). Access to the source code is a
>       precondition for this.
>
>     * The freedom to redistribute copies so you can help your neighbor
>       (freedom 2).
>
>     * The freedom to improve the program, and release your improvements
>       to the public, so that the whole community benefits (freedom 3).
>       Access to the source code is a precondition for this.
>
> It doesn't seem to me they took away freedoms 1, 2 or 3. They released
> the source to any free software components and we can study, modify,
> redistribute, improve and release our improvements for the benefit of
> the whole community.
>
> btw. freedom 3 seems to be just repeating what we already got from
> freedoms 1 and 2.
>
> So the only one we could differ in opinion about is freedom 0. I would
> say that they in no way are limiting my use of the Linux kernel (which
> is the part I mostly care about) I can run the program for any purpose I
> see fit. What if I want to run mythtv on my PC at home? Tivo has no
> control whether or not I can do so even when my kernel contains any of
> their modification or improvements, so I claim that I in fact retained
> freedom 0.

Much as I hate to extend the life of this execrable thread, since I
think Alexandre makes Sisyphus look like a hard-nosed pragmatist, it
seems pretty clear that TiVO impinges "[my] freedom to run the
program, for any purpose" if "any purpose" includes "make my TiVO do
what I want," and likewise to "adapt it to [my] needs" -- freedoms 0
and part of 1. It is just disingenuous to argue otherwise.

Dave
