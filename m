Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZACWiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZACWiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZACWh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:37:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZACWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:37:57 -0500
Date: Sat, 3 Jan 2009 23:37:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] cpus4096 tree, part 3
Message-ID: <20090103223723.GA17047@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu> <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain> <20090103203621.GA2491@elte.hu> <20090103213856.GA24138@elte.hu> <alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> What happened to Nick's cleanup patch to do_page_fault (a month or two 
> ago? I complained about some of the issues in his first version and 
> asked for some further cleanups, but I think that whole discussion ended 
> with him saying "I am going to add those changes that you suggested (in 
> fact, I already have)".
> 
> And then I didn't see anything further. Maybe I just missed the end 
> result. Or maybe we have it in some -mm branch or something?

they would have been in tip/x86/mm and would be upstream now had Nick 
re-sent a v2 series but that never happened. I think they might have 
fallen victim to a serious attention deficit caused by the SLQB patch ;-)

	Ingo
