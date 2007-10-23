Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXJWHbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXJWHbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXJWHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:31:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12616 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXJWHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:31:30 -0400
Date: Tue, 23 Oct 2007 09:30:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] ide: build fix
Message-ID: <20071023073005.GK25962@kernel.dk>
References: <20071023152506I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023152506I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> git-drivers/ide/ide-probe.c: In function 'hwif_init':
> drivers/ide/ide-probe.c:1327: error: implicit declaration of function 'sg_init_table'
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Applied!

-- 
Jens Axboe

