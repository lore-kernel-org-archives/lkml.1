Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbYAaSjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbYAaSjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYAaSjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:39:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYAaSjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:39:03 -0500
Date: Thu, 31 Jan 2008 19:38:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, wli@holomorphy.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       sparclinux@vger.kernel.org
Subject: Re: sparc compile error caused by x86 arch updates
Message-ID: <20080131183839.GA6344@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu> <20080131162920.GE19700@cs181133002.pp.htv.fi> <47A1FC6D.6090305@goop.org> <20080131174331.GA11881@elte.hu> <20080131182108.GI19700@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131182108.GI19700@cs181133002.pp.htv.fi>
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

> > Adrian, could you please check whether latest x86.git:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> > 
> > resolves the Sparc build failure you were seeing? All known issues 
> > are fixed in it. (let me know if you know about more)
> 
> Compiles here on sparc.

thanks Adrian.

	Ingo
