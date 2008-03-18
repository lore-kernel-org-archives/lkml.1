Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbYCSVaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbYCSVaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762672AbYCSUD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:03:27 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34571 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbYCSUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:03:22 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <alpine.LFD.1.00.0803180943300.3020@woody.linux-foundation.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> <20080318001831.575D093C911@tippex.mynet.homeunix.org> <200803181403.37969.bzolnier@gmail.com> <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org> <20080318163004.018332DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803180943300.3020@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Tue, 18 Mar 2008 09:47:28 -0700."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 18 Mar 2008 22:02:57 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080318210258.29E5A2DC027@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1JbixZ-0000qn-5S.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JbixZ-0000qn-5S af7f9c121eb8f8b31aed86917b9a0e85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


torvalds@linux-foundation.org said:
> I suspect the reason you had to hand-apply it may be the other  test-patches
> you had. Can you just undo those? Since it looks like it may  be working for
> you, the debug patches are just adding tons of noise by  now, and it would be
> good to hear whether the status with that last patch  is just a simple "ok,
> it works now". 

Latest git with your patch works perfectly.

Thanks a lot!!

/Anders



