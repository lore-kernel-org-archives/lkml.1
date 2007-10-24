Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXJXMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXJXMES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbXJXMEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:04:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXJXMEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:04:05 -0400
Date: Wed, 24 Oct 2007 14:03:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates
Message-ID: <20071024120346.GA21535@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024113043.GA11897@elte.hu> <471F311D.8010302@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F311D.8010302@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.2
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.2 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7-deb
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
> >Linus, please pull the latest x86 git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> >
> >it contains two build fixes and an oops-printout-ugliness fix.
> 
> Any chance you can kill the warnings that appear on !CONFIG_SMP, 
> !LOCAL_APIC ?  :)
> 
> http://marc.info/?l=linux-kernel&m=119317911305274&w=2
> http://marc.info/?l=linux-kernel&m=119317911105258&w=2

thx, i have picked them up. Please keep the warnings fixes coming, they 
are much appreciated! I've missed real kernel bugs due to compiler noise 
way too many times.

	Ingo
