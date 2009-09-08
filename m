Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbZIHTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbZIHTzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZIHTzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:55:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42730 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZIHTzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:55:42 -0400
Date: Tue, 8 Sep 2009 21:55:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] [mmotm] trace bio queueing trial only when it occurs
Message-ID: <20090908195545.GE18599@kernel.dk>
References: <20090908164941.c4f51208.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908164941.c4f51208.minchan.kim@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Minchan Kim wrote:
> 
>  * Add history that why it is breaked in changelog.
> 
> Thanks for careful review, Wu, Li.

Applied to for-2.6.32.

-- 
Jens Axboe

