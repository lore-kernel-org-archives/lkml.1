Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYLHOPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYLHOPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLHOPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:15:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYLHOPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:15:35 -0500
Date: Mon, 8 Dec 2008 15:15:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/function-graph-tracer: turn
	tracing_selftest_running into an int
Message-ID: <20081208141530.GB14856@elte.hu>
References: <4939E65D.9060800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939E65D.9060800@gmail.com>
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

> Impact: cleanups
> 
> Apply some suggestions of Steven Rostedt:
> 
> _turn tracing_selftest_running into a simple int (no need of an atomic_t)
> _set it __read_mostly
> _fix a comment style
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/function-graph-tracer, thanks Frederic!

	Ingo
