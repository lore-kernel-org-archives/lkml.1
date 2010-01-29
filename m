Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626Ab0A2IrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0A2IrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190Ab0A2IrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:47:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab0A2IrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:47:15 -0500
Date: Fri, 29 Jan 2010 09:47:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing core patchlet
Message-ID: <20100129084705.GA1583@elte.hu>
References: <1264724658-12991-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264724658-12991-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the tracing/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Lai Jiangshan (1):
>       tracing: Simplify test for function_graph tracing start point
> 
> 
>  kernel/trace/trace.h                 |    2 +-
>  kernel/trace/trace_functions_graph.c |    8 ++------
>  2 files changed, 3 insertions(+), 7 deletions(-)

Pulled, thanks Frederic!

	Ingo
