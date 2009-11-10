Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZKJSGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZKJSGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZKJSGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:06:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZKJSGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:06:32 -0500
Date: Tue, 10 Nov 2009 19:06:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110180617.GA25017@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <20091110042032.GD29454@elte.hu>
 <1257863432.4184.223.camel@mulgrave.site>
 <20091110172202.GB25581@elte.hu>
 <alpine.LFD.2.01.0911100952480.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911100952480.31845@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 10 Nov 2009, Ingo Molnar wrote:
> > 
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > Can you give me the commit id in your tree so I can run a few tests?
> > 
> > Let me re-quote what you quoted above:
> > 
> > > > > > I've attached the full commit below. [...]
> 
> Let me re-quote James:
> 
>  "Can you give me the commit id in your tree so I can run a few tests?"
> 
> He wanted the tree. So that he can run tests on his machinery. His 
> machinery that does _not_ take some emailed commit description, but 
> works on git trees.
> 
> So Ingo, if you want to be snarky about quoting people, at least be 
> snarky with a reason.

The commit i quoted had the commit ID on its first line (i did that so 
because i anticipated someone wanting to check my tree), but here it is 
again plus the (well-known to James) URI of the -tip tree:

  > From eae0c9dfb534cb3449888b9601228efa6480fdb5 Mon Sep 17 00:00:00 2001

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

Thanks,

	Ingo
