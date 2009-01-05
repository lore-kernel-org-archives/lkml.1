Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZAEJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZAEJVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZAEJV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:21:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZAEJVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:21:25 -0500
Date: Mon, 5 Jan 2009 10:21:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105092110.GA11941@elte.hu>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105090239.GB17530@uranus.ravnborg.org> <20090105011202.835e75ec.akpm@linux-foundation.org> <20090105.011733.225349838.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105.011733.225349838.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 5 Jan 2009 01:12:02 -0800
> 
> > On Mon, 5 Jan 2009 10:02:39 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > Hi Andrew.
> > > 
> > > > sparc64-use-unsigned-long-long-for-u64.patch
> > > > sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
> > > 
> > > Please drop these two.
> > 
> > Might, if they break my build.
> 
> They don't build, I tested them when I tried integrated Sam's patches.

do they break due to some warnings caught by -Werror?

	Ingo
