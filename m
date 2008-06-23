Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYFWLcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYFWLcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYFWLcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:32:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYFWLcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:32:23 -0400
Date: Mon, 23 Jun 2008 13:32:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Holmes <david.holmes@sun.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch] futex: fix fault handling in futex_lock_pi
Message-ID: <20080623113207.GA23713@elte.hu>
References: <20080623092216.380067035@linutronix.de> <alpine.LFD.1.10.0806231238160.3395@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806231238160.3395@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0058]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 23 Jun 2008, Thomas Gleixner wrote:
> 
> Ingo asked about more information about the BUG. Find below the same 
> patch with an updated commit log.

applied to tip/core/futexes and cherry-picked it into tip/core/urgent as 
well - thanks Thomas.

	Ingo
