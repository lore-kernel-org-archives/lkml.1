Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYJ3Kjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYJ3Kjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYJ3Kjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:39:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbYJ3Kja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:39:30 -0400
Date: Thu, 30 Oct 2008 11:39:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: switch sched_features to seqfile
Message-ID: <20081030103918.GD3569@elte.hu>
References: <490960F4.6050904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490960F4.6050904@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0181]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> So handling of sched_features read is simplified.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |   52 ++++++++++++++++------------------------------------
>  1 files changed, 16 insertions(+), 36 deletions(-)

nice cleanup! Applied to tip/sched/core, thanks,

	Ingo
