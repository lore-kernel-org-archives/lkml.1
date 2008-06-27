Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYF0JEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYF0JEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYF0JEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:04:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10557 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbYF0JEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:04:47 -0400
Date: Fri, 27 Jun 2008 11:04:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: What's in linux-2.6-block.git for 2.6.27
Message-ID: <20080627090444.GT20851@kernel.dk>
References: <20080626115404.GS20851@kernel.dk> <4864AC27.8040204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4864AC27.8040204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27 2008, Milan Broz wrote:
> Jens Axboe wrote:
> > So this time it's a little beyond just block stuff, since the
> > generic-ipi branch is included (in preparation for block parts actually
> > using that code).
> 
> Hi,
> 
> please could you also add this patch?
> http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-md-merge_bvec_fn-with-separate-bdev-and-sector.patch
> 
> (following device-mapper bvec merge function patches rely on it...)
> 
> Or is there some objections to not include it?

Yep, I have agreed to that patch before, I'll add it.

-- 
Jens Axboe

