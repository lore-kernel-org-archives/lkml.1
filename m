Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZAKDG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZAKDG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZAKDGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:06:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZAKDGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:06:50 -0500
Date: Sun, 11 Jan 2009 04:06:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/3] ftrace: updates for 2.6.29
Message-ID: <20090111030641.GJ7077@elte.hu>
References: <20090109002747.240318148@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109002747.240318148@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Pekka Paalanen (3):
>       doc: mmiotrace.txt, buffer size control change
>       trace: mmiotrace to the tracer menu in Kconfig
>       mmiotrace: count events lost due to not recording
> 
> ----
>  Documentation/tracers/mmiotrace.txt |    6 ++----
>  arch/x86/Kconfig.debug              |   24 ++----------------------
>  kernel/trace/Kconfig                |   23 +++++++++++++++++++++++
>  kernel/trace/trace_mmiotrace.c      |   14 ++++++++++----
>  4 files changed, 37 insertions(+), 30 deletions(-)

pulled into tip/tracing/urgent, thanks Steve!

	Ingo
