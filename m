Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbZE0XtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbZE0XtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbZE0XtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:49:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415AbZE0XtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:49:12 -0400
Date: Thu, 28 May 2009 01:49:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] tracing/core: another fixes
Message-ID: <20090527234902.GA26820@elte.hu>
References: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> Here are two another fixes for ftrace, on top of tracing/core.
> 
> Thanks,
> Frederic.
> 
> The following changes since commit c2adae0970ca1db8adb92fb56ae3bcabd916e8bd:
>   Steven Rostedt (1):
>         tracing: convert irq events to use __print_symbolic
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core
> 
> Heiko Carstens (1):
>       trace: disable preemption before taking raw spinlocks
> 
> Zhaolei (1):
>       ftrace: don't convert function's local variable name in macro
> 
>  include/trace/ftrace.h |   20 ++++++++++----------
>  kernel/trace/trace.c   |    2 ++
>  2 files changed, 12 insertions(+), 10 deletions(-)

Pulled, thanks Frederic!

	Ingo
