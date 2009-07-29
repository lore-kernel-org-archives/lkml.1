Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZG2FAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZG2FAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZG2FAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:00:47 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:34950 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZG2FAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:00:47 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 01:00:45 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <200907282250.46018.gene.heskett@verizon.net>
 <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907290100.46160.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Linus Torvalds wrote:
>On Tue, 28 Jul 2009, Gene Heskett wrote:
>> It doesn't seem to do anything for bz 13841 here.  Sorry, I wish it did.
>
>No, bz 13841 isn't about pty's, it's about usb serial. The patches in this
>thread would mainly be pty-related, and would affect other tty drivers
>(like your usb one) only purely by chance.
>
>could you bisect the 13841 behavior?
>
>		Linus

I may have to bite the bullet and spend a couple days doing that.  I don't 
know as my f10 installed git is new enough to work with the recent changes in 
it, I've rx'd several notices from Junio about new versions that fedora hasn't 
offered as updates.

Link to a tutorial plz?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

One picture is worth 128K words.

