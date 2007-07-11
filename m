Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbXGKVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbXGKVqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXGKVqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:46:47 -0400
Received: from www.osadl.org ([213.239.205.134]:59419 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751772AbXGKVqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:46:46 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070711211638.GE18767@one.firstfloor.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <20070711211638.GE18767@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 23:46:41 +0200
Message-Id: <1184190401.12353.152.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, 2007-07-11 at 23:16 +0200, Andi Kleen wrote: 
> > What contribution do we have from you instead? A week before the .23 
> 
> I told him my objections privately earlier. Basically i would
> like to see an actually debuggable step-by-step change, not a rip everything 
> out.

You promised privately to do a thorough review as well, which I'm still
waiting for since months.

> If that isn't possible it needs very careful review which just hasn't
> happened yet. But I'm not convinced even step by step is not possible
> here.

There is no step by step thing. You convert an arch to clock events or
you convert it not.

> I thought it was clear that rip everything out is rarely a good idea
> in Linux land?  That's really not something I should need to harp on 
> repeatedly.

If you have technical objections, put them on the table. Point by point.

All I heard so far from you are platitudes, which are not worth the
electrons to transport them.

	tglx


