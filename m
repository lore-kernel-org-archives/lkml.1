Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYCUPHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYCUPHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYCUPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:07:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37323 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753255AbYCUPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:07:07 -0400
Date: Fri, 21 Mar 2008 14:49:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080321144912.4e09df5e@core>
In-Reply-To: <47E3CE44.4000000@rtr.ca>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
	<20080316140118.891732DC044@tippex.mynet.homeunix.org>
	<alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
	<200803161907.04581.bzolnier@gmail.com>
	<alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
	<20080316185602.79064f7c@core>
	<alpine.LFD.1.00.0803161238190.3020@woody.linux-foundation.org>
	<20080316203109.50e8c526@core>
	<47E3CE44.4000000@rtr.ca>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Err.. I have a fairly modern PATA drive (160GB seagate 2.5")
> that gets pissed if we leave DRQ hanging.  So it's not just
> something for old/obsolete drives.
> 
> Or maybe it's the also-modern-ish ICH chipset that gets stuck. 

ICH's with AHCI support seem to get peeved.

Alan
