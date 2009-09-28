Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZI1PyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZI1PyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZI1PyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:54:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbZI1PyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:54:08 -0400
Date: Mon, 28 Sep 2009 17:53:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] rcu: v2: more review feedback
Message-ID: <20090928155317.GA10560@elte.hu>
References: <20090927064753.GA9394@linux.vnet.ibm.com> <20090928144551.GA20704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928144551.GA20704@linux.vnet.ibm.com>
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

> This patchset applies the last of the review comments:
> 
> o	Whitespace fixes, updated comments, and code movement.
> 
> o	Improve an existing abstraction and introduce two additional
> 	abstractions for traversing the rcu_node tree.
> 
> Change since v1 (http://lkml.org/lkml/2009/9/27/17):
> 
> o	Update second patch's changelog

Applied, thanks a lot Paul!

	Ingo
