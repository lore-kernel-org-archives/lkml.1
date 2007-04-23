Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbXDWWsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbXDWWsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbXDWWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:48:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbXDWWsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:48:09 -0400
Date: Tue, 24 Apr 2007 00:47:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v4
Message-ID: <20070423224736.GA24772@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704221030.24168.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704221030.24168.mgd@technosis.de>
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


* Michael Gerdau <mgd@technosis.de> wrote:

> > i'm pleased to announce release -v4 of the CFS patchset. The patch 
> > against v2.6.21-rc7 can be downloaded from:
> > 
> >     http://redhat.com/~mingo/cfs-scheduler/
> 
> I can't get 2.6.21-rc7-CFS-v4 to boot. Immediately after selecting 
> this kernel I see a very fast scrolling (loop?) sequence of addrs 
> which I don't know how to stop to write them down. They don't appear 
> in any kernel log either. However I see two Tux at the top of the 
> screen.

could you try -v5? It has at least one such bug fixed. (If it still 
happens then please try to make a digital picture of the screen and send 
the picture to me.)

	Ingo
