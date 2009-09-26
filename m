Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbZIZJJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbZIZJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 05:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZIZJJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 05:09:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZIZJJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:09:56 -0400
Subject: Re: [PATCH tracing/kprobes 0/3] tracing/kprobes: kprobe-tracer
 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
In-Reply-To: <20090925181952.10157.9975.stgit@omoto>
References: <20090925181952.10157.9975.stgit@omoto>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 05:08:45 -0400
Message-Id: <1253956125.12145.5.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 11:19 -0700, Masami Hiramatsu wrote:
> Hi Frederic,
> 
> Here is a few updates for kprobe-tracer which fix reported bugs and
> is for catching up the latest ftrace.
> 
>  - Use dynamic percpu profiling buffer patch is for catching up
>    the latest ftrace change.
>  - Checking the result of create_event_dir() patch improves ftrace
>    code pointed by Li Zefan (thanks!).
>  - Add VIA instructions to x86 insn decoder patch fixes decoding
>    bug reported by Ingo Molnar (thanks!).
> 
> Soon after this series, I'll send perf-kprobe patch series.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


