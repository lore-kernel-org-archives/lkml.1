Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZA0NcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZA0NcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZA0NcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:32:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbZA0NcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:32:01 -0500
Date: Tue, 27 Jan 2009 14:31:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] x86: ftrace - simplify wait_for_nmi
Message-ID: <20090127133146.GA15150@elte.hu>
References: <20090126152802.GA12465@localhost> <alpine.DEB.1.10.0901261041430.9334@gandalf.stny.rr.com> <alpine.DEB.1.10.0901270037310.6995@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901270037310.6995@gandalf.stny.rr.com>
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
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Cyrill Gorcunov (1):
>       x86: ftrace - simplify wait_for_nmi
> 
> ----
>  arch/x86/kernel/ftrace.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)

Pulled, thanks guys!

	Ingo
