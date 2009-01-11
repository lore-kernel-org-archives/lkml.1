Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZAKMLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZAKMLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZAKMKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:10:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53913 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZAKMKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:10:53 -0500
Date: Sun, 11 Jan 2009 13:10:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] request for tip/cpus4096
Message-ID: <20090111121043.GD27796@elte.hu>
References: <4969922B.5050807@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4969922B.5050807@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4844]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Hi Ingo,
> 
> This is a combined "pull request" of both the 1/8/09 pull request for
> 'merge-0108' changes for cpumasks, as well as the variable irq patches
> for setting nr_irqs based on nr_cpu_ids.
> 
> Tested on both SPARSE_IRQS/!SPARSE_IRQS and LARGE/SMALL NR_CPUS.
> 
> Thanks,
> Mike
> ---
> 
> The following changes since commit 36c401a44abcc389a00f9cd14892c9cf9bf0780d:
>   Ingo Molnar (1):
>         [IA64] fix typo in cpumask_of_pcibus()
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Pulled into tip/cpus4096, thanks Mike!

	Ingo
