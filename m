Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZBVTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZBVTRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZBVTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:17:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZBVTRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:17:38 -0500
Date: Sun, 22 Feb 2009 20:17:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090222191707.GA5632@elte.hu>
References: <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <20090222121821.3599.A69D9226@jp.fujitsu.com> <1235302660.4632.4.camel@laptop> <20090222160405.GA17875@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222160405.GA17875@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > > so I wonder why don't we create linux-tracing new mailing 
> > > list.

Discussions related to upstream Linux tracing are generally 
conducted on lkml.

> > Yes, lets hide it from general view, sounds like a brilliant 
> > plan.
> 
> I guess Kosaki's point is that there may be a disconnect 
> between the work that is done on the LTTng side and the ftrace 
> side. [...]

Could you please list the items we need to extend the tracing 
framework in kernel/tracing/* with so that we can support the 
aspects of LTTng you consider important and upstream-worthy?

As i've mentioned it in the past, i'm definitely interested in 
helping such an effort to further improve Linux tracing.

	Ingo
