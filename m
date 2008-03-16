Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYCPSZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYCPSZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYCPSZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:25:23 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35681 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbYCPSZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:25:22 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803161926.36169.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <200803161926.36169.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Sun, 16 Mar 2008 19:26:35 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 16 Mar 2008 19:25:01 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080316182501.2EF0B2DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JaxXZ-0007VG-9T.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JaxXZ-0007VG-9T 64c6aab9015205c2cf1b91a9cc54c65a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




bzolnier@gmail.com said:
> I really do think that it is the same hang-in-block-layer issue that Ingo
> managed to hit once (his system was using libata)... 

When I tried libata, smartd runs just fine, FWIW.

