Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYIKHky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYIKHky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYIKHkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:40:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYIKHkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:40:45 -0400
Date: Thu, 11 Sep 2008 09:40:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: ronne@list.ru, rml@tech9.net, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: deadlock in setting schedule parameters
Message-ID: <20080911074032.GC12087@elte.hu>
References: <48C838F9.1050607@list.ru> <48C85F93.9020602@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C85F93.9020602@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0985]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Subject: [PATCH] sched: do not allow sysctl_sched_rt_period=0
> 
> sysctl_sched_rt_period=0 makes exception at to_ratio().
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

applied to tip/sched/urgent, thanks Hiroshi.

	Ingo
