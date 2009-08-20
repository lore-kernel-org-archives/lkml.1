Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZHTCvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZHTCvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZHTCvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:51:49 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:49691 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZHTCvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:51:48 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13899] Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Date: Wed, 19 Aug 2009 22:51:39 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6; KDE/4.2.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
 <ADSuNT6McuD.A.-IB.NOIjKB@chimera>
In-reply-to: <ADSuNT6McuD.A.-IB.NOIjKB@chimera>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908192251.39372.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 August 2009, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.30.  Please verify if it still should be listed and let me know
>(either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13899
>Subject		: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
>Submitter	: Gene Heskett <gene.heskett@verizon.net>
>Date		: 2009-08-01 13:04 (19 days old)
>References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4

I have not seen this since I rebooted to 31-rc6 3.5 days ago.  So apparently 
something that went into rc6 that was not in rc5, has fixed it.  I have had 
one kmail crash, but IIRC that was after yum had updated something.  I 
believe this particular tar related  item has been attended to.  Close it 
out.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

If *I* had a hammer, there'd be no more folk singers.

