Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbXJWRTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbXJWRTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXJWRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:19:04 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:59626 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXJWRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:19:03 -0400
Date: Tue, 23 Oct 2007 13:18:59 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       torvalds@linux-foundation.org, kyle@parisc-linux.org,
       linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: [PATCH] parisc: fix sg_page() fallout
Message-ID: <20071023171859.GD4695@fattire.cabal.ca>
References: <20071023150017P.fujita.tomonori@lab.ntt.co.jp> <20071023073035.GL25962@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023073035.GL25962@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 09:30:35AM +0200, Jens Axboe wrote:
> > arch/parisc/kernel/pci-dma.c:545: error: 'struct scatterlist' has no member named 'page'
> 
> Applied.
> 

Thanks!

Cheers,
	Kyle
