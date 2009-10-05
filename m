Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZJEHzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZJEHzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbZJEHzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:55:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55937 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291AbZJEHzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:55:52 -0400
Date: Mon, 5 Oct 2009 09:55:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com
Subject: Re: linux-next: block/drbd tree build failure
Message-ID: <20091005075515.GT26573@kernel.dk>
References: <20091005143552.977a2d4d.sfr@canb.auug.org.au> <20091005063138.GO26573@kernel.dk> <20091005182103.0a391d15.sfr@canb.auug.org.au> <20091005072929.GS26573@kernel.dk> <20091005185340.742f6abc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005185340.742f6abc.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Mon, 5 Oct 2009 09:29:29 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > Ah indeed, thanks. I'll put a fixup patch in place.
> 
> Thanks.

Already done, should work now.

-- 
Jens Axboe

