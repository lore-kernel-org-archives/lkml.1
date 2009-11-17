Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZKQRTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZKQRTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZKQRTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:19:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbZKQRTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:19:50 -0500
Date: Tue, 17 Nov 2009 18:19:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: various fixes
Message-ID: <20091117171944.GA5967@elte.hu>
References: <20091117171242.761539651@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117171242.761539651@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This is based on top of tip/tracing/core.
> 
> Please pull the latest tip/tracing/core-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core-1
> 
> 
> Lai Jiangshan (1):
>       tracing: Prevent build warning: 'ftrace_graph_buf' defined but not used
> 
> Steven Rostedt (2):
>       ring-buffer: Move access to commit_page up into function used
>       tracing: Only print objcopy version warning once from recordmcount
> 
> ----
>  Makefile                   |    1 +
>  kernel/trace/ftrace.c      |    2 +-
>  kernel/trace/ring_buffer.c |    9 +++------
>  scripts/recordmcount.pl    |   12 ++++++++++--
>  4 files changed, 15 insertions(+), 9 deletions(-)

Pulled into tip:tracing/core, thanks Steve!

	Ingo
