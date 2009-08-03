Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZHCUwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZHCUwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZHCUwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:52:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57117 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZHCUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:52:31 -0400
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Dave Anderson <anderson@redhat.com>, crash-utility@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to analyze tracing from core-file (make tracing can act as a flight recorder)
From: Andi Kleen <andi@firstfloor.org>
References: <4A76F8A1.30503@cn.fujitsu.com>
	<20090803151420.GA8712@infradead.org>
	<1249312875.7924.106.camel@twins> <4A773EBD.3050707@windriver.com>
Date: Mon, 03 Aug 2009 22:52:28 +0200
In-Reply-To: <4A773EBD.3050707@windriver.com> (Jason Wessel's message of "Mon, 03 Aug 2009 14:47:09 -0500")
Message-ID: <87ljm0tyb7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel <jason.wessel@windriver.com> writes:
>
> In no particular order, tracing, kernel probes, profiling data display,
> kdump, disassembly and kernel mode setting were some of the pieces that
> are on the wish list for integration with the kdb prototype.  Kernel
> mode setting is presently the highest priority on the wish list for a
> new feature.

I suspect for a lot of people the highest priority issue would be
a polled USB keybord driver. Or do you plan to use the one from
old kdb (iirc it was pretty crufty)

No i don't plan to contribute that. When I use debuggers I prefer
source level.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
