Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXLUXUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXLUXUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXLUXUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:20:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47651
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbXLUXUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:20:09 -0500
Date: Fri, 21 Dec 2007 15:20:08 -0800 (PST)
Message-Id: <20071221.152008.11508772.davem@davemloft.net>
To: mingo@elte.hu
Cc: clameter@sgi.com, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rjw@sisk.pl
Subject: Re: Major regression on hackbench with SLUB (more numbers)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071221225413.GA26189@elte.hu>
References: <1198275453.30889.4.camel@lappy>
	<Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	<20071221225413.GA26189@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 21 Dec 2007 23:54:13 +0100

> Really, if your behavior is representative of how our SLAB allocator 
> will be maintained in the future then i'm very, very worried :-(

Actually, to the contrary, I actually think Christoph responds to
every problem I've ever reported to him about his per-cpu counters
work and SLUB much better than most people who call themselves
"maintainers" around here.

And I say that without any reservations.

He doesn't deserve the ad-hominem attacks he is getting today, because
he does resolve every problem reported to him.

The guy wrote test cases, he analyzed every problem, he wrote test
patches, and he doesn't stop doing any of that until the issue really
is reported as resolved by the testers.

I'll take Christoph as the implementor and maintainer of anything, any
day of the week.  He rocks.
