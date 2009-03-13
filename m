Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZCMP4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZCMP4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZCMP4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:56:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbZCMP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:56:12 -0400
Date: Fri, 13 Mar 2009 16:55:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 0/2 v2] Syscalls tracing
Message-ID: <20090313155541.GA15481@elte.hu>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <20090313151632.GB9867@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313151632.GB9867@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Mar 13, 2009 at 03:42:10PM +0100, Frederic Weisbecker wrote:
> > tracing/syscalls: core infrastructure to trace syscalls
> > 
> > This new iteration addresses a good part of the previous reviews.
> 
> 
> Ah I just discovered that you applied the previous version 
> today. But the v2 is not a delta :-s
> 
> I can rebase them but not until Sunday.

No problem, i'll deltify them and will have a look.

	Ingo
