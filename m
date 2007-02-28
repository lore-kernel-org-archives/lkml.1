Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbXB1Bup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbXB1Bup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbXB1Bup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:50:45 -0500
Received: from mail.tmr.com ([64.65.253.246]:53295 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXB1Buo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:50:44 -0500
Message-ID: <45E4E036.20507@tmr.com>
Date: Tue, 27 Feb 2007 20:51:50 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Patrick Ale <patrick.ale@gmail.com>
CC: Michael-Luke Jones <jonesml@fastmail.to>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] Sata RAID
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>	 <200702241624.17024.bzolnier@gmail.com>	 <6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>	 <8d158e1f0702240919v33182ca2qc0a15fdd27a3f96a@mail.gmail.com> <8d158e1f0702260030l2f3d9f2ar5c662c807f64f7f7@mail.gmail.com>
In-Reply-To: <8d158e1f0702260030l2f3d9f2ar5c662c807f64f7f7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> On 2/24/07, Patrick Ale <patrick.ale@gmail.com> wrote:
>> On 2/24/07, Michael-Luke Jones <jonesml@fastmail.to> wrote:
> 
> One more question regarding this, I am aware its not *really* kernel
> related but answering this question now will save yourself a lot of
> bogus emails from me about MD oopses later and all, and I want to
> setup my disks right once and for all and never witness what I
> witnessed last weeks with my ATA disks.
> 
> Would you use MD at all, taking in account the disks come from the
> same batch and all? I hear these things about MD/RAID being pointless
> when you use disks from the same brand/type/batch since they most
> likely will break shortly after each other.

Well, for values of "shortly" in months in most cases. These are 
consumer goods, I would not expect units with consecutive serial numbers 
to fail separated by such a short time that you can't do a backup and/or 
replace and rebuild. If quality control were so good they are likely to 
fail at the same time it would be so good they would be obsolete before 
they failed.

That urban myth is a good reason to do backups, but a bad reason to 
avoid RAID.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
