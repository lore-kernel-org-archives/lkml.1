Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZCVMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZCVMyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZCVMx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:53:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZCVMx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:53:59 -0400
Date: Sun, 22 Mar 2009 13:53:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090322125320.GA14171@elte.hu>
References: <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321214852.GA5262@redhat.com> <20090322120811.GD19826@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322120811.GD19826@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  Total download size: 329 M
> 
> That size of a _compressed_ debuginfo kernel package is obscene. 
> We can fit 4 years of full Linux kernel Git history into that size 
> - 60,000+ commits, full metadata and full 20 million lines of code 
> flux included!
> 
> Uncompressed it blows up to gigabytes of on-disk data.
> 
> And this download has to be repeated for _every_ minor kernel 
> upgrade.

Have to correct my memories about how many commits the kernel repo 
has: 132,019 commits. That massive history fits into 298 MB. (!)

	Ingo
