Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXA2UIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXA2UIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXA2UIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:08:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXA2UIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:08:17 -0500
Date: Mon, 29 Jan 2007 21:06:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070129200648.GA26694@elte.hu>
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org> <20070129190806.GA14353@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129190806.GA14353@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Here are the numbers that i think changes the picture:

i forgot to explain them:

current (estimated) total installed base of 32-bit (i686) Fedora:

>  http://www.fedoraproject.org/awstats/stats/updates-released-fc6-i386.total

current (estimated) total installed base of 64-bit (x86_64) Fedora:

>  http://www.fedoraproject.org/awstats/stats/updates-released-fc6-x86_64.total

current (estimated) total installed base of PPC(64) Fedora:

>  http://www.fedoraproject.org/awstats/stats/updates-released-fc6-ppc.total

these are updated daily i think. The counters started late October 2006, 
when FC6 was released.

	Ingo
