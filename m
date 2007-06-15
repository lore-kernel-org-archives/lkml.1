Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbXFOGCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbXFOGCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXFOGCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:02:13 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50390 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXFOGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:02:13 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 02:02:00 -0400
User-Agent: KMail/1.9.6
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <20070615041149.GA6741@brong.net> <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150202.00345.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 01:38:41 Alexandre Oliva wrote:
> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> > #define Dell CFG_FAVOURITE_VENDOR
> >
> > A Dell desktop machine is a piece of hardware.  The manufacturer has the
> > source code (hypothetically) to the BIOS.  The BIOS is required for the
> > machine to boot and run Linux.
> >
> > Riddle me this (especially Alexandre, I'm just latching on to Ingo's
> > post because it has the right hook to grab) - are Dell required to give
> > out the source to the bios to enable people to have the same rights Dell
> > engineers do to modify the behaviour of the system?
>
> What is the license for the bios?  Does it say anything about 'no
> further restrictions on the freedoms to modify and share the
> software'?
>
> Does it include any mechanisms to stop people from booting modified
> versions of the Linux that ships with the machine?

Does it matter? The hardware is running a GPL'd project. You have repeatedly 
stated that if a system runs a GPL'd system then all rights to the system 
that the manufacturer has *must* be passed on to the end-user. The 
manufacturer can change the Bios. That's a right they have. Do they have to 
pass that on to the end-user.

Before you answer - this question is *NOT* based on any interpretation or 
reading of the GPLv3. What it is based on is statements you have repeatedly 
made. So no claims this being already covered, and no claims that this isn't 
a situation covered by the GPLv3.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
