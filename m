Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZCDRht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZCDRht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZCDRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:37:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZCDRhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:37:39 -0500
Date: Wed, 4 Mar 2009 18:37:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] tracing: block events
Message-ID: <20090304173714.GD25962@elte.hu>
References: <1236181529.5330.7912.camel@laptop> <alpine.DEB.2.00.0903041052340.7995@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903041052340.7995@gandalf.stny.rr.com>
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
> 
> On Wed, 4 Mar 2009, Peter Zijlstra wrote:
> 
> > Subject: tracing: block events
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed Mar 04 15:09:43 CET 2009
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Peter, Thanks!
> 
> I'll try it out. I know this is an RFC patch, but it could 
> really due with a change log ;-)

also, i think there's some extra complexity in the blktrace 
tracepoints that needs the _SPECIAL macro - right?

	Ingo
