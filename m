Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYKFVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYKFVWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYKFVWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:22:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYKFVWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:22:09 -0500
Date: Thu, 6 Nov 2008 22:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH 0/0] ftrace: fix hardirq.h for m68k
Message-ID: <20081106212148.GB24579@elte.hu>
References: <20081106211307.944238362@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106211307.944238362@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo and Stephen,
> 
> The problem that Alexey pointed out should be fixed by this trivial patch.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> Steven Rostedt (1):
>       ftrace: split out hardirq ftrace code into own header

i've pulled that into tip/tracing/ftrace and have pushed out a new 
auto-ftrace-next for Stephen - thanks Steve!

	Ingo
