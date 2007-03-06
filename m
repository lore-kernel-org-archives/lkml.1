Return-Path: <linux-kernel-owner+w=401wt.eu-S965959AbXCFRHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbXCFRHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965960AbXCFRHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:07:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51637 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965959AbXCFRHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:07:06 -0500
Date: Tue, 6 Mar 2007 18:05:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306170504.GA14311@elte.hu>
References: <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu> <20070306104618.GA5792@mellanox.co.il> <20070306113225.GA22561@elte.hu> <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> This is just a coding style thing, but I thought I should really point 
> it out, because these kinds of things quite often result in nasty bugs 
> simply because the source code is so hard to read properly:

yeah, agreed. We'll fix this.

	Ingo
