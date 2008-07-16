Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYGPIvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYGPIvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYGPIvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:51:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:43053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYGPIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:51:35 -0400
Subject: Re: [patch 00/17] Tracepoints v4 for linux-next
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20080715222604.331269462@polymtl.ca>
References: <20080715222604.331269462@polymtl.ca>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 10:51:56 +0200
Message-Id: <1216198316.5232.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> Here is the newest release of the Tracepoints, following the feedback from Peter
> Zijlstra. The main change is the creation of include/trace/ as a placeholder
> from tracepoint headers.
> 
> The patchset applies over linux-next patch-v2.6.26-next-20080715 in this order :
> 
> #This a separate RCU update upon which the tracepoints depend
> rcu-read-sched.patch

ACK

> tracepoints.patch
> tracepoints-documentation.patch
> tracepoints-samples.patch

3x ACK

> lttng-instrumentation-irq.patch
> lttng-instrumentation-scheduler.patch
> lttng-instrumentation-timer.patch
> lttng-instrumentation-kernel.patch
> 
> lttng-instrumentation-filemap.patch
> lttng-instrumentation-swap.patch
> lttng-instrumentation-memory.patch
> lttng-instrumentation-page.patch
> lttng-instrumentation-hugetlb.patch
> 
> lttng-instrumentation-net.patch
> lttng-instrumentation-ipv4.patch
> lttng-instrumentation-ipv6.patch

posted individual comments where I saw some

> ftrace-port-to-tracepoints.patch

Nice cleanup..


