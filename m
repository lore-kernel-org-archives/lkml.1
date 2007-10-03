Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbXJCJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbXJCJgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXJCJgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:36:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbXJCJf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:35:59 -0400
Date: Wed, 3 Oct 2007 11:35:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] lockstat: documentation
Message-ID: <20071003093544.GB22558@elte.hu>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <20070927235034.ae7bd73d.akpm@linux-foundation.org> <1190998853.6702.17.camel@heimdal.trondhjem.org> <20070928114930.2c201324.akpm@linux-foundation.org> <1191005339.18147.89.camel@lappy> <20070928121642.56a380ce.akpm@linux-foundation.org> <1191332161.13204.70.camel@twins> <20071002084239.7371820c.randy.dunlap@oracle.com> <1191403688.5572.3.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191403688.5572.3.camel@lappy>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Thanks Randy!
> 
> update patch below.
> 
> ---
> Subject: lockstat: documentation
> 
> Provide some documentation for CONFIG_LOCK_STAT
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
