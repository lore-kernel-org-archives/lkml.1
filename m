Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbZDGRrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbZDGRrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZDGRrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:47:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47075 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbZDGRrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:47:23 -0400
Date: Tue, 7 Apr 2009 19:47:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: move bio_list fns to bio.h (was [PATCH])
Message-ID: <20090407174722.GB5178@kernel.dk>
References: <20090407162014.GA11899@lst.de> <20090407172853.GL5688@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407172853.GL5688@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07 2009, Alasdair G Kergon wrote:
> On Tue, Apr 07, 2009 at 06:20:14PM +0200, Christoph Hellwig wrote:
> > It's used by DM and MD and generally useful, so move the bio list
> > helpers into bio.h.
>  
> A good idea.
> 
> Jens - do you want to pick that up or shall I include it with the next little
> batch (dm barrier support!) I'm preparing?

Agree, it's a good idea. I'll just include it in the next pull, unless
it makes life more difficult for you.

-- 
Jens Axboe

