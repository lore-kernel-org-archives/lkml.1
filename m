Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZKLHua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZKLHua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZKLHua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:50:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33873 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbZKLHu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:50:29 -0500
Date: Thu, 12 Nov 2009 08:50:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing: Fix return value of
 tracing_stats_read()
Message-ID: <20091112075022.GC16434@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
 <1257993225.22249.24.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257993225.22249.24.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I know this is late in the rc's, but this is a very minor fix. Do you
> think we can slip this in before 33.

Yeah, it's an obvious oneliner.

> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Roel Kluin (1):
>       tracing: Fix return value of tracing_stats_read()
> 
> ----
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks!

	Ingo
