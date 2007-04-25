Return-Path: <linux-kernel-owner+w=401wt.eu-S2993089AbXDYU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993089AbXDYU0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993094AbXDYU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:26:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993089AbXDYU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:26:17 -0400
Date: Wed, 25 Apr 2007 13:24:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Adrian Bunk <bunk@stusta.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <200704252220.57792.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704251323000.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070425192512.GZ3468@stusta.de>
 <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
 <200704252220.57792.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Rafael J. Wysocki wrote:
> 
> Please ask anyone who's worked with me if he's had any problem with that.
> If anyone say I'm unable to work with anybody else, I'd say you're right.  Till
> then, I feel offended.

I'll apologise (and virtually kiss your hairy feet) if you could actually 
show me a single implementation that people can agree on.

But until then, I claim that the suspend-to-disk people cannot work with 
each other.

And no, "three different implementations" doesn't cut it. Even _two_ is 
too much. We need to get *rid* of something, not add more.

		Linus
