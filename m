Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYKDJLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYKDJLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYKDJLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:11:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYKDJLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:11:00 -0500
Date: Tue, 4 Nov 2008 10:10:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] ftrace: ftrace_preempt_disable
Message-ID: <20081104091042.GD23790@elte.hu>
References: <20081104041554.605521183@goodmis.org> <20081104042203.123673140@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104042203.123673140@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0668]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i've applied your 3 patches to tip/tracing/ftrace:

 b2a866f: ftrace: function tracer with irqs disabled
 182e9f5: ftrace: insert in the ftrace_preempt_disable()/enable() functions
 8f0a056: ftrace: introduce ftrace_preempt_disable()/enable()

thanks Steve!

	Ingo
