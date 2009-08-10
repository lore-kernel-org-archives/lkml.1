Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZHJDmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZHJDmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZHJDmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:42:46 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:33717 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZHJDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:42:45 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13899] Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Date: Sun, 09 Aug 2009 23:42:43 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
 <u1L1PAbl8zG.A.1SD.pj1fKB@chimera>
In-reply-to: <u1L1PAbl8zG.A.1SD.pj1fKB@chimera>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908092342.43656.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009, Rafael J. Wysocki wrote:
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
>Date		: 2009-08-01 13:04 (9 days old)
>References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4

Yes, it is still doing it to rc5 but only on the first invocation after the 
bootup.  Strangely, it apparently has no other effect, either on the machine, 
or how amanda itself works.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

If I set here and stare at nothing long enough, people might think
I'm an engineer working on something.
		-- S.R. McElroy

