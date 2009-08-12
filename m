Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZHLOR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZHLOR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZHLOR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:17:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZHLOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:17:58 -0400
Date: Wed, 12 Aug 2009 16:17:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090812141729.GA29270@elte.hu>
References: <20090812105106.GA7885@elte.hu> <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org>
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


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 12 Aug 2009, Ingo Molnar wrote:
> 
> > > And here I was thinking kerneldoc doesn't actually work 
> > > like that, but perhaps Randy fixed it so the initial 
> > > description can line-wrap?
> 
> Yes, that's what I thought too.  If kerneldoc has been fixed then the 
> description line certainly should get wrapped.
> 
> On Wed, 12 Aug 2009, Ingo Molnar wrote:
> 
> > Looks good - a small nit: please use proper/consistent line length,
> > something like:
> 
> > Ah, the main changes i did were to the body, that is what 
> > caught my eyes.
> 
> Point taken.  Would you like me to reformat the body text and 
> resubmit the patch?

Yeah, please do if you've got the time.

	Ingo
