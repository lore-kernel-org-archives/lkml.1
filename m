Return-Path: <linux-kernel-owner+w=401wt.eu-S968248AbXG3TLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968248AbXG3TLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967879AbXG3TKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:10:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967990AbXG3TKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:10:49 -0400
Date: Mon, 30 Jul 2007 21:10:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kenneth Prugh <ken69267@gmail.com>
Cc: John <darknessenvelops@gmail.com>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070730191029.GA29327@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE25F3.7020904@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kenneth Prugh <ken69267@gmail.com> wrote:

> Ingo Molnar wrote:
> > <large snip>
> 
> Hello, I have a gaming rig and would love to help benchmark with my 
> copy of UT2004(E6600 Core2 and a 7950GTO card). Or if you have 
> anything else that would better serve as a benchmark I could grab it 
> and try.
> 
> The only problem is I don't know what 2 kernels I should be using to 
> test the schedulers. I assume 2.6.23-rc1 for CFS, but what about SD?

.22-ck1 includes it, so that should be fine:

 http://ussg.iu.edu/hypermail/linux/kernel/0707.1/0318.html

	Ingo
