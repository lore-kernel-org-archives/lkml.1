Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZGTN7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZGTN7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZGTN7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:59:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33361 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZGTN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:59:46 -0400
Date: Mon, 20 Jul 2009 22:57:32 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE][RFC] trace-cmd - command line reader for ftrace
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com
In-Reply-To: <alpine.DEB.2.00.0907171009050.9337@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907171009050.9337@gandalf.stny.rr.com>
Message-Id: <20090720225637.AF63.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, this is very much in alpha form. It may still be very buggy, and 
> the format of the trace.dat file may soon change. Thus it is still in 
> [RFC] release status, and nothing is considered stable.
> 
> Here's some todo's I have planned.
> 
>  1) get it in a form to be used by perf (if possible)
>  2) add many more filters
>    a) More ways to filter on the report side
>    b) Add ways to filter on the recording side
>     This includes:
>       Using the /debug/tracing/event/*/filter files
>       Using the set_ftrace_filter/notrace files
>       Using the set_ftrace_pid
>       set_graph_function
>       enabling the backtrace functions
>       enabling the tracing/options
> 
> And I'm sure there are many more.
> 
> So, please feel free to download this code and play with it. If you find 
> bugs, please report. If you have other ideas that are not listed above, 
> share them.
> 
> Have fun!

Great! 
I'm very interesting this and I plan to start to evaluate this very 
good tool since next week.

Thanks for good effort.



