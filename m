Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbZEMM4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbZEMM4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbZEMM4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:56:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZEMM4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:56:10 -0400
Date: Wed, 13 May 2009 14:55:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] itimers: periodic timers fixes
Message-ID: <20090513125551.GB12701@elte.hu>
References: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com> <20090402165753.GA12793@elte.hu> <20090415142232.46a97f70@dhcp-lab-109.englab.brq.redhat.com> <20090415135902.GC12760@elte.hu> <alpine.LFD.2.00.0905122308350.3561@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905122308350.3561@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 15 Apr 2009, Ingo Molnar wrote:

> > > Could the patches be merged and possible other work done in 
> > > later time? Or perhaps I should rework on them?
> > 
> > It's up to Thomas - but they certainly looked good to me.
> 
> Huch, did I inherit the cputimers horror as a gratification for 
> touching kernel/*timer* at some point ?

yes, and also by virtue of being listed as the upstream maintainer 
of the hrtimers/clockevents bits, in MAINTAINERS :)

> Seriously, give me a day or two to have a close look. I'm fighting 
> with a set of other timer related patches which I have delayed 
> long enough already.

Great! :)

	Ingo
