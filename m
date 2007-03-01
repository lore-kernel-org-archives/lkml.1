Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbXCAJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbXCAJmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbXCAJmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:42:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933234AbXCAJmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:42:44 -0500
Date: Thu, 1 Mar 2007 10:34:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070301093450.GA8508@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227111515.GA4271@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 works for me, [...]

update: f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 works for me too, and 
01363220f5d23ef68276db8974e46a502e43d01d is broken. I too will attempt 
to bisect this.

	Ingo
