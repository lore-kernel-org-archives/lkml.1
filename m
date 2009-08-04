Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbZHDQYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbZHDQYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZHDQYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:24:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931AbZHDQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:24:51 -0400
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
 analyze tracing from core-file (make tracing can act as a flight recorder)
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Anderson <anderson@redhat.com>,
       crash-utility@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A77DA98.6050509@cn.fujitsu.com>
References: <4A76F8A1.30503@cn.fujitsu.com>
	 <1249314136.7924.126.camel@twins>  <4A77DA98.6050509@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 04 Aug 2009 12:23:26 -0400
Message-Id: <1249403006.4634.138.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ been away for a bit, so I'm catching up on email ]

On Tue, 2009-08-04 at 14:52 +0800, Lai Jiangshan wrote:
> he "print fmt"'s address is saved in struct ftrace_event_call.
> 
> [
> http://lkml.org/lkml/2009/7/30/30
> 
> This patch is really useful for kernel. We don't change the kernel
> even a single line for the purpose of we can read the core-file easier.
> 
> This patch is also helpful for crash more or less. So I mention it.
> ]

This format patch will soon be in (if not already) with some updates.

-- Steve


