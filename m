Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYGRJ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYGRJ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYGRJ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:56:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYGRJ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:56:15 -0400
Date: Fri, 18 Jul 2008 11:56:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] sched: Reduce stack size in isolated_cpu_setup()
Message-ID: <20080718095600.GT6875@elte.hu>
References: <486A6A42.5050606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A6A42.5050606@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0417]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Subject: sched: Reduce stack size in isolated_cpu_setup()
> 
>   * Remove 16k stack requirements in isolated_cpu_setup when NR_CPUS=4096.
> 
> (Somehow this patch was misplaced from some months back.)
> 
> Based on linux-2.6.tip/master

applied to tip/sched/urgent - thanks Mike.

	Ingo
