Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYHATCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYHATCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYHATCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:02:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbYHATCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:02:43 -0400
Date: Fri, 1 Aug 2008 15:02:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Lachlan McIlroy <lachlan@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.27
Message-ID: <20080801190240.GA23604@infradead.org>
References: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com> <20080731034952.GC13395@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731034952.GC13395@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:49:52PM +1000, Dave Chinner wrote:
> author of that patch. I don't know why there's duplicates of it
> in the tree - the only thing I can see is that the committer's
> email address is not stable. There is a growing number of
> duplicate commits like this in the XFS tree.....

Yes, I pointed this out before.  But at this point I'd rather have
the XFS changes in .27 and not completely miss the window even if
that means some patches are not correctly atributed to me.

