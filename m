Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbXCXPHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbXCXPHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXCXPHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:07:01 -0400
Received: from www.osadl.org ([213.239.205.134]:40470 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752680AbXCXPHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:07:00 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <6bffcb0e0703240659r2e5a5875i746ccbbd28d0045c@mail.gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174680500.10840.346.camel@localhost.localdomain>
	 <6bffcb0e0703240659r2e5a5875i746ccbbd28d0045c@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 16:14:26 +0100
Message-Id: <1174749266.10840.430.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-24 at 14:59 +0100, Michal Piotrowski wrote:
> On 23/03/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> > > Subject    : soft lockup detected on CPU#0
> > > References : http://lkml.org/lkml/2007/3/3/152
> > > Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> > > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > >              Ingo Molnar <mingo@elte.hu>
> > > Status     : unknown
> >
> > Michal,
> >
> > any news on that one ?
> >
> > You said the same problem exists in 2.6.20.1. Has this been resolved in
> > 2.6.20.2/3
> 
> Yes, I tried 2.6.20.4 and it works fine.

Is it solved in Linus latest too ?

	tglx


