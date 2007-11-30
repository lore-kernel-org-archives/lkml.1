Return-Path: <linux-kernel-owner+w=401wt.eu-S934845AbXK3NoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbXK3NoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXK3NoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:44:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbXK3NoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:44:04 -0500
Date: Fri, 30 Nov 2007 14:43:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: J?rn Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071130134312.GA32273@elte.hu>
References: <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130133546.GB29679@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > sorry, wrong URLs, the correct links are:
> > > 
> > >    http://redhat.com/~mingo/latency-tracing-patches/latency-tracer-v2.6.24-rc2-git5-combo.patch
> > >    http://redhat.com/~mingo/latency-tracing-patches/trace-cmd.c
> > 
> > Don't seem to work with plain 2.6.23:

could you try this updated version:

  http://redhat.com/~mingo/latency-tracing-patches/latency-tracing-v2.6.24-rc3.combo.patch

does it work any better?

	Ingo
