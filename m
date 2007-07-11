Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXGKWFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXGKWFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763928AbXGKWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:04:53 -0400
Received: from www.osadl.org ([213.239.205.134]:51124 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763750AbXGKWEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:04:51 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 00:04:48 +0200
Message-Id: <1184191488.12353.160.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Wed, 2007-07-11 at 14:42 -0700, Linus Torvalds wrote: 
> Here's a big clue: it doesn't matter one _whit_ how much face-slapping you 
> get, or how much effort some programmers have put into the code. It's 
> untested. And no, we are *not* going to do another "rip everything out, 
> and replace it with new code" again.
> 
> Over my dead body.
>
> We're going to do this thing gradually, or not at all.

Can you please shed some light on me, how exactly you switch an
architecture gradually to clock events.

You simply can not convert PIT today and the HPET next week followed by
the local APIC in three month. 

At least not to my knowledge.

> And if somebody feels slighted by the face-slap, and thinks he has already 
> done enough, and isn't interested in doing it gradually, then good 
> riddance. The "not at all" seems like a good idea, and maybe we can 
> re-visit this in a year or two.

I have no problem to brew this for some more time. I got not repulsed by
the 2.6.20 decision, but I have no clue how to communicate with a black
hole.

	tglx


