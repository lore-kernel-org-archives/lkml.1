Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbXLCQqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbXLCQqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXLCQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:45:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXLCQpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:45:45 -0500
Date: Mon, 3 Dec 2007 17:45:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Markus Metzger <markus.t.metzger@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071203164506.GA16135@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com> <200712031721.39013.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712031721.39013.ak@suse.de>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Just don't wait for that. utrace doesn't seem to have any concrete 
> plans to merge any time soon AFAIK[1] and it would be a shame to delay 
> an useful feature forever.
> 
> [1] At least the patches have not reached any mailing lists

FYI, as far as arch/x86 goes, the merging of Roland's utrace preparatory 
patches is well underway in x86.git, and the merge went pretty well so 
far, with robust results. It's 49 patches so far:

 54 files changed, 2440 insertions(+), 2587 deletions(-)

	Ingo
