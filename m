Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZCBWOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZCBWOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZCBWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:14:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbZCBWOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:14:07 -0500
Date: Mon, 2 Mar 2009 23:13:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: Re: [GIT PULL] tracing: make CALLER_ADDRx overwriteable
Message-ID: <20090302221348.GB31162@elte.hu>
References: <alpine.DEB.2.00.0903021638480.4771@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903021638480.4771@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Uwe Kleine-Koenig (1):
>       tracing: make CALLER_ADDRx overwriteable
> 
> ----
>  arch/alpha/include/asm/ftrace.h    |    1 +
>  arch/avr32/include/asm/ftrace.h    |    1 +
>  arch/blackfin/include/asm/ftrace.h |    1 +
>  arch/cris/include/asm/ftrace.h     |    1 +
>  arch/h8300/include/asm/ftrace.h    |    1 +
>  arch/m68k/include/asm/ftrace.h     |    1 +
>  arch/mips/include/asm/ftrace.h     |    1 +
>  arch/parisc/include/asm/ftrace.h   |    1 +
>  arch/um/include/asm/ftrace.h       |    1 +
>  arch/xtensa/include/asm/ftrace.h   |    1 +
>  include/asm-frv/ftrace.h           |    1 +
>  include/asm-m32r/ftrace.h          |    1 +
>  include/asm-mn10300/ftrace.h       |    1 +
>  include/linux/ftrace.h             |   41 ++++++++++++++++++-----------------
>  14 files changed, 34 insertions(+), 20 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
