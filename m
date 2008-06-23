Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYFWCVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYFWCVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYFWCVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:21:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41477 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYFWCU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:20:59 -0400
Date: Mon, 23 Jun 2008 11:19:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
Cc: kosaki.motohiro@jp.fujitsu.com, "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <485DD589.6070503@redhat.com>
References: <20080621180203.GA11804@redhat.com> <485DD589.6070503@redhat.com>
Message-Id: <20080623110927.37C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter, I thought, we were discussing what interface we could accept,
> not how many or where tracepoints we could accept. Or, am I misreading?
> 
> I know that if someone pushes markers into kernel in his own sweet way,
> of course, the kernel code will be bloated endlessly. But I also know
> why we review patches and send Ack/Nack before merging them to the tree.
> (If you still worry about it, we might be able to make linux-markers
> git tree, and review all regular markers on it)

Indeed.

if necessary, I can maintain this tree.
(because, I hope marker is independent by LTTng and SystemTap.
 So, I am no related any tracer in this discussion member.)

but, at first,
We should review and discuss to Mathieu's new tracepoint proposal.
I think that is good idea.


