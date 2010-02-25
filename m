Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab0BYHcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:32:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab0BYHcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:32:46 -0500
Date: Thu, 25 Feb 2010 08:32:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Perf python scripting support
Message-ID: <20100225073229.GB2517@elte.hu>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> I've left out the parts that deal with syscall nr to name
> resolution as it would be nicer to implement it through events
> injection instead of yet another debugfs file.
> 
> The reason I've made a separate patch to tag syscall_name()
> helper as unavailable yet is that it makes it easily
> revertable later, once it gets supported.
> 
> I've tested the whole and it works very well.

Pulled, thanks a lot!

	Ingo
