Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYCXWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYCXWYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYCXWYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:24:31 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48517 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYCXWYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:24:30 -0400
Date: Tue, 25 Mar 2008 00:23:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Message-ID: <20080324222328.GB1789@cs181133002.pp.htv.fi>
References: <20080321224250.144333319@sous-sol.org> <20080321224333.400857992@sous-sol.org> <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com> <20080321.171401.49157146.davem@davemloft.net> <84144f020803221557t36502f6bo327c95705be706bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84144f020803221557t36502f6bo327c95705be706bf@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 12:57:29AM +0200, Pekka Enberg wrote:
> Hi David,
> 
> On Sat, Mar 22, 2008 at 2:14 AM, David Miller <davem@davemloft.net> wrote:
> >  It makes a difference for driver maintainers when users
> >  report bugs and we ask them for the version printed
> >  by the driver so that we know which fixes have been
> >  applied.
> >
> >  You know, if people are going to be jerky about this,
> >  I'll just include the version bump in the actual bug
> >  fixes which I sometimes do anyways.
> >
> >  Thanks for bringing this up, it's a useful use of
> >  everyone's time :-/
> 
> Uhm, Jesper was asking a relevant question and definitely not being
> "jerky". As you probably know, many of us are dropping explicit driver
> versions from the code for the exact reason why you're trying to patch
> the stable tree now. They get out of sync real easy and the kernel
> version already provides the same information so why bother.
>...

There are two completely different cases one mustn't confuse:

> 90% of all version numbers, cvs tags,... in the kernel haven't been 
updated for ages and should be removed.

But there are some drivers and ALSA that have an active maintainer, an 
actively maintained version number, and tend to often be backported into 
distribution kernels.

>                         Pekka

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

