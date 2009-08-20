Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZHTPVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZHTPVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZHTPVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:21:38 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:47926 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZHTPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:18:06 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
Date: Thu, 20 Aug 2009 11:17:45 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6; KDE/4.2.4; i686; ; )
Cc: roel kluin <roel.kluin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
 <25e057c00908200151i472fa3cem6da814e7115e1ea7@mail.gmail.com>
 <200908201710.32147.rjw@sisk.pl>
In-reply-to: <200908201710.32147.rjw@sisk.pl>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908201117.45678.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Rafael J. Wysocki wrote:
>On Thursday 20 August 2009, roel kluin wrote:
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
>> > Subject         : Libertas: Association request to the driver failed
>> > Submitter       : Daniel Mack <daniel@caiaq.de>
>> > Date            : 2009-08-07 19:11 (13 days old)
>> > First-Bad-Commit:
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=comm
>> >it;h=57921c312e8cef72ba35a4cfe870b376da0b1b87 References      :
>> > http://marc.info/?l=linux-kernel&m=124967234311481&w=4 Handled-By     
>> > : Roel Kluin <roel.kluin@gmail.com>
>>
>> I think this should be fixed with patch of Dan Williams found here:
>>
>> http://lkml.org/lkml/2009/8/12/299
>
>Thanks, bug entry updated.
>
Has this made it into 2.6.31-rc6?  I have one of these pci cards, and it is 
still a no-show even after modprobing the mwl* and libertas modules.

>Rafael
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

There is no act of treachery or mean-ness of which a political party
is not capable; for in politics there is no honour.
		-- Benjamin Disraeli, "Vivian Grey"

