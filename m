Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbYHRHYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbYHRHYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYHRHYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:24:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYHRHYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:24:45 -0400
Date: Mon, 18 Aug 2008 09:24:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
       macro@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] -tip/apic merging one more series
Message-ID: <20080818072432.GA6204@elte.hu>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com> <86802c440808171453i2869a7f3x1db27307dbec4db7@mail.gmail.com> <aa79d98a0808172122sfab2336ldfcccc88e4316712@mail.gmail.com> <20080818071820.GB17961@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818071820.GB17961@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Oh...indeed. Thanks Yinghai! - will fix it today evening.
> > Ingo drop this patch please (if it was applied).
> 
> hm, none of these patches has lapic_resume mentioned and current 
> tip/master's version doesnt seem broken so there's nothing to drop.

ah, i see Yinghai's fix. I'll apply that to tip/x86/apic.

	Ingo
