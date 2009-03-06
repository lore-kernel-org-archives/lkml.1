Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZCFLTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZCFLTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZCFLTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:19:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45957 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbZCFLTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:19:15 -0500
Date: Fri, 6 Mar 2009 12:18:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][GIT PULL] add tracing_on/tracing_off to kernel.h
Message-ID: <20090306111856.GJ21168@elte.hu>
References: <alpine.DEB.2.00.0903051120110.26101@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903051120110.26101@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (1):
>       tracing: add tracing_on/tracing_off to kernel.h
> 
> ----
>  include/linux/kernel.h      |   29 ++++++++++++++++++++++++++++-
>  include/linux/ring_buffer.h |   15 ---------------
>  2 files changed, 28 insertions(+), 16 deletions(-)

Pulled, thanks Steve!

	Ingo
