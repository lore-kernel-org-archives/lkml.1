Return-Path: <linux-kernel-owner+w=401wt.eu-S1767112AbXDTOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767112AbXDTOel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767109AbXDTOel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:34:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767112AbXDTOek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:34:40 -0400
Date: Fri, 20 Apr 2007 16:33:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420143356.GA29440@elte.hu>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <4628CC70.8000502@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628CC70.8000502@bigpond.net.au>
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> BTW Given that I'm right and dynamic priorities have been dispensed 
> with what do you intend exporting (in their place) to user space for 
> display by top and similar?

well i thought of only displaying static ones, i.e. like the current 
patch does.

	Ingo
