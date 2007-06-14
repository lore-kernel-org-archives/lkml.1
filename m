Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXFNDtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXFNDtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 23:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXFNDts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 23:49:48 -0400
Received: from keil-draco.com ([216.193.185.50]:50167 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbXFNDtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 23:49:47 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 23:49:41 -0400
User-Agent: KMail/1.9.6
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706132243.14651.dhazelton@enter.net> <20070614025640.GQ3588@stusta.de>
In-Reply-To: <20070614025640.GQ3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132349.42044.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 22:56:40 Adrian Bunk wrote:
> On Wed, Jun 13, 2007 at 10:43:14PM -0400, Daniel Hazelton wrote:
> > On Wednesday 13 June 2007 22:08:27 Adrian Bunk wrote:
> > > On Wed, Jun 13, 2007 at 09:40:13PM -0400, Daniel Hazelton wrote:
> > > > On Wednesday 13 June 2007 21:24:01 Adrian Bunk wrote:
> >
> >...
> >
> > > > > Either private keys required to run the kernel on the hardware are
> > > > > always considered part of "the complete source code" or they are
> > > > > never part of it.
> > > >
> > > > No. It all depends on the use-case. If the hardware is designed for
> > > > the user to install their own, custom versions of the code on then
> > > > the signing keys are part of the source as defined by the GPLv2.
> > > >
> > > > If, OTOH, the hardware was never meant for the end-user to install
> > > > custom versions of the software on, then while the signing keys are
> > > > still *technically* part of the source, in practice they are not.
> > > > Why? Because in most of those cases the end-user isn't granted the
> > > > right to install and run custom binaries on the hardware. If the
> > > > manufacturer provided the signing keys they'd be facilitating the
> > > > commission of a crime. (call it "Breach of Contract")
> > > >...
> > >
> > > Repetition doesn't let wrong things become true.
> > >
> > > Where does the GPLv2 talk about the distinction you are trying to make
> > > based on distributor intentions?
> > >
> > > We are talking about the GPLv2 licence text, not about what you would
> > > personally prefer.
> >
> > The GPLv2 doesn't have to cover this distinction to make it a reality.
> > This distinction is *EXACTLY* the type of distinction a lawyer will make
> > when arguing the point.
> >...
>
> Reality check:
>
> Harald convinced companies that they have to provide the private keys
> required to run the Linux kernel they ship on their hardware.

In Germany, not America. I should have qualified my statement to make it clear 
I mean "In America". Sorry about the confusion.

DRH

>
> cu
> Adrian



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
