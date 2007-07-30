Return-Path: <linux-kernel-owner+w=401wt.eu-S939014AbXG3Gor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939014AbXG3Gor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935105AbXG3Goj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:44:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59895 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764100AbXG3Goj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:44:39 -0400
Date: Mon, 30 Jul 2007 08:44:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: George Sescher <gesacs@gmail.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070730064423.GA30505@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu> <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* George Sescher <gesacs@gmail.com> wrote:

> On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> > i'd encourage you to do it - in fact i already tried to prod Peter 
> > Williams into doing exactly that ;) The more reality checks a 
> > scheduler has, the better. [ Btw., after the obvious initial merging 
> > trouble it should be much easier to keep SD maintained against 
> > future upstream kernels due to the policy modularity that CFS 
> > introduces. (and which policy-modularity should also help reduce the 
> > size and complexity of the SD patch.) ]
> 
> <chuckle>
> 
> You're advocating plugsched now?

hm, the way you posited this question implies that you see an 
inconsistency in my position or that it surprised you - i cannot explain 
the '<chuckle>' in any other way :) Which bit do you see as inconsistent 
and/or which bit surprised you and why?

        Ingo

