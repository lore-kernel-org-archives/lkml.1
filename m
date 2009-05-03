Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZECCwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZECCwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZECCw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:52:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:37487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZECCwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:52:25 -0400
Message-ID: <49FD0668.4070403@kernel.org>
Date: Sun, 03 May 2009 11:50:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <20090501182958.GD4593@kernel.dk>
In-Reply-To: <20090501182958.GD4593@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 03 May 2009 02:49:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jens Axboe wrote:
> On Wed, Apr 29 2009, Tejun Heo wrote:
>> Hello,
>>
>> Upon ack, please pull from the following git tree.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len
> 
> Looks sane. When you have collected acks and made suggested changes,
> please repost it and I'll integrate it.

Will do.

> Note that I wont be very responsive the next week or so, taking care
> of a new aspiring kernel hacker.

Alright.  I'm not getting a lot of work done past few days either cuz
I purchased fallout3 and still have a serious score to settle with the
old man.

Thanks and have fun with the newbie.  :-)

-- 
tejun
