Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbYBMK6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbYBMK6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYBMK6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:58:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbYBMK6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:58:33 -0500
Date: Wed, 13 Feb 2008 11:58:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, gregkh@suse.de, rusty@rustcorp.com.au
Subject: Re: [git pull] CPU isolation extensions (updated)
Message-ID: <20080213105804.GE32241@elte.hu>
References: <47AE6A8B.6030908@qualcomm.com> <20080209212156.ecc72fee.pj@sgi.com> <47AE76B8.6060304@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AE76B8.6060304@qualcomm.com>
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> Ingo said a few different things (a bit too large to quote). 

[...]
> And at the end he said:
> > Also, i'd not mind some test-coverage in sched.git as well.

> I far as I know "do not mind" does not mean "must go to" ;-). [...]

the CPU isolation related patches have typically flown through 
sched.git/sched-devel.git, so yes, you can take my "i'd not mind" 
comment as "i'd not mind it at all". That's the tree that all the folks 
who deal with this (such as Paul) are following. So lets go via the 
normal contribution cycle and let this trickle through with all the 
scheduler folks? I'd say 2.6.26 would be a tentative target, if it holds 
up to scrutiny in sched-devel.git (both testing and review wise). And 
because Andrew tracks sched-devel.git it will thus show up in -mm too.

	Ingo
