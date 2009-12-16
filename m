Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZLPEnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZLPEnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZLPEnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:43:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZLPEnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:43:04 -0500
X-Authority-Analysis: v=1.0 c=1 a=xk-mIdSzUoQA:10 a=rHr1n1pq4hlqXV-59DUA:9 a=h8n0Gqpdz12hi3vB8MWOoEQ3bwcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH V5 0/10] tracing: use defined fields to print formats
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B273D1E.6070003@cn.fujitsu.com>
References: <4B273D1E.6070003@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 23:41:09 -0500
Message-Id: <1260938469.2269.18.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 15:39 +0800, Lai Jiangshan wrote:

> Patches are partitioned for easy to review:
> PATCH#1~5 prepare (PATCH#2 fix a regression)
> PATCH#6 add "print_fmt" field to struct ftrace_event_call and and initialization code for it.
> PATCH#7 "print_fmt" initialization code for trace_syscalls
> PATCH#8 "print_fmt" initialization code for trace_kprobe
> PATCH#9 use defined fields and "print_fmt" to print formats
> PATCH#10 remove show_format and corresponding codes.

Thanks Lai!

I'll be traveling tomorrow, but I'll work on this on Thursday.

-- Steve


