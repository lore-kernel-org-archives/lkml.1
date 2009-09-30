Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZI3TjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZI3TjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbZI3TjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:39:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZI3TjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:39:10 -0400
Date: Wed, 30 Sep 2009 15:39:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block updates for 2.6.32-rc
Message-ID: <20090930193911.GA14391@infradead.org>
References: <20090930174109.GD14918@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930174109.GD14918@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 07:41:10PM +0200, Jens Axboe wrote:
> Hi Linus,
> 
> This looks huge, but it's mostly a cciss driver update and the addition
> of drbd. I would have submitted this before -rc1, but Plumbers got in
> the way.

And DRBD is defintively not ready.  Even if people want to merge another
duplicate RAID driver including another crappy user interface it has
tracing stuff of a form that would let Ingo go beserk and also uses the
stupid connector.

