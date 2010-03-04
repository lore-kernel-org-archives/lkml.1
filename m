Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0CDSJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:09:13 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:39165 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab0CDSJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:09:11 -0500
Date: Thu, 4 Mar 2010 11:53:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix warning in s_next of trace file
 ops
Message-ID: <20100304105316.GB21977@elte.hu>
References: <1267632972.10871.61.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267632972.10871.61.camel@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Lai Jiangshan (1):
>       tracing: Fix warning in s_next of trace file ops
> 
> ----
>  kernel/trace/trace.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo
