Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbZG3NAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbZG3NAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZG3NAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:00:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZG3NAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:00:44 -0400
Date: Thu, 30 Jul 2009 09:00:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing: Various cleanups for 2.6.32
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0907300900120.24297@gandalf.stny.rr.com>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Jul 2009, Frederic Weisbecker wrote:

> Hi Thomas, Ingo,
> 
> These patches are the result of various cleanups in the tracing
> subsystem: algorithms simpifications, and various trace.c to tracer
> files moving.
> 
> Thanks,
> Frederic.
> 
> The following changes since commit d34a4debef933061924ee17c2ede33f5c44925fb:
>   jolsa@redhat.com (1):
>         tracing: Remove .globl in the scripts/recordmcount.pl doc
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core
> 
> Frederic Weisbecker (5):
>       tracing/function-graph-tracer: Drop the useless nmi protection
>       tracing/function-tracer: Move trace_function() in the function tracer file
>       tracing/core: Make the stack entry helpers global
>       tracing: Move sched event insertion helpers in the sched switch tracer file
>       tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
> 
> Lai Jiangshan (1):
>       tracing: Simplify print_graph_cpu()

Very nice cleanups.

Thanks guys!

-- Steve
