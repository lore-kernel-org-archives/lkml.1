Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXCYLRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXCYLRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXCYLRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:17:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40608 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXCYLRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:17:15 -0400
Date: Sun, 25 Mar 2007 13:16:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070325111602.GB16988@elte.hu>
References: <20070323185028.GR752@stusta.de> <1174679344.10840.334.camel@localhost.localdomain> <20070325071023.GL17532@mellanox.co.il> <1174808247.10840.467.camel@localhost.localdomain> <20070325085705.GB24225@mellanox.co.il> <1174817872.10840.478.camel@localhost.localdomain> <20070325101548.GI24225@mellanox.co.il> <1174818459.10840.481.camel@localhost.localdomain> <20070325102543.GK24225@mellanox.co.il> <1174819103.10840.484.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174819103.10840.484.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > Sorry, now I'm confused.
> > Could you pls list the full set of tests you want me to run,
> > and what information to collect from each of them?
> 
> 1. Test:

I suspect step 0 would be use Linus' latest tree, ontop of -rc4:

 http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-rc4-git11.bz2

to make sure all post-rc4 time fixes are included.

	Ingo
