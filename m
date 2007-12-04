Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXLDMIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXLDMIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXLDMIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:08:24 -0500
Received: from brick.kernel.dk ([87.55.233.238]:14729 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXLDMIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:08:22 -0500
Date: Tue, 4 Dec 2007 13:06:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 00/28] blk_end_request: full I/O completion handler
	(take 3)
Message-ID: <20071204120612.GP23294@kernel.dk>
References: <20071130.182351.115904044.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130.182351.115904044.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30 2007, Kiyoshi Ueda wrote:
> Hello Jens,
> 
> The following is the updated patch-set for blk_end_request().
> Changes since the last version are only minor updates to catch up
> with the base kernel changes.
> Do you agree the implementation of blk_end_request()?
> If there's no problem, could you merge it to your tree?
> Or does it have to be merged to -mm tree first?

Looks good to me now, I'll queue it up. Thanks!

-- 
Jens Axboe

