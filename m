Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbXFNSzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbXFNSzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXFNSzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:55:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbXFNSzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:55:02 -0400
Date: Thu, 14 Jun 2007 11:53:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Alexandre Oliva <aoliva@redhat.com>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070614183145.GJ10008@csclub.uwaterloo.ca>
Message-ID: <alpine.LFD.0.98.0706141149100.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <200706140236.39394.dhazelton@enter.net> <orhcpbggcu.fsf@oliva.athome.lsd.ic.unicamp.br>
 <200706140429.11049.dhazelton@enter.net> <orejkefnw9.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070614183145.GJ10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Lennart Sorensen wrote:
> 
> So now the copy of the GPL v2 isn't good enough for the GPLv1.1 code?
> Maybe that code said 'or later' in the license and hence someone added
> it to a GPL v2 project since that sounds perfectly OK.

Where did that GPLv1.1 nonsense come from?

There is no GPLv1.1 code in the tree. By the time I selected the GPL for 
the kernel license, the GPLv1.1 had long since been discontinued. The 
kernel was *never* GPLv1.1-only compatible. That's just total nonsense.

There was indeed a kernel license before the GPLv2, but it wasn't the GPL 
at all, it was my own made-up thing. Appended here, for those who are too 
lazy to actually look up and check the original Linux-0.01 announcement.

		Linus

---
This kernel is (C) 1991 Linus Torvalds, but all or part of it may be
redistributed provided you do the following:

	- Full source must be available (and free), if not with the
	  distribution then at least on asking for it.

	- Copyright notices must be intact. (In fact, if you distribute
	  only parts of it you may have to add copyrights, as there aren't
	  (C)'s in all files.) Small partial excerpts may be copied
	  without bothering with copyrights.

	- You may not distibute this for a fee, not even "handling"
	  costs.
