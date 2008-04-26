Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbYDZU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbYDZU0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYDZU01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:26:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760218AbYDZU00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:26:26 -0400
Date: Sat, 26 Apr 2008 22:26:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC git pull] "big box" x86 changes, GART
Message-ID: <20080426202602.GA17640@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426202449.GA17256@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426202449.GA17256@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus, please pull the x86 "big box & GART" subtopic tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-gart.git for-linus
> 
> it also touches drivers/char/agp/amd64-agp.c.

forgot to mention that these changes are pullable standalone, without 
the MM changes. I just test-booted it on a GART box to make sure:

  PCI-DMA: using GART IOMMU.

	Ingo
