Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbZHSMUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbZHSMUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZHSMUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:20:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZHSMU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:20:29 -0400
Date: Wed, 19 Aug 2009 14:20:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL][2.6.31] tracing: handle broken names in ftrace
	filter
Message-ID: <20090819122014.GB24041@elte.hu>
References: <20090811152904.GA26065@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.2.00.0908182121470.18648@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908182121470.18648@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Jiri Olsa (1):
>       tracing: handle broken names in ftrace filter
> 
> ----
>  kernel/trace/ftrace.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)

Pulled, thanks Steve!

	Ingo
