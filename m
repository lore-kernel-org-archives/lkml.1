Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZCYToh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZCYToh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZCYTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:44:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZCYToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:44:25 -0400
Date: Wed, 25 Mar 2009 15:43:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325194300.GA29731@infradead.org>
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CA86BD.6060205@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:32:13PM -0400, Jeff Garzik wrote:
> So, no, for 95% of Linux users, fsync does _not_ already do that.  If  
> you are lucky enough to use XFS or ext4, you're covered.  That's it.

reiserfs also does the correct thing.  As does ext3 on suse kernels.

