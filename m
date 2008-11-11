Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYKKMx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYKKMx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbYKKMxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:53:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbYKKMxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:53:49 -0500
Date: Tue, 11 Nov 2008 13:53:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: sched: removed unneeded defintion
Message-ID: <20081111125330.GA14989@elte.hu>
References: <20081111124323.GA4684@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111124323.GA4684@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0042]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> sched: removed unneeded defintion
> 
> This function no longer exists, so remove the defintion.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> ---
>  include/linux/sched.h |    2 --
>  1 file changed, 2 deletions(-)

applied to tip/sched/rt, thanks Dhaval!

	Ingo
