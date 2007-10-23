Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXJWHNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXJWHNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJWHNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:13:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbXJWHNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:13:15 -0400
Date: Tue, 23 Oct 2007 09:11:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: build fix
Message-ID: <20071023071150.GC25962@kernel.dk>
References: <20071023153536K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023153536K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> arch/arm/common/dmabounce.c: In function 'dma_map_sg':
> arch/arm/common/dmabounce.c:445: error: implicit declaration of function 'sg_page'

Thanks, applied.

-- 
Jens Axboe

