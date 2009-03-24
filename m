Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZCXLtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZCXLtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZCXLtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:49:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47972 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZCXLtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:49:41 -0400
Date: Tue, 24 Mar 2009 12:49:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] blktrace: various cleanups and fixes, part 2
Message-ID: <20090324114938.GP27476@kernel.dk>
References: <49C893FC.9080905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C893FC.9080905@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24 2009, Li Zefan wrote:
> The first part is here:
> 	http://lkml.org/lkml/2009/3/19/475
> 
> And this is the 2nd part, and I still have some pending fixes..
> 
> Each patch is a small one, except the last one, which is still not big.
> 
> [PATCH 1/5] blktrace: mark ddir_act and what2act const
> [PATCH 2/5] blktrace: fix wrong calculation of RWBS
> [PATCH 3/5] blktrace: fix off-by-one bug
> [PATCH 4/5] blktrace: fix t_error()
> [PATCH 5/5] blktrace: print human-readable act_mask
> 
>  blktrace.c |  127 ++++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 77 insertions(+), 50 deletions(-)
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks good, as does your previous series. You can add my acked-by to
both series.

-- 
Jens Axboe

