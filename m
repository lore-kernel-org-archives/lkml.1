Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZKDKqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZKDKqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZKDKqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:46:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbZKDKqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:46:51 -0500
Date: Wed, 4 Nov 2009 11:46:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][for v2.6.32] tracing: urgent fixes
Message-ID: <20091104104644.GB13194@elte.hu>
References: <20091104064825.546743711@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104064825.546743711@goodmis.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Lai Jiangshan (1):
>       ring-buffer: Synchronize resizing buffer with reader lock
> 
> Li Zefan (1):
>       ftrace: Fix unmatched locking in ftrace_regex_write()
> 
> ----
>  kernel/trace/ftrace.c      |    6 +++---
>  kernel/trace/ring_buffer.c |    2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
