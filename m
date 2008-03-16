Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYCPSYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYCPSYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYCPSXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:23:54 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:34940 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbYCPSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:23:53 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803161907.04581.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Sun, 16 Mar 2008 19:07:04 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 16 Mar 2008 19:23:13 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080316182313.2EE5B2DC045@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JaxVr-0000mC-6X.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JaxVr-0000mC-6X 0c5505a825e41993867d3a97faca5532
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




bzolnier@gmail.com said:
> This is unlikely as we should get some error message from ide_dump_status()
> and we are not getting any (Anders, please correct me if I'm wrong). 

I don't get any eror message anywhere.


bzolnier@gmail.com said:
> I think that we are looking into completely wrong direction... 

I'd be happy to try out debug patches to trace the call path down and sprinkle 
it with printks. But, shouldn't the sysrq-t log posted earlier give any clues 
as to where things tank? 


