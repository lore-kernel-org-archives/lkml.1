Return-Path: <linux-kernel-owner+w=401wt.eu-S934141AbZLFSUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbZLFSUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934064AbZLFSUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:20:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934035AbZLFSUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:20:02 -0500
Date: Sun, 6 Dec 2009 19:19:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [patch 04/23] locking: Convert raw_spinlock to arch_spinlock
Message-ID: <20091206181954.GA11753@elte.hu>
References: <20091206110944.492100233@linutronix.de>
 <20091206111957.454670287@linutronix.de>
 <alpine.LFD.2.00.0912061004580.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912061004580.3560@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I like it, but maybe the arch people hate it?

I like it too - but i'm even more biased i guess ;-)

	Ingo
