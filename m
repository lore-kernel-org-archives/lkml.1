Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbZL3HjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbZL3HjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 02:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZL3HjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 02:39:20 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48136 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZL3HjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 02:39:19 -0500
Date: Wed, 30 Dec 2009 08:39:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: blk_rq_err_sectors cleanup
Message-ID: <20091230073918.GT4489@kernel.dk>
References: <4B3AC945.3090304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3AC945.3090304@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Gui Jianfeng wrote:
> blk_rq_err_sectors() seems useless, get rid of it.

Indeed, it's currently unused. Applied.

-- 
Jens Axboe

