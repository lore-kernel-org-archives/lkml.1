Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbXIYSdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbXIYSdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXIYSdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:33:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXIYSde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:33:34 -0400
Date: Tue, 25 Sep 2007 20:32:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] More group scheduler related fixes
Message-ID: <20070925183240.GA21314@elte.hu>
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925162502.GA3231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Sep 25, 2007 at 04:44:43PM +0200, Ingo Molnar wrote:
> > 
> > The latest sched-devel.git tree can be pulled from:
> >   
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> > 
> 
> Ingo,
> 	Few more patches follow on top of this latest sched-devel tree.
> 
> Pls consider for inclusion.

thanks, applied.

	Ingo
