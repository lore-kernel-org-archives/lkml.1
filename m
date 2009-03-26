Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZCZKCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZCZKCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCZKCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:02:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZCZKCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:02:01 -0400
Date: Thu, 26 Mar 2009 11:01:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH][GIT PULL] ftrace: Using FTRACE_WARN_ON() to check
	"freed record" in ftrace_release()
Message-ID: <20090326100137.GE19826@elte.hu>
References: <alpine.DEB.2.00.0903251903260.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251903260.5675@gandalf.stny.rr.com>
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
> Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-1
> 
> 
> Zhaolei (1):
>       ftrace: Using FTRACE_WARN_ON() to check "freed record" in ftrace_release()
> 
> ----
>  kernel/trace/ftrace.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)

pulled, thanks!

	Ingo
