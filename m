Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXC0HM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXC0HM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXC0HM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:12:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXC0HM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:12:26 -0400
Date: Tue, 27 Mar 2007 09:11:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: 2.6.21-rc5: maxcpus=1 crash in cpufreq: kernel BUG at drivers/cpufreq/cpufreq.c:82!
Message-ID: <20070327071132.GB23900@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326090439.GA18484@elte.hu> <44408954-D81A-406B-B509-6390969F2F6A@intel.com> <20070326190318.GA11068@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326190318.GA11068@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Ingo,
> 
> Does the patch below help?

> Patch to resolve maxcpus=1 trigerring BUG() as reported by Ingo here

yes, it solves it, thanks!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
