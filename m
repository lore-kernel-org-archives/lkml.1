Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYIRQZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYIRQZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYIRQZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:25:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41420 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbYIRQZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:25:35 -0400
Date: Thu, 18 Sep 2008 18:25:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 0/3] block changes for request-based dm-multipath
Message-ID: <20080918162505.GL20055@kernel.dk>
References: <20080918.104356.74754407.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918.104356.74754407.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18 2008, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> The following patches are changes of the block layer for
> request-based dm-multipath.
> The patches are created on the following commit of for-2.6.28
> in linux-2.6-block.

Thank you, I've merged these three patches.

-- 
Jens Axboe

