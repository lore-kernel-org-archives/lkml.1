Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXJOHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXJOHxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXJOHxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:53:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15728 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXJOHxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:53:03 -0400
Date: Mon, 15 Oct 2007 09:52:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, iss_storagedev@hp.com
Subject: Re: [PATCH] drivers/block/cpqarray,cciss: kill unused var
Message-ID: <20071015075247.GG5380@kernel.dk>
References: <20071013190348.GA19992@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071013190348.GA19992@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13 2007, Jeff Garzik wrote:
> The recent bio work and subsequent fixups created unused variables.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/block/cciss.c    |    1 -
>  drivers/block/cpqarray.c |    3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)

Thanks Jeff, applied.

-- 
Jens Axboe

