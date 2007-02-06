Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXBFWPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXBFWPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXBFWPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:15:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573AbXBFWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:15:21 -0500
Date: Tue, 6 Feb 2007 23:15:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make kernel/time/timer_stats.c:nr_entries static
Message-ID: <20070206221513.GC5109@elte.hu>
References: <20070129001207.71ea3470.akpm@osdl.org> <20070206221304.GL27397@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206221304.GL27397@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> On Mon, Jan 29, 2007 at 12:12:07AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-rc6-mm1:
> >...
> > +add-debugging-feature-proc-timer_stat.patch
> >...
> >  New hrtimers/dynticks patches
> >...
> 
> 
> nr_entries can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

thanks,

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
