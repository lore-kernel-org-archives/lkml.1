Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZCCPCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZCCPCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZCCPCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:02:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbZCCPCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:02:23 -0500
Date: Tue, 3 Mar 2009 16:02:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@goodmis.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] fix for tip/tracing/ftrace
Message-ID: <20090303150207.GA21686@elte.hu>
References: <alpine.DEB.2.00.0903030954001.24890@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903030954001.24890@gandalf.stny.rr.com>
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

> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (1):
>       tracing: fix return value to registering events
> 
> ----
>  kernel/trace/trace_events_stage_3.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

Pulled, thanks Steve!

	Ingo
