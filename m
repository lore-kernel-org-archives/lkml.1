Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZHaR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZHaR3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZHaR3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:29:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37912 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZHaR3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:29:17 -0400
Date: Mon, 31 Aug 2009 19:29:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 03/10] writeback: get rid of pdflush completely
Message-ID: <20090831172919.GX12579@kernel.dk>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-4-git-send-email-jens.axboe@oracle.com> <20090831125920.GB20465@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831125920.GB20465@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31 2009, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 02:14:44PM +0200, Jens Axboe wrote:
> > It is now unused, so kill it off.
> 
> I would suggest merging it into the previous patch, instead of keeping
> the dead code around a tad longer.

OK, will do.

-- 
Jens Axboe

