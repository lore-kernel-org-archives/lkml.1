Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYJNGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYJNGue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYJNGuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:50:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39989 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYJNGuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:50:23 -0400
Date: Tue, 14 Oct 2008 08:49:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix kernel-doc for blk_alloc_devt()
Message-ID: <20081014064941.GM19428@kernel.dk>
References: <48F43D64.8000806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F43D64.8000806@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14 2008, Li Zefan wrote:
> No argument 'gfp_mask' for blk_alloc_devt().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  block/genhd.c |    1 -

Applied, thanks

-- 
Jens Axboe

