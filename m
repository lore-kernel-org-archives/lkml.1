Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbXDIT4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbXDIT4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXDIT4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:56:53 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:57591 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271AbXDIT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:56:52 -0400
Date: Mon, 09 Apr 2007 15:56:37 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <20070409174803.GA10189@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200704091556.37903.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org> <461A7246.60003@gmail.com>
 <20070409174803.GA10189@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Ingo Molnar wrote:[...]
>
>i didnt say that, in fact my first lkml comment about RSDL on lkml was
>the exact opposite, but you SD advocates are _still_ bickering about
>(and not accepting) fundamental things like Mike's make -j5 workload and
>flagging it as unrealistic, so until there's so much reality disconnect
>there's not much chance for this issue to progress i'm afraid.

Mikes -j5 workload is AFAIAC, a very realistic workload for building a 
kernel.  My own script I just discovered was using -j8, and that was 
noticeable, but by no means a killing hit on my poor old Xp2800 Athlon.  
I pulled it back to 4 for this mornings build and the hit, while less, is 
still noticeable.  Killer hit?  No way.  Using Mike's v4 patch I think it 
was called.

>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
When you jump for joy, beware that no-one moves the ground from beneath
your feet.
		-- Stanislaw Lem, "Unkempt Thoughts"
