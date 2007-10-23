Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXJWWHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXJWWHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXJWWG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:06:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47532 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXJWWG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:06:57 -0400
Message-ID: <471E707B.1020505@garzik.org>
Date: Tue, 23 Oct 2007 18:06:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
References: <1193173128.3434.1.camel@localhost.localdomain>	 <471E6313.1040704@garzik.org> <1193174424.3434.3.camel@localhost.localdomain>
In-Reply-To: <1193174424.3434.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> This should be the final SCSI updates; it's mainly just a few accessor
>>> completion updates and two driver merges (sym2 and qla2xxx) we also
>>> secured DaveM's agreement to remove fcal/fc4, which explains the high
>>> removal line count.
>>>
>>> The patch is available here:
>>>
>>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>> I guess I have the go-ahead to merge the end-CDROM-polling async 
>> notification work you've been repeatedly ignoring?
> 
> I haven't been ignoring it ... it just needs quite a bit of work; the
> best way to accelerate it seems to be simply to do it (add the
> supported/trigger event bitmasks and expand the infrastructure).  I just
> haven't had the time within the merge window.

James, things cannot get bottlenecked like this.  You have had MONTHS to 
say something like this.  The code was ready BEFORE the merge window.

I really think you have the knowledge to be SCSI maintainer, but not the 
time.

	Jeff



