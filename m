Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYLaGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYLaGtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 01:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYLaGtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 01:49:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYLaGtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 01:49:05 -0500
Date: Wed, 31 Dec 2008 07:48:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq fixes
Message-ID: <20081231064840.GA25405@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <20081228231025.GA31953@elte.hu> <20081229125242.GA22678@elte.hu> <alpine.LFD.2.00.0812301622180.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812301622180.3082@localhost.localdomain>
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

> 
> 
> On Mon, 29 Dec 2008, Ingo Molnar wrote:
> > 
> > Please pull the latest irq-fixes-for-linus-4 git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus-4
> > 
> > [ shortlog is relative to irq-core-for-linus - can be pulled in any order. ]
> 
> There is no branch of that name:
> 
> 	fatal: Couldn't find remote ref irq-fixes-for-linus-4
> 
> maybe you forgot to push it out?

yes - sorry! I have pushed it out now.

	Ingo
