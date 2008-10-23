Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYJWQww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYJWQww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYJWQwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35155 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYJWQwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:52:43 -0400
Date: Thu, 23 Oct 2008 18:52:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with
	struct cpumask
Message-ID: <20081023165218.GA25697@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu> <200810240201.15037.rusty@rustcorp.com.au> <20081023160610.GA8853@elte.hu> <4900A3C6.1080000@sgi.com> <20081023163508.GA15921@elte.hu> <4900AB49.9040404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4900AB49.9040404@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0058]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> git-checkout -b cpus4096-v2 tip/cpus4096-v2
> git checkout: updating paths is incompatible with switching branches/forcing
> Did you intend to checkout 'tip/cpus4906-v2' which can not be resolved as commit?

see the typo in the error message?

> 
> or:
> 
> git-checkout tip/cpus4906-v2
> error: pathspec 'tip/cpus4906-v2' did not match any file(s) known to git.
> Did you forget to 'git add'?

the 4906/4096 typo in shown in this error message as well.

	Ingo
