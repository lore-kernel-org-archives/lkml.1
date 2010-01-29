Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421Ab0A2HNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0A2HNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298Ab0A2HNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:13:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab0A2HNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:13:33 -0500
Date: Fri, 29 Jan 2010 08:13:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>
Subject: Re: [GIT PULL] hw_breakpoint fix
Message-ID: <20100129071323.GD14636@elte.hu>
References: <1264689172-9077-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264689172-9077-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> Thanks,
> 	Frederic
> ---
> 
> Mahesh Salgaonkar (1):
>       hw_breakpoints: Release the bp slot if arch_validate_hwbkpt_settings() fails.
> 
> 
>  kernel/hw_breakpoint.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Pulled, thanks Frederic!

	Ingo
