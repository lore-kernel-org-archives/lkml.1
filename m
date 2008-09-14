Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYINNR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYINNR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYINNRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:17:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34415 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYINNRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:17:47 -0400
Date: Sun, 14 Sep 2008 15:17:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: agk@redhat.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, stefan.bader@canonical.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 00/13] request-based dm-multipath
Message-ID: <20080914131743.GN20055@kernel.dk>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12 2008, Kiyoshi Ueda wrote:
> Hi Jens, James and Alasdair,
> 
> This is a new version of request-based dm-multipath patches.
> The patches are created on top of 2.6.27-rc6 + Alasdair's dm patches
> for linux-next below:
>     dm-mpath-use-more-error-codes.patch
>     dm-mpath-remove-is_active-from-struct-dm_path.patch

You have to base the block patches off the for-2.6.28 branch of the
block git repo, otherwise I cannot merge the block bits.

-- 
Jens Axboe

