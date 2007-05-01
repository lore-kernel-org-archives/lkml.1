Return-Path: <linux-kernel-owner+w=401wt.eu-S1031623AbXEAJYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031623AbXEAJYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031627AbXEAJYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:24:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59383 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031623AbXEAJYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:24:51 -0400
Date: Tue, 1 May 2007 10:24:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hch@lst.de, npiggin@suse.de, a.p.zijlstra@chello.nl
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070501092448.GA21263@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, hch@lst.de,
	npiggin@suse.de, a.p.zijlstra@chello.nl
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:17:28PM +0300, Pekka Enberg wrote:
> On 5/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > revoke-special-mmap-handling.patch
> 
> [snip]
> 
> >Hold.  This is tricky stuff and I don't think we've seen sufficient
> >reviewing, testing and acking yet?
> 
> Agreed. While Peter and Nick have done some review of the patches, I
> would really like VFS maintainers to review them before merge.
> Christoph, have you had the chance to take a look at it?

Not so far, but it's on my long list of highly useful things I want to review.
