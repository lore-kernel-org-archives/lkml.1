Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbZANWia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbZANWia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZANWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:38:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZANWiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:38:14 -0500
Date: Wed, 14 Jan 2009 23:37:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>, Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] MAINTAINERS - Add FTRACE git
Message-ID: <20090114223753.GB19173@elte.hu>
References: <1231878498-25171-1-git-send-email-joe@perches.com> <1231878498-25171-9-git-send-email-joe@perches.com> <20090114055954.GA7039@linux-sh.org> <1231913987.30095.11.camel@localhost> <alpine.DEB.1.10.0901140811530.6759@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901140811530.6759@gandalf.stny.rr.com>
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

> > maybe:
> > 
> > T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git auto-ftrace-next
> > 
> > No idea what's right here.  I had some private emails
> > with Steven Rostedt about a git tree.  He suggested
> > to use tip.
> > 
> > Steven?  Suggestions?
> 
> Ingo usually pulls ftrace related patches into the tracing/ftrace 
> branch. That is for core ftrace. Since ftrace has a bunch of pluggins, 
> they may have their own branches.

for a stable Git reference for tracing development i'd suggest 
tip/tracing/core.

The 'core' topic branch is where the known-stable tracing topics are 
merged into. The other topic branches can include known-broken or 
known-WIP bits.

	Ingo
