Return-Path: <linux-kernel-owner+w=401wt.eu-S1763216AbYJJUBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763216AbYJJUBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761042AbYJJUBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:01:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46429 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380AbYJJUBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:01:10 -0400
Date: Fri, 10 Oct 2008 22:00:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com
Subject: Re: [GIT PULL] block changes for 2.6.28
Message-ID: <20081010200034.GH19428@kernel.dk>
References: <20081010080916.GV19428@kernel.dk> <20081010.092914.162463888.davem@davemloft.net> <20081010174931.GG19428@kernel.dk> <20081010.115108.199149570.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010.115108.199149570.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, 10 Oct 2008 19:49:31 +0200
> 
> > On Fri, Oct 10 2008, David Miller wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Date: Fri, 10 Oct 2008 10:09:16 +0200
> > > 
> > > > This is the bulk of the block layer changes for 2.6.28. As other git
> > > > trees are based on this (like SCSI), it would be good if you could merge
> > > > it sooner rather than later.
> > > > 
> > > > Please pull from:
> > > > 
> > > >         git://git.kernel.dk/linux-2.6-block.git for-2.6.28
> > > 
> > > Did you merge in my generic remote softirq bits or are you going
> > > to do that later?
> > 
> > I did not, I thought you would merge them youself (I acked the patchset,
> > iirc). So either do that, or I can take it through the second (and
> > smaller) merge of block bits. Either way, I'm fine with it for 2.6.28
> > :-)
> 
> Please take it in.
> 
> In my final posting of those changes I made it clear that the way
> to do this is to have any users of the infrastructure pull my GIT
> tree in:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/softirq-2.6.git
> 
> and whoever went first into Linus's tree would get it there.
> 
> I'm not at the point where I can use this in the networking and likely
> won't have such work ready for 2.6.28 so it's imperative that you do
> this at this point :-)

OK, not a problem, I'll stack it up for a merge next week.

-- 
Jens Axboe

