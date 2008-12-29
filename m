Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYL2LrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYL2LrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYL2Lqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:46:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42502 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYL2Lqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:46:52 -0500
Date: Mon, 29 Dec 2008 12:46:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/3] ftrace: updates for tip
Message-ID: <20081229114631.GA22727@elte.hu>
References: <20081224042410.746044949@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224042410.746044949@goodmis.org>
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

> This series restructures the output functions of trace.c.
> 
> Events are now registered and maintaining an event output is
> simplified by keeping the output close together.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (3):
>       ftrace: remove obsolete print continue functionality
>       ftrace: set up trace event hash infrastructure
>       ftrace: change trace.c to use registered events

pulled, thanks Steve!

	Ingo
