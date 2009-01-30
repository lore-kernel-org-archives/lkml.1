Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZA3SUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZA3SUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZA3SUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:20:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37734 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZA3SUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:20:17 -0500
Date: Fri, 30 Jan 2009 19:20:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
Message-ID: <20090130182001.GB20302@elte.hu>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <20090127233159.GA26403@elte.hu> <1233324092.3670.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233324092.3670.4.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> On Wed, 2009-01-28 at 00:31 +0100, Ingo Molnar wrote:
> 
> > Jaswider, would you mind re-doing the tree filtering out the CONFIG_* 
> > changes? I'll go over the end result once more to make sure it has no 
> > changes that make the code look worse.
> 
> Sure, why not ;-)
> 
> But in your -tip tree you already have these patches. Are you going to 
> revert them or should I make patches for linus tree.

yes, i'll replace that branch with your tree - the bad commits are 
intermixed with the good commits so reverting does not help (there would 
be way too many ugly reverts).

As long as you base your patches on Linus's -git tree i'll be able to sort 
it all out.

	Ingo
