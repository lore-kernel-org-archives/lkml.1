Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXD2IBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXD2IBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXD2IBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:01:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbXD2IBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:01:22 -0400
Date: Sun, 29 Apr 2007 10:00:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429080028.GA9988@elte.hu>
References: <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429073030.GA5253@elte.hu> <20070429073819.GD23638@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429073819.GD23638@1wt.eu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> > > [...] except for Mike who has not tested recent versions. [...]
> > 
> > actually, dont discount Mark Lord's test results either. And it 
> > might be a good idea for Mike to re-test SD 0.46?
> 
> In any case, it might be a good idea because Mike encountered a 
> problem that nobody could reproduce. [...]

actually, Mark Lord too reproduced something similar to Mike's results. 
Please try those workloads yourself.

	Ingo
