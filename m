Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZIUQdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZIUQdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZIUQdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:33:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZIUQdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:33:49 -0400
Date: Mon, 21 Sep 2009 18:33:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [GIT PULL] "Performance Counters" -> "Performance
	Events" rename
Message-ID: <20090921163332.GA11296@elte.hu>
References: <20090921134111.GA25578@elte.hu> <alpine.LFD.2.01.0909210928570.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909210928570.4950@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 21 Sep 2009, Ingo Molnar wrote:
> > 
> > Please consider pulling the following tree (which is relative to the 
> > perfcounters-fixes-for-linus pull request i just sent) that renames 
> > "performance counters" to "performance events":
> 
> Fine, pulled. But it conflicted with the tracers tree. I fixed it up, 
> but somebody more well-versed in the code should double-check.

Will do, thanks!

	Ingo
