Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYFFIuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYFFIuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYFFIuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:50:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53105 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbYFFIuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:50:06 -0400
Date: Fri, 6 Jun 2008 10:49:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606084949.GA28190@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au> <20080605195604.41623687.akpm@linux-foundation.org> <20080606071707.GB9708@elte.hu> <20080606072536.GA19334@elte.hu> <20080606003327.9ac0e91b.akpm@linux-foundation.org> <20080606074137.GA28962@elte.hu> <20080606004743.a78180c3.akpm@linux-foundation.org> <20080606082325.GA10826@elte.hu> <20080606013835.8dfd838b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606013835.8dfd838b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > most of the -tip topics (there are 75 of them currently) are present 
> > in linux-next - about ~70% of all -tip commits are in linux-next 
> > already. The stuff that is not in linux-next yet is either because 
> > it's: miscellany fixes (i.e. intentionally grabbed out-of-tree to 
> > make our tests work better), not cooked enough yet, or because we 
> > are still working it out - tip is less than a month old still.
> > 
> > in general the rule is that if there's anything we want to push 
> > upstream, it will show up in linux-next.
> 
> I don't think it's a good idea for you guys to be off working on 
> 2.6.28 material when we're trying to stabilise 2.6.25, 2.6.26 and 
> preparing for 2.6.27.
> 
> What's especially regrettable is that, afaik, you are expending 
> testing resources on a tree which nobody will ever run rather than 
> upon the tree which everyone _will_ run :( [...]

what do you mean? We are testing commits that everybody will run and are 
pre-filtering them for sanity and stability before they hit linux-next.

	Ingo
