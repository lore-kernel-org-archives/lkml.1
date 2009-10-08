Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbZJHTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbZJHTVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbZJHTVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:21:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbZJHTVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:21:49 -0400
Date: Thu, 8 Oct 2009 21:20:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20091008192058.GA12773@elte.hu>
References: <20091008190617.GA7817@elte.hu> <alpine.LFD.2.01.0910081213420.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910081213420.3432@localhost.localdomain>
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

> 
> 
> On Thu, 8 Oct 2009, Ingo Molnar wrote:
> > 
> > Please pull the latest core-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus
> > 
> > Sigh ... this now looks a bit large for -rc3, due to the RCU 
> > cleanups. When i queued it up in -rc1 it looked acceptable :-/ 
> > Should we redo it again to extract the cleanups from the fixes 
> > (which cause most of the diffstat increase)?
> 
> Gaah.
> 
> Looking at the actual patch, it looks ok to me. But I really would 
> have preferred to see just fixes by now.
> 
> But I'll take it this way.

Thanks. Will be more careful ...

	Ingo
