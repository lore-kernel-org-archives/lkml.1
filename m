Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZHQH5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZHQH5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZHQH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:57:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZHQH5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:57:44 -0400
Date: Mon, 17 Aug 2009 09:57:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090817075739.GB15390@elte.hu>
References: <20090729112509.GN4148@kernel.dk> <20090802.131705.81498579.davem@davemloft.net> <20090806070242.GF12579@kernel.dk> <20090816.183134.90977928.davem@davemloft.net> <20090817064851.GQ12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817064851.GQ12579@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Sun, Aug 16 2009, David Miller wrote:
>
> > > I'm assuming that this will happen automatically at some point, instead
> > > of perf defaulting to building with the same 32/64-bit of the kernel.
> > 
> > Right, it looks like Ingo and co. are going to take care of that.
> 
> It's already much better, I can just type make and it'll work. 
> Still builds 64-bit, but at least it only requires zlib and elf 
> which I already got fixed.

Yes, those fixes/enhancements are already in -rc6 so if you base it 
on that or later kernels it should be fine out of box.

	Ingo
