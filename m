Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXFVM5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXFVM5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXFVM45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:56:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbXFVM44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:56:56 -0400
Date: Fri, 22 Jun 2007 14:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 1/6] Convert the RCU tasklet into a softirq
Message-ID: <20070622125509.GA15329@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622040136.621853953@goodmis.org> <20070622071039.GB21291@infradead.org> <20070622074344.GA9472@elte.hu> <1182515747.5493.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182515747.5493.23.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> If you do pull this patch in, I would like to get a sign-off-by from 
> Dipankar and give him credit, since I think he was the original 
> author. I just pulled it out of the -rt branch.

you can preserve authorship by sending with a patch metadata that says 
From: Dipankar.

	Ingo
