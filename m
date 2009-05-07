Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZEGRiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZEGRiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZEGRiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:38:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52342 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZEGRiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:38:14 -0400
Date: Thu, 7 May 2009 19:38:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/ring-buffer: updates to tip
Message-ID: <20090507173801.GF10313@elte.hu>
References: <20090507162221.413243886@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507162221.413243886@goodmis.org>
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
> Steven Rostedt (2):
>       ring-buffer: remove complex calculations in ring-buffer-test
>       tracing: append ":*" to internal setting of system events
> 
> ----
>  kernel/trace/ring_buffer_benchmark.c |   37 ++++++---------------------------
>  kernel/trace/trace_events.c          |    6 +++-
>  2 files changed, 11 insertions(+), 32 deletions(-)

Pulled, thanks Steve!

	Ingo
