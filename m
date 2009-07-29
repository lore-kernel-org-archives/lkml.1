Return-Path: <linux-kernel-owner+w=401wt.eu-S1751496AbZG2FEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbZG2FEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZG2FEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:04:14 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:36767 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZG2FEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:04:14 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 01:04:09 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
 <alpine.LFD.2.01.0907282153300.3161@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0907282153300.3161@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907290104.09732.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Linus Torvalds wrote:
>On Tue, 28 Jul 2009, Linus Torvalds wrote:
>> could you bisect the 13841 behavior?
>
>Oh - and have you checked current -git? There's commit c56d300086, which
>may well have fixed some problems with openign a serial USB device.
>
>		Linus

No I haven't Linus, been running on your vanilla releases.  I'd say I know 
just enough about this to be dangerous (to myself) :)

Syntax to do that if my git is new enough?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

The average Ph.D thesis is nothing but the transference of bones from
one graveyard to another.
		-- J. Frank Dobie, "A Texan in England"

