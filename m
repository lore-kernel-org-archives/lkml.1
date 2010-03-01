Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0CAIEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:04:10 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57141 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0CAIEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:04:05 -0500
Date: Mon, 1 Mar 2010 09:04:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: manual merge of the usb tree with the block tree
Message-ID: <20100301080402.GP5768@kernel.dk>
References: <20100301185441.06014ba8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301185441.06014ba8.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01 2010, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/storage/scsiglue.c between commit
> 086fa5ff0854c676ec333760f4c0154b3b242616 ("block: Rename
> blk_queue_max_sectors to blk_queue_max_hw_sectors") from the block tree
> and commit 628726dbb5ebbec77336019ac4e1f60cf3ba08c1 ("usb-storage: use
> max_hw_sectors instead of max_sectors") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks Stephen, looks good.

-- 
Jens Axboe

