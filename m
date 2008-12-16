Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYLPTmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYLPTmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLPTma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:42:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYLPTm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:42:29 -0500
Date: Tue, 16 Dec 2008 20:42:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Simple LTTng userspace events through debugfs
Message-ID: <20081216194201.GE843@elte.hu>
References: <20081215231040.GA5936@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215231040.GA5936@Krystal>
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

> Hi,
> 
> I looked at kmemtrace and noticed that the presence of a debugfs 
> "marker" file, which lets userspace write events into the trace buffers.
> 
> So I just did the same with a
> 
> /debugfs/ltt/write_event

you mean similar to ftrace's /debug/tracing/trace_marker ? ;-)

	Ingo
