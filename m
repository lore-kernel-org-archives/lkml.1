Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZAKSD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZAKSD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZAKSDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:03:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZAKSDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:03:18 -0500
Date: Sun, 11 Jan 2009 19:03:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Rolland <rol@witbe.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc1
Message-ID: <20090111180306.GA15326@elte.hu>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain> <20090111185547.0200a264@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111185547.0200a264@tux.DEF.witbe.net>
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


* Paul Rolland <rol@witbe.net> wrote:

> Hello,
> 
> On Sat, 10 Jan 2009 16:13:02 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > The merge window is over, and while it is quite possible that I missed a 
> > few merge requests in the crazy week that is behind us, apart from those 
> > we should now have most of the bulk of 2.6.29 merged up. And now it's
> > just a small matter of making sure it's all stable and ready to go.
> 
> Compiz is now refusing to run, and says :
> Jan 11 11:22:47 tux kernel: compiz:3330 map pfn expected mapping type
>  write-back for d0040000-d0a40000, got uncached-minus

Do the fixes in tip/master fix it for you?

   http://people.redhat.com/mingo/tip.git/README

I have sent the pull request for those to Linus today.

	Ingo
