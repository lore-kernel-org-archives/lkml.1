Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbZFWN5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbZFWN5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbZFWN53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:57:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZFWN52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:57:28 -0400
Date: Tue, 23 Jun 2009 15:57:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Brice Goglin <Brice.Goglin@inria.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623135722.GA8808@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <87r5xb174u.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r5xb174u.fsf@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Brice Goglin <Brice.Goglin@inria.fr> writes:
> 
> > Hello,
> >
> > I am trying to play with perfcounters in current git (actually in latest
> > mmotm). I'd like to reproduce what I previously did with pfmon, but I
> > couldn't so far.
> >
> > Something like
> >     pfmon --follow-exec 'foobar' -e
> > CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_0,CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_1
> > -- <shell script>
> > gives the number of memory accesses to dram node #0 and #1 for all
> > processes whose name matches 'foobar'.
> 
> My understanding based on recent emails on the topic is that the 
> perfctr gods decreed you are not to do any of this because they 
> cannot think of a use case for it, therefore none exist.

You are working for Intel, right?

Is the trolling of AMD related threads now an officially sanctioned 
activity by Intel, or do you do it out of personal motivation, in 
your free time? I'd really like to know, because what you do here is 
quite unprofessional and quite a distraction.

[ Btw., 'perfctr' is the name of another project, the one you wanted
  to attack here is called 'perfcounters'. ]

	Ingo
