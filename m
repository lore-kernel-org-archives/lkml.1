Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbZEASaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbZEASaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbZEASaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:30:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47166 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854AbZEASaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:30:00 -0400
Date: Fri, 1 May 2009 20:29:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org,
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
Message-ID: <20090501182958.GD4593@kernel.dk>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29 2009, Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len

Looks sane. When you have collected acks and made suggested changes,
please repost it and I'll integrate it.

Note that I wont be very responsive the next week or so, taking care of
a new aspiring kernel hacker.

-- 
Jens Axboe

