Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbYB2PtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbYB2PtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbYB2Ps6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:48:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbYB2Ps5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:48:57 -0500
Date: Fri, 29 Feb 2008 16:48:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       jarkao2@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] fix boot-time hangs from PREEMPT_RCU and NO_HZ
Message-ID: <20080229154835.GB27248@elte.hu>
References: <Pine.LNX.4.58.0801291113350.20371@gandalf.stny.rr.com> <20080229044329.GA20207@linux.vnet.ibm.com> <20080228210140.37abe9cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228210140.37abe9cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Note: This patch came directly from the -rt patch where it has been 
> > tested for several months.
> > 
> > Andrew, could you please apply this?
> 
> I already have it, via git-sched.  Presumably Ingo has it lined up for 
> the next sched-related merge.

yes.

	Ingo
