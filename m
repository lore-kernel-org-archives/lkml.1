Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZIVINh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZIVINh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZIVIN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:13:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbZIVIN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:13:26 -0400
Date: Tue, 22 Sep 2009 10:13:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
	perf_counter rename
Message-ID: <20090922081318.GC1475@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com> <1253584591.7103.197.camel@pasglop> <20090922072834.GA25470@elte.hu> <1253606415.7103.216.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253606415.7103.216.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2009-09-22 at 09:28 +0200, Ingo Molnar wrote:
> > 
> > Nevertheless you are right that i should have caught this particular 
> > PowerPC build bug - i missed it - sorry about that!
> 
> Allright. Well, to help in general, we are setting up a build-bot here 
> too that will build -tip HEAD for at least powerpc daily with a few 
> configs too.

Cool, that's really useful! Especially during the weekends that will be 
helpful, in that timeframe linux-next driven testing has a latency of 
72-95 hours and -tip usually has an uptick in patches.

Thanks,

	Ingo
