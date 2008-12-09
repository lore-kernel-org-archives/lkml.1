Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYLILaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYLILaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYLIL3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:29:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36682
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbYLIL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:29:55 -0500
Date: Tue, 09 Dec 2008 03:29:55 -0800 (PST)
Message-Id: <20081209.032955.101042639.davem@davemloft.net>
To: mingo@elte.hu
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       paulus@samba.org
Subject: Re: [patch] Performance Counters for Linux, v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081209112225.GD21618@elte.hu>
References: <20081209110246.GC21618@elte.hu>
	<20081209.031120.90683825.davem@davemloft.net>
	<20081209112225.GD21618@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 9 Dec 2008 12:22:25 +0100

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 9 Dec 2008 12:02:46 +0100
> > 
> > > 
> > > * stephane eranian <eranian@googlemail.com> wrote:
> > > 
> > > > > There's also more generic x86 support: all 4 generic PMCs of Nehalem 
> > > > > / Core i7 are supported - i've run 4 instances of KernelTop and they 
> > > > > used up four separate PMCs.
> > > >
> > > > Core/Atom have 5 counters, Nehalem has 7. Why are you not using all of 
> > > > them already?
> > > 
> > > no, Nehalem has 4 generic purpose PMCs and 3 fixed-purpose PMCs (7 
> > > total),
> >  ...
> > > Saying that it has 7 is misleading.
> > 
> > Even you just did.
> 
> which portion of my point stressing the general purpose attribute was 
> unclear to you?

I'm just teasing you because you picked a trite point from stephane's
email instead of the meat later on, which I would have found more
interesting to hear you comment on.
