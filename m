Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbYELHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbYELHjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELHiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:38:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014AbYELHiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:38:51 -0400
Date: Mon, 12 May 2008 09:38:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
Message-ID: <20080512073832.GA26074@elte.hu>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.GmH.Jw1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88YBFoyd1CN.A.GmH.Jw1JIB@chimera>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
> Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-05-07 4:55 (5 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121013681527052&amp;w=2
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616802&amp;w=2

this entry should still be listed, revert is queued up.

	Ingo
