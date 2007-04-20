Return-Path: <linux-kernel-owner+w=401wt.eu-S1422751AbXDTFYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422751AbXDTFYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXDTFYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:24:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:49766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422751AbXDTFYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:24:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6zZc1OCP6uQMKt6aHU6oDQ/hnENsXrqCrv1Egry
	aoHhUY16Vt+iHV
Subject: Re: Renice X for cpu schedulers
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200704200847.30516.kernel@kolivas.org>
References: <20070417062621.GL2986@holomorphy.com>
	 <200704192159.35546.kernel@kolivas.org>
	 <200704191416.14374.gene.heskett@gmail.com>
	 <200704200847.30516.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 07:24:34 +0200
Message-Id: <1177046674.6309.81.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 08:47 +1000, Con Kolivas wrote:

> It's those who want X to have an unfair advantage that want it to do 
> something "special".

I hope you're not lumping me in with "those".  If X + client had been
able to get their fair share and do so in the low latency manner they
need, I would have been one of the carrots instead of being the stick.

	-Mike

