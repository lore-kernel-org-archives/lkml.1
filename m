Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZFWLJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZFWLJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZFWLJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:09:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZFWLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:09:34 -0400
Date: Tue, 23 Jun 2009 07:09:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       hch@infradead.org
Subject: Re: merging the per-bdi writeback patchset
Message-ID: <20090623110933.GA16565@infradead.org>
References: <20090623081156.GT31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623081156.GT31415@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 10:11:56AM +0200, Jens Axboe wrote:
> Hi,
> 
> Things are looking good for this patchset and it's been in -next for
> almost a week without any reports of problems. So I'd like to merge it
> for 2.6.31 if at all possible. Any objections?

Last time we discussed this you said you're happy with 2.6.32.  I really
want to take a more detailed look and put that on the not so urgent list
because ou didn't seem to rush for .31.  So my vote goes for waiting a
bit longer.

