Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbZEGK3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbZEGK3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761845AbZEGK3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:29:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:43709 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761827AbZEGK3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:29:09 -0400
Date: Thu, 7 May 2009 19:23:24 +0900
To: tj@kernel.org
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com, dgilbert@interlog.com, djwong@us.ibm.com
Subject: Re: [PATCH 03/11] block: add rq->resid_len
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241423927-11871-4-git-send-email-tj@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
	<1241423927-11871-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090507184820F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 19:23:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 May 2009 16:58:39 +0900
Tejun Heo <tj@kernel.org> wrote:

> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  block/bsg.c                              |    8 +++---

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The changes to sg, st, and smp stuff also look fine.
