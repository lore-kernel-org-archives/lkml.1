Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbXFNC4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbXFNC4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXFNC43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:56:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34527 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754578AbXFNC42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:56:28 -0400
Date: Thu, 14 Jun 2007 04:56:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614025640.GQ3588@stusta.de>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net> <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706132243.14651.dhazelton@enter.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 10:43:14PM -0400, Daniel Hazelton wrote:
> On Wednesday 13 June 2007 22:08:27 Adrian Bunk wrote:
> > On Wed, Jun 13, 2007 at 09:40:13PM -0400, Daniel Hazelton wrote:
> > > On Wednesday 13 June 2007 21:24:01 Adrian Bunk wrote:
>...
> > > > Either private keys required to run the kernel on the hardware are
> > > > always considered part of "the complete source code" or they are never
> > > > part of it.
> > >
> > > No. It all depends on the use-case. If the hardware is designed for the
> > > user to install their own, custom versions of the code on then the
> > > signing keys are part of the source as defined by the GPLv2.
> > >
> > > If, OTOH, the hardware was never meant for the end-user to install custom
> > > versions of the software on, then while the signing keys are still
> > > *technically* part of the source, in practice they are not. Why? Because
> > > in most of those cases the end-user isn't granted the right to install
> > > and run custom binaries on the hardware. If the manufacturer provided the
> > > signing keys they'd be facilitating the commission of a crime. (call it
> > > "Breach of Contract")
> > >...
> >
> > Repetition doesn't let wrong things become true.
> >
> > Where does the GPLv2 talk about the distinction you are trying to make
> > based on distributor intentions?
> >
> > We are talking about the GPLv2 licence text, not about what you would
> > personally prefer.
> 
> The GPLv2 doesn't have to cover this distinction to make it a reality. This 
> distinction is *EXACTLY* the type of distinction a lawyer will make when 
> arguing the point.
>...

Reality check:

Harald convinced companies that they have to provide the private keys 
required to run the Linux kernel they ship on their hardware.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

