Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZBQXrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZBQXrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZBQXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:47:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZBQXrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:47:07 -0500
Date: Wed, 18 Feb 2009 00:46:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
Message-ID: <20090217234630.GA12714@elte.hu>
References: <20090217051227.957864159@goodmis.org> <20090217104213.GC6602@elte.hu> <alpine.DEB.1.10.0902171207100.910@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902171207100.910@gandalf.stny.rr.com>
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
> On Tue, 17 Feb 2009, Ingo Molnar wrote:
> > 
> > Small naming detail: instead of calling it a 'hook' (which 
> > really has a bad sound to it for various reasons), how about 
> > calling it a 'trigger' and/or a 'callback'?
> 
> I started converting the names from hook to trigger, and the name looks 
> funny to me. I asked on IRC for opinions and Luis suggested "_probe". I 
> think I like that idea.
> 
> Ingo, do you agree that "_probe" would be a good substitute for "_hook"?

yeah, that's OK too i think.

	Ingo
