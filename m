Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbXJXJak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbXJXJak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbXJXJaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:30:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49630 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXJXJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:29:57 -0400
Message-ID: <471F104C.5040005@torque.net>
Date: Wed, 24 Oct 2007 11:28:44 +0200
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
References: <1193173128.3434.1.camel@localhost.localdomain>	 <471E6313.1040704@garzik.org> <1193174424.3434.3.camel@localhost.localdomain> <471E707B.1020505@garzik.org>
In-Reply-To: <471E707B.1020505@garzik.org>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> James Bottomley wrote:
>> On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
>>> James Bottomley wrote:
>>>> This should be the final SCSI updates; it's mainly just a few accessor
>>>> completion updates and two driver merges (sym2 and qla2xxx) we also
>>>> secured DaveM's agreement to remove fcal/fc4, which explains the high
>>>> removal line count.
>>>>
>>>> The patch is available here:
>>>>
>>>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>>> I guess I have the go-ahead to merge the end-CDROM-polling async
>>> notification work you've been repeatedly ignoring?
>>
>> I haven't been ignoring it ... it just needs quite a bit of work; the
>> best way to accelerate it seems to be simply to do it (add the
>> supported/trigger event bitmasks and expand the infrastructure).  I just
>> haven't had the time within the merge window.
> 
> James, things cannot get bottlenecked like this.  You have had MONTHS to
> say something like this.  The code was ready BEFORE the merge window.
> 
> I really think you have the knowledge to be SCSI maintainer, but not the
> time.

Jeff,
If only I had a dollar (Canadian unit please) for
each day some of my libata patches were queued
up to you before you accepted them.

Remember MODE SELECT ...


On a more serious note, it looks like the job of the SCSI
maintainer is getting larger and more onerous. Perhaps
some folks should check if James has been provided with
the appropriate resources.

Doug Gilbert
