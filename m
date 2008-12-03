Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbYLCUnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbYLCUnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763037AbYLCUkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:40:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763030AbYLCUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:40:40 -0500
Date: Wed, 3 Dec 2008 21:40:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, rostedt@goodmis.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       =linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Series short description
Message-ID: <20081203204025.GA31376@elte.hu>
References: <20081111142323.28477.41235.stgit@dev.haskins.net> <4936E587.40700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4936E587.40700@gmail.com>
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


* Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:

> Gregory Haskins wrote:
> > Hi Ingo, Steven, Peter,
> >   This series applies roughly to mainline as an enhancement to the sched_rt
> >   logic.  Peter and I were discussing some of the unecessary overhead in
> >   pull_rt_tasks() via IRC, and this is my RFC attempt to address the problem.
> >   
> 
> Hi Ingo,
>   I was putting together a refresh of this patch and I rebased on
> tip/sched/devel.  I noticed that sched/devel is on 27-rc8, which is
> obviously a little stale.  Is this the proper tree to send patches
> against, or would you prefer a different HEAD?

tip/master would be the base to use, or tip/sched/core. The sched/devel 
branch is indeed stale.

	Ingo
