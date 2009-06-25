Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZFYGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZFYGiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZFYGiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:38:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39872 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbZFYGiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:38:04 -0400
Date: Thu, 25 Jun 2009 08:38:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-ID: <20090625063806.GC31415@kernel.dk>
References: <20090625131517.d9adc935.sfr@canb.auug.org.au> <20090625133005.9f521529.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625133005.9f521529.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25 2009, Stephen Rothwell wrote:
> On Thu, 25 Jun 2009 13:15:17 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > I can't see how to easily fix this up, so I have dropped the block tree
> > for today (since it only contained 2.6.32 material, right?).
> 
> I also dropped the device-mapper tree for today as it was based on the
> block tree (and dragged in what I had just dropped) and, in any case, all
> its patches have been merged upstream.

OK to both, I'm fixing up the writeback conflicts right now.

-- 
Jens Axboe

