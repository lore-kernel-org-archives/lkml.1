Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYEGKkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYEGKkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYEGKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 06:40:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYEGKke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 06:40:34 -0400
Date: Wed, 7 May 2008 12:40:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
Message-ID: <20080507104020.GA26305@elte.hu>
References: <1210136148.3453.59.camel@ymzhang> <20080507091611.GA30645@elte.hu> <1210152792.3453.84.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210152792.3453.84.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > thanks Yanmin, i've queued up your reverter patch.
>
> Sorry. The reverting patch has a comment-out block. I need delete it 
> if you queue the patch officially.

yep, i noticed that and skipped that bit already.

	Ingo
