Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYHYSek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYHYSek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYHYSeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:34:08 -0400
Received: from [93.163.65.50] ([93.163.65.50]:1341 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYHYSeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:34:06 -0400
Date: Mon, 25 Aug 2008 20:34:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com,
       bharrosh@panasas.com, greg.freemyer@gmail.com,
       linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca,
       viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/3 blk-for-2.6.28] block: unify disk/part handling and improve ext devt, take #2
Message-ID: <20080825183403.GN20055@kernel.dk>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25 2008, Tejun Heo wrote:
> Hello, again.
> 
> This is the second take of unify-disk-part-handling patchset.
> 
> Changes from the last take[L] are...
> 
> * adapted to blk-for-2.6.28.
> * devt alloc path simplification in 0013.

Applied all four, thanks Tejun.

-- 
Jens Axboe

