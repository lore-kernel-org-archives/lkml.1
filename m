Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYLIKIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYLIKIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYLIKIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:08:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYLIKIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:08:34 -0500
Date: Tue, 9 Dec 2008 11:08:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
Message-ID: <20081209100817.GA11886@elte.hu>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org> <20081209024543.GA11538@elte.hu> <alpine.LRH.1.10.0812092005100.10841@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812092005100.10841@tundra.namei.org>
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


* James Morris <jmorris@namei.org> wrote:

> On Tue, 9 Dec 2008, Ingo Molnar wrote:
> 
> > hm, i'd rather carry these in the scheduler tree as we've got some 
> > changes in this area already and because these are arguably scheduler 
> > changes:
> > 
> >  Documentation/scheduler/sched-design-CFS.txt |   21 +++++++++++++++++++++
> >  kernel/user.c                                |    8 +++++++-
> > 
> > the incompleteness of CONFIG_USER_SCHED is not addressed yet.
> > 
> > Ok?
> 
> They're already published in my tree.  Do you want me to revert them?

I've also got it published :-/ If it's at the tail of your commits, can 
you reset it?

	Ingo
