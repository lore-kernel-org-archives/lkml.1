Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXD2P7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXD2P7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXD2P7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:59:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45561 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334AbXD2P7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:59:33 -0400
Date: Sun, 29 Apr 2007 17:58:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       buddabrod <buddabrod@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070429155828.GA15089@elte.hu>
References: <20070428152539.GA21601@elte.hu> <200704290242.43741.caglar@pardus.org.tr> <20070429071117.GA3612@elte.hu> <200704291537.34748.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704291537.34748.caglar@pardus.org.tr>
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> I'll report if i can find any reproducable problem, so far CFSv7 works 
> as expected :)

ok :)

	Ingo
