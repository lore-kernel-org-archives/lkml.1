Return-Path: <linux-kernel-owner+w=401wt.eu-S1763043AbXKTX2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763043AbXKTX2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760543AbXKTX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:27:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762708AbXKTX1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:27:46 -0500
Date: Wed, 21 Nov 2007 00:27:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120232723.GB23667@elte.hu>
References: <47425EA5.7000607@rtr.ca> <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47436C43.6010200@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <lkml@rtr.ca> wrote:

> Perhaps, but this also violates the principle that the kernel should 
> just *work* with sensible defaults.  I don't use an initrd, or an 
> initramfs, and have no intention of ever doing so.

nor do i - i was under the impression that klibc was able to work out of 
a bzImage too? Am i wrong?

	Ingo
