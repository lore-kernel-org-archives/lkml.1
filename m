Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbZAOXYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbZAOXYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZAOXYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:24:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZAOXYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:24:36 -0500
Date: Fri, 16 Jan 2009 00:24:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090115232425.GA18265@elte.hu>
References: <20090115220809.GA7793@elte.hu> <1232061471.8870.77.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232061471.8870.77.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4909]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-01-15 at 23:08 +0100, Ingo Molnar wrote:
> 
> > Peter Zijlstra (4):
> >       sched: fix bandwidth validation for UID grouping
> >       sched: SCHED_IDLE weight change
> >       sched: SCHED_OTHER vs SCHED_IDLE isolation
> >       sched: fix update_min_vruntime
> 
> Drad, 2 of those were from Mike and quilt ate the From :-(

Linus, if you have not pulled this yet, could you please skip it?

	Ingo
