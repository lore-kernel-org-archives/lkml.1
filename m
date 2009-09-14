Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZINNTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZINNTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZINNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:19:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZINNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:19:49 -0400
Date: Mon, 14 Sep 2009 09:19:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 1/7] writeback: merely wakeup flusher thread if work
	allocation fails for WB_SYNC_NONE
Message-ID: <20090914131949.GA29310@infradead.org>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-2-git-send-email-jens.axboe@oracle.com> <20090914123425.GF24075@duck.suse.cz> <20090914123929.GF14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914123929.GF14984@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 02:39:29PM +0200, Jens Axboe wrote:
> 
> >  BTW, don't we miss Christoph's Signed-off-by?
> 
> We do, he didn't include one.


Signed-off-by: Christoph Hellwig <hch@lst.de>

also for Jens' slightly improved version.
