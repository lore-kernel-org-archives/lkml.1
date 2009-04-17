Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZDQGaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZDQGaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZDQG3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:29:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38621 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZDQG3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:29:53 -0400
Date: Fri, 17 Apr 2009 08:29:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #13113] tiobench read 50% regression with 2.6.30-rc1
Message-ID: <20090417062951.GA4593@kernel.dk>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.szH.Pw85JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nY3-4PrO6XH.A.szH.Pw85JB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13113
> Subject		: tiobench read 50% regression with 2.6.30-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2009-04-09 8:29 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=123926576802992&w=4
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123971130800697&w=4

It's fixed by d6ceb25e8d8bccf826848c2621a50d02c0a7f4ae, which is already
merged.

-- 
Jens Axboe

