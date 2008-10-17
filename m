Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbYJQLBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbYJQLBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYJQLBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:01:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbYJQLBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:01:04 -0400
Date: Fri, 17 Oct 2008 13:00:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Kill unused scheduler decl.
Message-ID: <20081017110053.GA30668@elte.hu>
References: <20081016.211411.221093995.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016.211411.221093995.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0066]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> I noticed this while making investigations into the tbench
> regressions.  Please apply.
> 
> sched: Remove hrtick_resched() extern decl.
> 
> This function was removed by 31656519e132f6612584815f128c83976a9aaaef
> ("sched, x86: clean up hrtick implementation").
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

applied to tip/sched/urgent, thanks David!

	Ingo
