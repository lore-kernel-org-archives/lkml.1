Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZEZVau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZEZVau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZEZVan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:30:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZEZVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:30:42 -0400
Date: Tue, 26 May 2009 17:30:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL v2][PATCH 0/10] tracing/core: various fixes
In-Reply-To: <20090526185524.GB5969@nowhere>
Message-ID: <alpine.DEB.2.00.0905261730180.26705@gandalf.stny.rr.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com> <20090526185524.GB5969@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 26 May 2009, Frederic Weisbecker wrote:
> Steven Rostedt (5):
>       tracing: add __print_flags for events
>       tracing: add previous task state info to sched switch event
>       tracing: add flag output for kmem events
>       tracing: add __print_symbolic to trace events
>       tracing: convert irq events to use __print_symbolic
> 
> Zhaolei (2):
>       ftrace: Add task_comm support for trace_event
>       ftrace: clean up of using ftrace_event_enable_disable()

BTW, these are in tip/tracing/ftrace :-/

-- Steve

