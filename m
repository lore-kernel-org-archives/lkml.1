Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZJLGVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZJLGVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZJLGVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:21:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56132 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZJLGVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:21:10 -0400
Date: Mon, 12 Oct 2009 08:20:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-settings: fix function parameter kernel-doc
	notation
Message-ID: <20091012062033.GV9228@kernel.dk>
References: <4AD28E10.3010502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD28E10.3010502@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc notation in blk-settings.c::blk_queue_max_discard_sectors().
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  block/blk-settings.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied.

-- 
Jens Axboe

