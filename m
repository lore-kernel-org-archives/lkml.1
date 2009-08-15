Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZHORMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZHORMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZHORMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:12:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbZHORMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:12:36 -0400
Date: Sat, 15 Aug 2009 19:11:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
       Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH -tip/core/rcu 6/6] Fix typo in rcu_irq_exit() comment
	header.
Message-ID: <20090815171157.GA5790@elte.hu>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <20090815170009.GB9265@elte.hu> <20090815171024.GJ6725@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815171024.GJ6725@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Aug 15, 2009 at 07:00:09PM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Judging from the signoff order, this is suppose dto be "From: John 
> > Triplett", right?
> 
> Indeed it is!!!
> 
> Well, now I know why one uses "git am" even when just making the 
> change would be less typing.  Sorry for my confusion!!!

no problem - i fixed it up.

	Ingo
