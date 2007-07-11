Return-Path: <linux-kernel-owner+w=401wt.eu-S1766001AbXGKVQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766001AbXGKVQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXGKVQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:16:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXGKVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:16:40 -0400
Date: Wed, 11 Jul 2007 23:16:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711211638.GE18767@one.firstfloor.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711174252.GA16793@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Well I spent a lot of time making the x86-64 timing code work
well on a variety of machines; working around a wide variety
of hardware and platform bugs. I obviously don't agree on your description
of its maintenance state. 

> What contribution do we have from you instead? A week before the .23 

I told him my objections privately earlier. Basically i would
like to see an actually debuggable step-by-step change, not a rip everything 
out.

If that isn't possible it needs very careful review which just hasn't
happened yet. But I'm not convinced even step by step is not possible
here.

I thought it was clear that rip everything out is rarely a good idea
in Linux land?  That's really not something I should need to harp on 
repeatedly.

-Andi

