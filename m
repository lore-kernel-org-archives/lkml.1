Return-Path: <linux-kernel-owner+w=401wt.eu-S1763161AbYCGWG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763161AbYCGWG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYCGWGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:06:16 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:46834 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbYCGWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:06:16 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Jens Axboe <jens.axboe@oracle.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <20080307084818.GK17940@kernel.dk> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com> <20080306135532.GG17940@kernel.dk> <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org> <20080307084818.GK17940@kernel.dk>
Comments: In-reply-to Jens Axboe <jens.axboe@oracle.com>
   message dated "Fri, 07 Mar 2008 09:48:19 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 07 Mar 2008 23:04:32 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080307220432.D47E02DC047@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JXkhH-0003Mj-78.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JXkhH-0003Mj-78 deb0888d71d0414b7a3e63f744a82ebd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


jens.axboe@oracle.com said:
> Can you try with noop or deadline as the default, to see if it reproduces
> with them? 

Fails in the same way using noop, deadline and cfq on -rc4

/A


