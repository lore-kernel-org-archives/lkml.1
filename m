Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbXFNWvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbXFNWvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXFNWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:51:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40634 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbXFNWv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:51:27 -0400
Date: Thu, 14 Jun 2007 23:56:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614235619.70930516@the-village.bc.nu>
In-Reply-To: <200706141836.30119.dhazelton@enter.net>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<20070614183145.GJ10008@csclub.uwaterloo.ca>
	<alpine.LFD.0.98.0706141149100.14121@woody.linux-foundation.org>
	<200706141836.30119.dhazelton@enter.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A hundred or so messages back someone stated that the parport driver in Linux 
> is GPLv1.1 - however, on checking on this statement for myself I've found 
> that there is no statement about it being v1.1 and, in fact, given that Linux 
> itself is GPLv2 there is no possible way any code covered by GPLv1.1 can 
> exist.

Wrong again.

If a piece of code was merged into the kernel with a GPL v1 "or later"
license then it still has a GPL v1 "or later" license.  The "or later"
makes it compatible with the v2 code but does not change the fundamental
copyright on the original work that was combined. Thus if you could
identify specifically a GPL v1 work within the kernel you could use that
GPL v1 work as per GPL v1 providing you didn't mix it with v2 code.

If I take a public domain book and create a derivative work from it the
original work does not magically become restricted.

Alan
