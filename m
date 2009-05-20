Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZETSP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZETSP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZETSPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:15:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZETSPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:15:49 -0400
Date: Wed, 20 May 2009 20:15:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: fix check for return value of
	register_module_notifier in event_trace_init
Message-ID: <20090520181536.GA17031@elte.hu>
References: <20090520172559.GA5973@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520172559.GA5973@nowhere>
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

> Hi Ingo,
> 
> Here is a fixlet from Ming Lei which fixes a spurious warning.
> 
> Thanks.
> 
> 
> The following changes since commit fd51d251e4cdb21f68e9dbc4336514d64a105a79:
>   Stefan Raspl (1):
>         blktrace: remove debugfs entries on bad path
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Ming Lei (1):
>       ftrace: fix check for return value of register_module_notifier in event_trace_init
> 
>  kernel/trace/trace_events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks!

	Ingo
