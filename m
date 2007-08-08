Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbXHHLG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbXHHLG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXHHLGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:06:22 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26713 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXHHLGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:06:21 -0400
Date: Wed, 8 Aug 2007 13:06:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: saeed bishara <saeed.bishara@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use sg helper function in DMA mapping documentation
Message-ID: <20070808110616.GP5245@kernel.dk>
References: <c70ff3ad0708080359m1dae4fbes6955d38b1da51323@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c70ff3ad0708080359m1dae4fbes6955d38b1da51323@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08 2007, saeed bishara wrote:
> Signed-off-by: Saeed Bishara <saeed.bishara@gmail.com>
> ---
>  DMA-mapping.txt |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)

Good catch, will add that to the sglist branch. Thanks!

-- 
Jens Axboe

