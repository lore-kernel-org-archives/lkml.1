Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZF2HPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZF2HPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZF2HPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:15:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbZF2HPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:15:11 -0400
Date: Mon, 29 Jun 2009 09:14:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfi-devel@simplefirmware.org,
       x86@kernel.org
Subject: Re: linux-next: Tree for June 19
Message-ID: <20090629071451.GA20225@elte.hu>
References: <20090619172622.05adb236.sfr@canb.auug.org.au> <alpine.LFD.2.00.0906200012200.4325@localhost.localdomain> <20090620150433.4e038676.sfr@canb.auug.org.au> <alpine.LFD.2.00.0906201415400.4083@localhost.localdomain> <20090622015427.c749a0d9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622015427.c749a0d9.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > > Basically, this should be just what you would send to Linus 
> > > (or ask him to fetch).  It is allowed to be rebased if you 
> > > deem it necessary.
> > 
> > The patches are tested on the pre-release platform that makes 
> > use of them.  There have been several internal reviews and 
> > re-writes, but since we just got permission to release the 
> > patches last week, they've not been publically vetted yet.
> > 
> > The content is quite close to what I plan to propose for 
> > upstream, but the format is not.  I'll be re-factoring the 
> > series into "clean history" and senting them to LKML on Sunday 
> > night.
> > 
> > I don't expect much comment on the generic part, but will want 
> > x86 maintainers to buy into the parts that touch their 
> > architecture.
> 
> OK, then I think I need to hear from the x86 maintainers, at 
> least, before we include this.

Yep, feel free, the SFI bits looked good in principle.

	Ingo
