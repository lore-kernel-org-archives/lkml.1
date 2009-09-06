Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbZIFE2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbZIFE2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZIFE2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:28:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZIFE17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:27:59 -0400
Date: Sun, 6 Sep 2009 06:27:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH 0/2] tracing: Fixes for 2.6.32
Message-ID: <20090906042752.GC18071@elte.hu>
References: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull these two tracing fixes which can be found at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> 	tracing/core
> 
> Thanks.
> 
> ---
> Albin Tonnerre (1):
>       tracing: Remove mentioning of legacy latency_trace file from documentation
> 
> Li Zefan (1):
>       tracing/filters: Defer pred allocation, fix memory leak
> 
>  Documentation/trace/ftrace.txt     |   68 +++++++++++++++++++-----------------
>  kernel/trace/trace_events_filter.c |   11 +++---
>  2 files changed, 42 insertions(+), 37 deletions(-)

Pulled, thanks Frederic!

	Ingo
