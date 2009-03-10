Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZCJR25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZCJR25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCJR2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:28:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZCJR2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:28:47 -0400
Date: Tue, 10 Mar 2009 18:27:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090310172754.GB28767@elte.hu>
References: <20090121185021.GA8852@elte.hu> <20090309013902.GK10085@erda.amd.com> <18869.40904.382716.827097@cargo.ozlabs.ibm.com> <20090310094457.GU10085@erda.amd.com> <18870.21428.868208.447605@cargo.ozlabs.ibm.com> <20090310162616.GI10085@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310162616.GI10085@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 10.03.09 22:49:08, Paul Mackerras wrote:
> > Robert Richter writes:
> > 
> > > Ok, maybe I mixed too much the architectural with the x86 model
> > > specific implementation. My impression is that there is data in
> > > generic structures what should be better private for the model or
> > > architecture. However, I have to figure out the details here.
> > 
> > The details of the x86 support have changed quite a lot since the v6
> > patch was posted, I believe.  Are you looking at the v6 patch, or at
> > Ingo's tip:perfcounters/core branch?
> 
> I am using the tip branch, but took the v6 thread to discuss this.
> 
> > 
> > Ingo - maybe it's time to post a v7 patch?
> 
> For me it's fine to work with the branch if patches are posted 
> to the mailing list for review.

all perfcounter patches are on lkml and you can see all -tip 
commits in general by subscribing to the 
linux-tip-commits@vger.kernel.org mailing list.

	Ingo
