Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZCYQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZCYQUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZCYQUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:20:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZCYQUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:20:10 -0400
Date: Wed, 25 Mar 2009 17:19:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 0/3 v2] [GIT PULL] remove unlikelys
Message-ID: <20090325161913.GB1411@elte.hu>
References: <20090325154538.916038098@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325154538.916038098@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The differences between v1 and v2 is that I only included the non 
> controversial patches. I also modified the change log of 
> pre_schedule_rt to include the annotated branch profiler output.

>       mm: remove unlikelys for unlock in rmap.c

>  mm/rmap.c         |    8 ++++----

the rmap.c thing looks uncontroversial to me, but an MM person 
should still have a look and Ack it.

	Ingo
