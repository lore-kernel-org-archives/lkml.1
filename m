Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbZHORAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbZHORAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbZHORAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:00:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbZHORAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:00:50 -0400
Date: Sat, 15 Aug 2009 19:00:09 +0200
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
Message-ID: <20090815170009.GB9265@elte.hu>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250355231169-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250355231169-git-send-email->
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

> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Judging from the signoff order, this is suppose dto be "From: John 
Triplett", right?

	Ingo
