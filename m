Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbXFOACp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbXFOACp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXFOACg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:02:36 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:25876 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750861AbXFOACf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:02:35 -0400
Date: Fri, 15 Jun 2007 02:02:32 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexandre Oliva <aoliva@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615000232.GB9463@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexandre Oliva <aoliva@redhat.com>, Adrian Bunk <bunk@stusta.de>,
	Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
	Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
	david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu> <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org> <orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org> <ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org> <20070614231812.GA9463@alinoe.com> <20070615003919.1abfb155@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615003919.1abfb155@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 12:39:19AM +0100, Alan Cox wrote:
> > This is the main reason I dislike GPLwhatever: there is no notion
> > of "orginal author". You might have written 99% of the code, that
> 
> Every literary work (including thus software) has an author, and that
> author has certain rights which are implicit in them being author.

Like, they can release/sell the whole thing under some arbitrary
other license at their choice. But once you license it with the GPLv2,
then you can't stop anyone else (who got it under that license) from
using the code under that license anymore, as such it doesn't matter that
you are the original author.

> > doesn't matter. You have no rights whatsoever once you release
> > something under the GPL (no more than ANYOne else).
> 
> Wrong. The author has a collection of rights which vary by jurisdiction
> but which are primarily governed by the Berne Convention and its sequels
> notably TRIPS.
> 
> > The GPL is nice for the community, and for the users - but very,
> > very bad towards it's authors (taking all and every right you might
> > have). If John Doe wants to re-release the whole kernel under
> 
> You must be using a different GPL to the rest of us.

You actually had me check the license of the linux kernel :p
But really - it has this paragraph that I was refering to in most of it's
source files:

* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.

I might be wrong, but I always thought that that meant that John Doe
is free to redistribute the software under version 3 of the License,
as published by the FSF.

There are source files in the kernel without this phrase, ie - they
just say: * This file is released under the GPL.

But then the paragraph from COPYING kicks in, reading:

Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

Any, 'any version' probably includes version 3 as well.

Finally, there are file that don't mention the GPL at all, for example
kernel/sys.c just says:

 *  Copyright (C) 1991, 1992  Linus Torvalds

But - if it weren't GPL-ed then that would be a violation of the GPL-ed
of the rest (Nevertheless, I think the license header should be added
to those files).

> > GPLv3, then all he needs is a website and some bandwidth.
> 
> And a very good lawyer (oh and a GPL3 as there isn't one yet...)

I really don't like license discussions - and after reading in the
mailinglist FAQ that license posts are taboo here - I was partly annoyed,
partly amazed to see this HUGE flood of mails with as subject line
"Dual-Licensing Linux Kernel with GPL V2 and GPL V3"

I am sorry that I drew the apparently wrong conclusion that GPL V3
is a pressing reality.

> Alan

-- 
Carlo Wood <carlo@alinoe.com>
