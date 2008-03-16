Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYCPSTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYCPSTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYCPSTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:19:46 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44507 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbYCPSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:19:45 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <alpine.LFD.1.00.0803160958260.3020@woody.linux-foundation.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101336.56159.bzolnier@gmail.com> <200803101410.27877.rjw@sisk.pl> <200803101504.17219.bzolnier@gmail.com> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803160958260.3020@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Sun, 16 Mar 2008 10:13:26 -0700."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 16 Mar 2008 19:18:41 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080316181841.7BFB52DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JaxRa-0006uM-5d.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JaxRa-0006uM-5d 60f2738e22e7454c4a9abb52fdc5b96d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


torvalds@linux-foundation.org said:
>  IOW, try something like this instead of the previous patch.

Applied with fuzz 9 on all hunks.

Reboot. Run smartd. Nothing in dmesg. Hang.



