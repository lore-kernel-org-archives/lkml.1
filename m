Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbYLENta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbYLENta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbYLENtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:49:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbYLENtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:49:16 -0500
Date: Fri, 5 Dec 2008 14:49:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ftrace: provide the macro
	task_curr_ret_stack()
Message-ID: <20081205134909.GC27039@elte.hu>
References: <49385EEB.20003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49385EEB.20003@gmail.com>
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

> Impact: cleanup
> 
> As suggested by Steven Rostedt, this patch provide a new macro
> task_curr_ret_stack() to move the cpp conditionnal CONFIG into
> the linux/ftrace.h headers.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/ftrace.h |   11 +++++++++++
>  kernel/trace/trace.c   |    8 +-------
>  2 files changed, 12 insertions(+), 7 deletions(-)

applied to tip/tracing/ftrace, thanks!

	Ingo
