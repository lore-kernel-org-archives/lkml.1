Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbYKPG6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYKPG6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPG6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:58:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58351 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKPG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:58:43 -0500
Date: Sun, 16 Nov 2008 07:58:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Various fixes and enhancements for tracing
Message-ID: <20081116065830.GF32215@elte.hu>
References: <491FA6E8.2010506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FA6E8.2010506@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This patchset applies on latest -tip (and normally against latest Steven's tracing tree).
> 
> _ tracing/ftrace: Fixes unexpected -EINVAL when longest tracer name is set
> _ tracing/ftrace: Change the type of the init() callback

applied to tip/tracing/ftrace,

> _ tracing/branch-tracer: Fix a trace recursion on branch tracer

applied to tip/tracing/branch-tracer,

> _ tracing/function-return-tracer: Support for dynamic ftrace on function return tracer

applied to tip/tracing/function-return-tracer.

thanks Frederic!

> The first and the third are bug fixes and the others are submitted 
> for purposes on improvement for tracing and the function return 
> tracer. Note that I kept the "return" name for the names used in the 
> last patch because we haven't yet decided what could be the better 
> name. But once we find it, I will change the name of data structures 
> and functions used by this tracer.

ok.

	Ingo
