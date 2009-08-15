Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZHORK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZHORK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZHORKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:10:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52764 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbZHORKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:10:24 -0400
Date: Sat, 15 Aug 2009 10:10:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
       Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH -tip/core/rcu 6/6] Fix typo in rcu_irq_exit() comment
	header.
Message-ID: <20090815171024.GJ6725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090815165153.GA8886@linux.vnet.ibm.com> <20090815170009.GB9265@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815170009.GB9265@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 07:00:09PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Judging from the signoff order, this is suppose dto be "From: John 
> Triplett", right?

Indeed it is!!!

Well, now I know why one uses "git am" even when just making the
change would be less typing.  Sorry for my confusion!!!

						Thanx, Paul
