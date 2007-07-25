Return-Path: <linux-kernel-owner+w=401wt.eu-S933432AbXGYQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbXGYQIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbXGYQIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:08:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760634AbXGYQIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:08:04 -0400
Date: Wed, 25 Jul 2007 18:07:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kacper Wysocki <kacperw@online.no>
Cc: Rene Herman <rene.herman@gmail.com>, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Valdis.Kletnieks@vt.edu,
       Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org,
       Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: howto get a patch merged (WAS: Re: -mm merge plans for 2.6.23)
Message-ID: <20070725160743.GB8284@elte.hu>
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
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


* Kacper Wysocki <kacperw@online.no> wrote:

> [snip howto get a patch merged]

> > But a "here is a solution, take it or leave it" approach, before 
> > having communicated the problem to the maintainer and before having 
> > debugged the problem is the wrong way around. It might still work 
> > out fine if the solution is correct (especially if the patch is 
> > small and obvious), but if there are any non-trivial tradeoffs 
> > involved, or if nontrivial amount of code is involved, you might see 
> > your patch at the end of a really long (and constantly growing) 
> > waiting list of patches.
> 
> Is that what happened with swap prefetch these two years? The approach 
> has been wrong?

i dont know - but one of the maintainers of the code (Nick) says that he 
asked for but did not get debug feedback:

> > > And yet despite my repeated pleas, none of those people has yet 
> > > spent a bit of time with me to help analyse what is happening.

Con, the maintainer of -ck, certainly has (or had, when he maintained 
it) enough clout to coordinate such an effort between non-developer -ck 
users and the MM maintainers. Maybe he attempted to do that and has 
tried to provide debug feedback to MM maintainers?

	Ingo
