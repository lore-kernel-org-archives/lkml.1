Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZDTP6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZDTP6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZDTP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:57:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZDTP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:57:50 -0400
Date: Mon, 20 Apr 2009 17:57:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: config updates
Message-ID: <20090420155735.GA9689@elte.hu>
References: <20090420154325.698204138@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420154325.698204138@goodmis.org>
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
> Steven Rostedt (3):
>       tracing: change branch profiling to a choice selection
>       tracing: create menuconfig for tracing infrastructure
>       tracing: rename EVENT_TRACER config to ENABLE_EVENT_TRACING
> 
> ----
>  kernel/trace/Kconfig |   54 +++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 45 insertions(+), 9 deletions(-)

Pulled, thanks Steve!

	Ingo
