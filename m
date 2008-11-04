Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYKDQP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYKDQP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYKDQPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:15:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYKDQPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:15:19 -0500
Date: Tue, 4 Nov 2008 17:15:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][RESEND] Tracing/fastboot: Enable boot tracing only
	during initcalls
Message-ID: <20081104161511.GA6982@elte.hu>
References: <490AF2A0.80601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490AF2A0.80601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0167]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied these 6 patches from you to tip/tracing/fastboot:

79a9d46: tracing/ftrace: fix a bug when switch current tracer to sched tracer
efade6e: tracing/ftrace: types and naming corrections for sched tracer
d7ad44b: tracing/fastboot: use sched switch tracer from boot tracer
e55f605c: tracing/ftrace: remove unused code in sched_switch tracer
07695fa: tracing/ftrace: fix a race condition in sched_switch tracer
71566a0: tracing/fastboot: Enable boot tracing only during initcalls

thanks Frederic!

	Ingo
