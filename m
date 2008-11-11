Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYKKR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYKKR5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYKKR5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:57:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYKKR5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:57:02 -0500
Date: Tue, 11 Nov 2008 18:56:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@goodmis.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
       =linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Series short description
Message-ID: <20081111175649.GA12339@elte.hu>
References: <20081111142323.28477.41235.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111142323.28477.41235.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo, Steven, Peter,
>   This series applies roughly to mainline as an enhancement to the sched_rt
>   logic.  Peter and I were discussing some of the unecessary overhead in
>   pull_rt_tasks() via IRC, and this is my RFC attempt to address the problem.
> 
>   I have built/booted this on a 4-way C2D Xeon box and it passes preempt-test.
> 
>   Comments, please.

this direction looks very nifty to me. Peter, do you Ack them?

	Ingo
