Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbZIXLR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbZIXLR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZIXLR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:17:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIXLR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:17:26 -0400
Date: Thu, 24 Sep 2009 13:16:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, acme@redhat.com, mhiramat@redhat.com,
       postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090924111645.GC628@elte.hu>
References: <20090923194122.GB20934@elte.hu> <20090923.145518.255137716.davem@davemloft.net> <20090923221059.GB29816@elte.hu> <20090923.154152.193726140.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923.154152.193726140.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 24 Sep 2009 00:10:59 +0200
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> >
> >> You're lack of face-to-face interaction with people is why you 
> >> constantly blow up like this.  Please make an effort to change this in 
> >> the future.
> > 
> > I have no trouble with hundreds of people i work with, except you - and 
> > you are in a pretty similar position - and that's sad. Such 
> > incompatibilities happen (to no real fault of any of the sides) and 
> > we'll have to learn to deal with it.
> 
> This is not a me vs. you thing.  Everyone I have spoken to
> here at LinuxCon and LinuxPlumbers has expressed extreme
> dismay that you do not at least attend the kernel summit on
> a regular basis.

Well, i'm going to attend a Linux kernel conference in two days, so no, 
i dont ignore conferences. (Wont attend the KS this year though - cannot 
attend too many conferences unfortunately - they are certainly fun :)

But that's beside the point even - i absolutely reject your apparent 
notion that i have to meet you 'face to face' to be treated in a 
friendly and honest way, such as in a routine matter of creating a 
mailing list on vger. "You have to visit the same pubs as us to be on 
the same frequency" is clan/tribe/clique thinking that i find 
fundamentally harmful.

( That also happens to be one of the main disagreements (and sources of
  conflicts) between you and me - the "us vs them" mentality on netdev 
  that i have a problem with. You know that. )

Anyway, i'm glad it got all resolved, and yes, after months of trying to 
achieve this new mailing list amicably i saw no other way but to raise 
attention to this matter in more forceful terms.

Btw., regardless of your flames against me in the past, i dont think you 
dislike perf events all that much anymore. The recent Niagara code you 
wrote in arch/sparc/kernel/perf_event.c certainly shows great care and 
interest, and i think/hope that you enjoyed dealing with that subsystem. 
You did contribute a number of fixes and i think you'd have told us 
frankly if you still disliked aspects of its design. So as far as my 
"you did this to hurt perf" accusation goes, that was unfair and over 
the top, and i apologize for it.

	Ingo
