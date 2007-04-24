Return-Path: <linux-kernel-owner+w=401wt.eu-S1161466AbXDXHdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161466AbXDXHdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161687AbXDXHdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:33:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161466AbXDXHdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:33:46 -0400
Date: Tue, 24 Apr 2007 09:33:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070424073305.GA29787@elte.hu>
References: <200704220959.34978.kernel@kolivas.org> <462DA1E8.9080201@bigpond.net.au> <20070424063633.GA17257@elte.hu> <200704240300.07689.gene.heskett@gmail.com> <20070424070800.GA23463@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424070800.GA23463@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] That way you'd only have had to hit SysRq-N to get the system 
> out of the wedge.)

small correction: Alt-SysRq-N.

	Ingo
