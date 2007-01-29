Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXA2Iuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXA2Iuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXA2Iuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:50:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXA2Iuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:50:50 -0500
Date: Mon, 29 Jan 2007 09:45:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Duncan <1i5t5.duncan@cox.net>, Neil Brown <neilb@suse.de>,
       mingo@redhat.com, linux-raid@vger.kernel.org,
       Dave Jones <davej@redhat.com>, cpufreq@lists.linux.org.uk,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       Jan Altenberg <jan@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Andrew Clayton <andrew@digital-domain.net>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.20-rc6: known regressions with patches
Message-ID: <20070129084548.GA10578@elte.hu>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070126181853.GO17836@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126181853.GO17836@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.7 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0247]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : ACPI: fix cpufreq regression
> References : http://lkml.org/lkml/2007/1/16/120
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Caused-By  : Dave Jones <davej@redhat.com>
>              commit 0916bd3ebb7cefdd0f432e8491abe24f4b5a101e
> Handled-By : Ingo Molnar <mingo@elte.hu>
> Patch      : http://lkml.org/lkml/2007/1/16/120
> Status     : patch available

this is commit e4233dec749a3519069d9390561b5636a75c7579 meanwhile.

	Ingo
