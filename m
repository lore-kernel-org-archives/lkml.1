Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbYHZUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbYHZUTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYHZUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:19:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYHZUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:19:29 -0400
Date: Tue, 26 Aug 2008 16:19:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits
Message-ID: <20080826201920.GA26980@infradead.org>
References: <20080826070640.GR20055@kernel.dk> <alpine.LFD.1.10.0808261009180.3363@nehalem.linux-foundation.org> <20080826185636.GP20055@kernel.dk> <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 12:02:18PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Aug 2008, Jens Axboe wrote:
> > 
> > I'll move those 1-2 patches to the 2.6.28 branch and resubmit the rest
> > for you.
> 
> You will *delete* the absolute crap locking patch, that has no way of 
> being even 2.6.28 material.
> 
> And you need to be a whole lot more careful.

I can't find the mail you're replying to either in my inbox or on
marc.info.  I also can't really see any xen patch in the rev listing in
Jens' initial mail.  Something got lost her..

