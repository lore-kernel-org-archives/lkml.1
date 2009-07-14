Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZGNEKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZGNEKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZGNEKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:10:39 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48632 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZGNEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:10:38 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: OOM killer in 2.6.31-rc2
Date: Tue, 14 Jul 2009 00:10:25 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2; KDE/4.2.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <200907061056.00229.gene.heskett@verizon.net>
 <200907110819.30337.gene.heskett@verizon.net> <20090712051441.GA7903@localhost>
In-reply-to: <20090712051441.GA7903@localhost>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907140010.25643.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Wu Fengguang wrote:

>> This 18 hours of uptime is a record by at least 3x what I've ever gotten
>> from this bios before.  On the one hand I am pleased, on the other the
>> lack of results so far has to be somewhat disappointing.
>
>Don't be in a hurry. Just enjoy the current good state until OOM revisits :)

Its been about 3d 10h of uptime now, and its been boringly stable.  Darn it.

Memory usage ack to htop has about doubled (to 828 megs from 385 or so 
originally), and its 24MB into swap, so I'd assume there is a small leak 
somewhere.  At this rate it will take weeks to trigger this again.

I've now built 2.6.31-rc3 with pretty much the same options re: memory, and 
will probably reboot to it in the morning as its approaching the witching hour 
here.  Any objections?

>Thanks,
>Fengguang

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Q:	Why haven't you graduated yet?
A:	Well, Dad, I could have finished years ago, but I wanted
	my dissertation to rhyme.

