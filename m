Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZBDNHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZBDNHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbZBDMzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:55:23 -0500
Received: from brick.kernel.dk ([93.163.65.50]:5555 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbZBDMzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:55:20 -0500
Date: Wed, 4 Feb 2009 13:53:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: Re: [Bug #12591] NULL pointer dereference in blk_queue_io_stat
Message-ID: <20090204125320.GH30821@kernel.dk>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.OKF.BvYiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pWZw1SZjMCH.A.OKF.BvYiJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12591
> Subject		: NULL pointer dereference in blk_queue_io_stat
> Submitter	: Petr Vandrovec <vandrove@vc.cvut.cz>
> Date		: 2009-01-31 23:58 (5 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bc58ba9468d94d62c56ab9b47173583ec140b165
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>

This one is already fixed in -git by commit
fb8ec18c316d869271137c97320dbfd2def56569.

-- 
Jens Axboe

