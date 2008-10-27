Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbYJ0Rt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbYJ0Rt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJ0Rtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:49:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYJ0Rtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:49:50 -0400
Date: Mon, 27 Oct 2008 18:49:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix documentation reference for
	sched_min_granularity_ns
Message-ID: <20081027174938.GB3046@elte.hu>
References: <alpine.LNX.1.10.0810271739330.12928@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810271739330.12928@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1156]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> sched-design-CFS.txt wrongly references sched_granularity_ns sysctl,
> as its name in fact is sched_min_granularity_ns.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  Documentation/scheduler/sched-design-CFS.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/sched/urgent, thanks Jiri!

	Ingo
