Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbXKQQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbXKQQIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbXKQQIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:08:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50191 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532AbXKQQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:08:06 -0500
Date: Sat, 17 Nov 2007 17:07:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Linux 2.6.24-rc3
Message-ID: <20071117160735.GE3967@elte.hu>
References: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org> <200711171114.16299.rjw@sisk.pl> <20071117021917.eed2f34c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117021917.eed2f34c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > Nothing really exciting. A few things got reverted due to regressions, and
> > > in general hopefully the regression counts are starting to shrink.
> > 
> > Yes, they are.
> > 
> > Speaking of which, would you mind merging the patch at:
> > http://lkml.org/lkml/2007/11/1/246
> > 
> > To my eyes it's a regression fix, but no one has been pushing it upstream.
> 
> There are three patches which affect that kernel function.  One is in 
> git-x86 and the other two are in -mm.  I sent #2 and #3 to Thomas 
> today and he's getting it all sorted out.

FYI, Thomas sent out the git pull request for this (and other) fixes an 
hour ago.

	Ingo
