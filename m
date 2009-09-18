Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZIRPxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZIRPxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZIRPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:53:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZIRPxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:53:44 -0400
Date: Fri, 18 Sep 2009 17:52:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
Message-ID: <20090918155247.GA20347@elte.hu>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090917173012.GA11155@elte.hu> <20090917103614.6ab1385f@jbarnes-g45> <20090917175944.GA17304@elte.hu> <20090918082715.6272a262@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918082715.6272a262@jbarnes-g45>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thu, 17 Sep 2009 19:59:44 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > On Thu, 17 Sep 2009 19:30:12 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > > > Config and full bootlog attached.
> > > > 
> > > > Note:
> > > > 
> > > >  CONFIG_DEBUG_PER_CPU_MAPS=y
> > > >  CONFIG_CPUMASK_OFFSTACK=y
> > > 
> > > Does this patch fix it?  I sent it to you earlier but I never heard 
> > > back...
> > 
> > Ah ... you probably sent it in the merge window communication
> > blackout ;-)
> > 
> > Will try, thanks.
> 
> Did you get a chance to try this patch yet Ingo?

Yeah, it does - thanks.

	Ingo
