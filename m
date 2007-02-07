Return-Path: <linux-kernel-owner+w=401wt.eu-S1422712AbXBGTeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422712AbXBGTeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422704AbXBGTeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:34:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbXBGTeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:34:06 -0500
Date: Wed, 7 Feb 2007 20:33:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tilman Schmidt <tilman@imap.cc>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org
Subject: Re: dynticks + iptables almost stops the boot process [was: Re: 2.6.20-rc6-mm3]
Message-ID: <20070207193319.GA6960@elte.hu>
References: <20070201211137.GA2830@inferi.kami.home> <1170369202.29240.339.camel@localhost.localdomain> <20070202191802.GA4262@inferi.kami.home> <1170448034.29240.364.camel@localhost.localdomain> <20070202204344.GB4262@inferi.kami.home> <20070206164826.GA3491@elte.hu> <20070206192840.GB2971@inferi.kami.home> <45C90B57.90104@imap.cc> <1170803853.3785.45.camel@chaos> <20070206170157.114f0e65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206170157.114f0e65.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2306]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 07 Feb 2007 00:17:33 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Wed, 2007-02-07 at 00:12 +0100, Tilman Schmidt wrote:
> > > > No, not this. Anyway the last patch Thomas forwarded does fix the
> > > > problem.
> > > 
> > > Which one would that be? I might try it for comparison.
> > 
> > Find the combined patch of all fixlets on top of -mm3 below.
> 
> err, I don't have most of this.
> 
> I just uploaded the crappile-of-the-moment to
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-06-16-59.tar.gz

hm:

 ERROR 404: Not Found.

pls. do:

ssh master.kernel.org chmod a+r /pub/linux/kernel/people/akpm/mm/broken-out-2007-02-06-16-59.tar.gz

	Ingo
