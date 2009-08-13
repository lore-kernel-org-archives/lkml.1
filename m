Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZHMUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZHMUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbZHMUKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:10:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46141 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbZHMUKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:10:10 -0400
Date: Thu, 13 Aug 2009 22:10:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perfcounters fixes
Message-ID: <20090813201002.GA4876@elte.hu>
References: <20090813190455.GA18801@elte.hu> <alpine.LFD.2.01.0908131225040.28882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908131225040.28882@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 13 Aug 2009, Ingo Molnar wrote:
> > 
> > Please pull the latest perfcounters-fixes-for-linus git tree 
> > from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus
> 
> Is this really generally fixing things that should be fixed after 
> -rc?
> 
> I'm getting very tired of the perfcounters tree. It's not calming 
> down in -rc. I've pulled this, but quite frankly, I think there 
> are commits there that you should not have sent me, and I'm 
> getting fed up to the point that I suspect next time around I 
> won't pull even the valid things just because you're not being 
> careful enough.

Sorry about that. You are right and i'll cool the tree down 
(massively) and be much more careful.

	Ingo
