Return-Path: <linux-kernel-owner+w=401wt.eu-S1031587AbXD3USj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031587AbXD3USj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031585AbXD3USj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:18:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55480 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031587AbXD3USh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:18:37 -0400
Date: Mon, 30 Apr 2007 22:17:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: 3d smoothness (was: Re: [patch] CFS scheduler, -v6)
Message-ID: <20070430201750.GA30752@elte.hu>
References: <1177809512.9756.10.camel@localhost> <20070429170908.GA31417@elte.hu> <20070429173902.GA4349@elte.hu> <200704301945.34082.lkml@metanurb.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704301945.34082.lkml@metanurb.dk>
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


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> This patch makes things much worse, [...]

yeah, the small patch i sent to you in private mail was indeed buggy,
please disregard it.

	Ingo
