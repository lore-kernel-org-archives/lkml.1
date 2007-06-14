Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXFNWg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXFNWg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXFNWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:36:48 -0400
Received: from keil-draco.com ([216.193.185.50]:50238 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbXFNWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:36:46 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 18:36:29 -0400
User-Agent: KMail/1.9.6
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <20070614183145.GJ10008@csclub.uwaterloo.ca> <alpine.LFD.0.98.0706141149100.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706141149100.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141836.30119.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 14:53:47 Linus Torvalds wrote:
> On Thu, 14 Jun 2007, Lennart Sorensen wrote:
> > So now the copy of the GPL v2 isn't good enough for the GPLv1.1 code?
> > Maybe that code said 'or later' in the license and hence someone added
> > it to a GPL v2 project since that sounds perfectly OK.
>
> Where did that GPLv1.1 nonsense come from?
>
> There is no GPLv1.1 code in the tree. By the time I selected the GPL for
> the kernel license, the GPLv1.1 had long since been discontinued. The
> kernel was *never* GPLv1.1-only compatible. That's just total nonsense.
>
> There was indeed a kernel license before the GPLv2, but it wasn't the GPL
> at all, it was my own made-up thing. Appended here, for those who are too
> lazy to actually look up and check the original Linux-0.01 announcement.
>

A hundred or so messages back someone stated that the parport driver in Linux 
is GPLv1.1 - however, on checking on this statement for myself I've found 
that there is no statement about it being v1.1 and, in fact, given that Linux 
itself is GPLv2 there is no possible way any code covered by GPLv1.1 can 
exist.

DRH

> 		Linus
>
> ---
> This kernel is (C) 1991 Linus Torvalds, but all or part of it may be
> redistributed provided you do the following:
>
> 	- Full source must be available (and free), if not with the
> 	  distribution then at least on asking for it.
>
> 	- Copyright notices must be intact. (In fact, if you distribute
> 	  only parts of it you may have to add copyrights, as there aren't
> 	  (C)'s in all files.) Small partial excerpts may be copied
> 	  without bothering with copyrights.
>
> 	- You may not distibute this for a fee, not even "handling"
> 	  costs.



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
