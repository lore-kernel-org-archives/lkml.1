Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXJROKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXJROKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761772AbXJROKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:10:37 -0400
Received: from rtr.ca ([76.10.145.34]:2924 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXJROKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:10:37 -0400
Message-ID: <4717695B.5020806@rtr.ca>
Date: Thu, 18 Oct 2007 10:10:35 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018125840.GF5063@kernel.dk> <20071018133200.GH5063@kernel.dk> <471764CB.5020906@rtr.ca> <20071018135810.GM5063@kernel.dk>
In-Reply-To: <20071018135810.GM5063@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Oct 18 2007, Mark Lord wrote:
>> > Jens wrote:
>>> >> OK, I think that covers every arch out there. I haven't been able to
>>> >> compile any of them, but it's mostly search'n replace operations. I hope
>>> >> nothing is missing linux/scatterlist.h includes...
>> >
>> > Patch fails on drivers/scsi/scsi_lib.c.
>> >
>> > I replaced that part of the patch with this updated portion instead:
> 
> Hmm, what are you applying against? Must be a clean tree, throw away any
> patches that you already applied in this thread.
> 
> Updated below.


I'll re-pull everything fresh again from kernel.org and rebuild
with the "updated below" patch you posted.  Thanks.
