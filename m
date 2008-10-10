Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbYJJRuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbYJJRuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbYJJRuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:50:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54542 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690AbYJJRuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:50:07 -0400
Date: Fri, 10 Oct 2008 19:49:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com
Subject: Re: [GIT PULL] block changes for 2.6.28
Message-ID: <20081010174931.GG19428@kernel.dk>
References: <20081010080916.GV19428@kernel.dk> <20081010.092914.162463888.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010.092914.162463888.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, 10 Oct 2008 10:09:16 +0200
> 
> > This is the bulk of the block layer changes for 2.6.28. As other git
> > trees are based on this (like SCSI), it would be good if you could merge
> > it sooner rather than later.
> > 
> > Please pull from:
> > 
> >         git://git.kernel.dk/linux-2.6-block.git for-2.6.28
> 
> Did you merge in my generic remote softirq bits or are you going
> to do that later?

I did not, I thought you would merge them youself (I acked the patchset,
iirc). So either do that, or I can take it through the second (and
smaller) merge of block bits. Either way, I'm fine with it for 2.6.28
:-)

-- 
Jens Axboe

