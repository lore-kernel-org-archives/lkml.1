Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYH1Obb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYH1Obb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYH1ObN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:31:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYH1ObM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:31:12 -0400
Date: Thu, 28 Aug 2008 10:30:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: kmalloc args reversed, small function
	definition  fixes
Message-ID: <20080828143055.GA10469@infradead.org>
References: <1219868669.6069.53.camel@brick> <20080828072621.GQ20055@kernel.dk> <20080828141933.GA8937@infradead.org> <20080828142800.GG20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828142800.GG20055@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 04:28:00PM +0200, Jens Axboe wrote:
> > > Woops, that kmalloc() is nasty. Thanks a lot, applied to for-2.6.28.
> > 
> > Umm, the gfp bit sounds like a clear 2.6.27 candidate.
> 
> I would agree, except the bug is introduced by a patch in the 2.6.28
> series :-)

Ah, okay.  Makes sense then.
