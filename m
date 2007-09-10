Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXIJSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXIJSq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965286AbXIJSqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:46:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185AbXIJSqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:46:03 -0400
Date: Mon, 10 Sep 2007 20:44:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 0/9] RCU: Preemptible RCU
Message-ID: <20070910184448.GA26096@elte.hu>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910183004.GA3299@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Work in progress, still not for inclusion.  But code now complete!

cool! Now after 2 years of development and testing i think this is one 
of the most mature patchsets on lkml - so i'd like to see this 
designated for potential upstream inclusion. I.e. everyone who can see 
some bug, please holler now.

	Ingo
