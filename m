Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYEHPly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYEHPly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYEHPlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:41:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbYEHPll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:41:41 -0400
Date: Thu, 8 May 2008 17:41:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080508154116.GA17338@elte.hu>
References: <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080508153343.GD7718@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508153343.GD7718@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> Can we get that verified and the description updated before it hits 
> Linus' tree?

that's not needed. Mike's fix is correct, regardless of whether it fixes 
the other regression or not.

> Otherwise this "could be related" will become unchangable metadata 
> that will stay forever - no matter whether there's any relation at 
> all.

... and the problem with that is exactly what?

	Ingo
