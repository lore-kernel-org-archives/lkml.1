Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbZLRLfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbZLRLfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbZLRLfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:35:47 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34848 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZLRLfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:35:46 -0500
Date: Fri, 18 Dec 2009 12:35:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove Documentation/block/as-iosched.txt
Message-ID: <20091218113544.GO4489@kernel.dk>
References: <20091218192457G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218192457G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18 2009, FUJITA Tomonori wrote:
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  Documentation/block/00-INDEX       |    2 -
>  Documentation/block/as-iosched.txt |  172 ------------------------------------

Thanks, that should have been part of the AS removal. Queued up!

-- 
Jens Axboe

