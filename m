Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbXKTUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbXKTUlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbXKTUlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:41:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761012AbXKTUlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:41:15 -0500
Date: Tue, 20 Nov 2007 21:41:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071120204103.GC10008@elte.hu>
References: <20071119151756.GA25446@elte.hu> <b637ec0b0711201238i746ca9bala3812ca93479c6fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0711201238i746ca9bala3812ca93479c6fa@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Fabio Comolli <fabio.comolli@gmail.com> wrote:

> Hi.
> First, thanks for this patch. I don't have numbers but working with my
> laptop feels much better.

curious: what scheduler/kernel version have you used before?

> Just a question: does the patch include the fix (divide by zero....) 
> you just posted in the stable review for 2.6.23.9?

yeah.

	Ingo
