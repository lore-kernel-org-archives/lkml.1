Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZB1IDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZB1IDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZB1IDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:03:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZB1IDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:03:41 -0500
Date: Sat, 28 Feb 2009 09:03:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][git pull] tracing: replace kzalloc with kcalloc
Message-ID: <20090228080331.GI9351@elte.hu>
References: <alpine.DEB.2.00.0902280233410.2116@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902280233410.2116@gandalf.stny.rr.com>
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
>       tracing: replace kzalloc with kcalloc
> 
> ----
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
