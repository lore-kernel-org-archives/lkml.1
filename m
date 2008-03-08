Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYCHVHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYCHVHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYCHVHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:07:01 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54822 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbYCHVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:07:00 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <alpine.LFD.1.00.0803081217250.2911@woody.linux-foundation.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com> <20080306135532.GG17940@kernel.dk> <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org> <20080307084818.GK17940@kernel.dk> <20080307220432.D47E02DC047@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803081217250.2911@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Sat, 08 Mar 2008 12:22:32 -0800."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 08 Mar 2008 22:05:58 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080308210559.0C7A193C070@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JY6Ff-0008SS-4J.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JY6Ff-0008SS-4J 17b92bc46d81716f158cd4ce85878e4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


torvalds@linux-foundation.org said:
> I think we do want the bisect run here.
> My worry is that this is likely very timing-sensitive, so when it starts
> failing it might not be because of the commit that actually introduces the
> bug, but because some other timing changed, but with some luck that won't  
> be the case.

I'm on it. Slow machine. Household's router, 4000 versions to go...

/A

