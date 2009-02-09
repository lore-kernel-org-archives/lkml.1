Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZBIJwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZBIJwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZBIJwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:52:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBIJwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:52:32 -0500
Date: Mon, 9 Feb 2009 10:52:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] tracing/function-graph-tracer: provide a selftest
	for the function graph tracer
Message-ID: <20090209095225.GB14402@elte.hu>
References: <498e175a.0305560a.632d.2a9f@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498e175a.0305560a.632d.2a9f@mx.google.com>
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

> Making more easy to do a basic regression test for this tracer.
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.h                 |    2 +
>  kernel/trace/trace_functions_graph.c |    3 ++
>  kernel/trace/trace_selftest.c        |   50 ++++++++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 0 deletions(-)

Applied to tip/tracing/ftrace, thanks Frederic!

	Ingo
