Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbXKNRih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbXKNRih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbXKNRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:38:25 -0500
Received: from xenotime.net ([66.160.160.81]:49485 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755852AbXKNRiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:38:23 -0500
Date: Wed, 14 Nov 2007 09:38:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071114093820.ff3ad8f9.rdunlap@xenotime.net>
In-Reply-To: <20071114140847.GA11489@elte.hu>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<20071113.033946.114918709.davem@davemloft.net>
	<20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
	<20071113041259.79c9a8c5.akpm@linux-foundation.org>
	<20071113134029.GA30978@elte.hu>
	<20071113085514.3414aa52.rdunlap@xenotime.net>
	<20071114140847.GA11489@elte.hu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 15:08:47 +0100 Ingo Molnar wrote:

> 
> * Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > > (and this is in no way directed at the networking folks - it holds 
> > > for all of us. I have one main complaint about networking: the 
> > > separate netdev list is a bad idea - networking regressions should 
> > > be discussed and fixed on lkml, like most other subsystems are. Any 
> > > artificial split of the lk discussion space is bad.)
> > 
> > but here I disagree.  LKML is already too busy and noisy. Major 
> > subsystems need their own discussion areas.
> 
> That's a stupid argument. We lose much more by forced isolation of 
> discussion than what we win by having less traffic! It's _MUCH_ easier 
> to narrow down information (by filter by threads, by topics, by people, 
> etc.) than it is to gobble information together from various fractured 
> sources. We learned it _again and again_ that isolation of kernel 
> discussions causes bad things.
> 
> In fact this thread is the very example: David points out that on netdev 
> some of those bugs were already discussed and resolved. Had it been all 
> on lkml we'd all be aware of it.

or had <someone> been on netdev.

> this is a single kernel project that is released together as one 
> codebase, so a central place of discussion is obvious and common-sense.

Central doesn't have to mean one-and-only-one-list-for-everything.

> so please stop this "too busy and too noisy" nonsense already. It was 
> nonsense 10 years ago and it's nonsense today. In 10 years the kernel 
> grew from a 1 million lines codebase to an 8 million lines codebase, so 
> what? Deal with it and be intelligent about filtering your information 
> influx instead of imposing a hard pre-filtering criteria that restricts 
> intelligent processing of information.

So you have a preferred method of handling email.  Please don't
force it on the rest of us.

I'll plan to use lkml-list-only when you have convinced DaveM to drop
all of the other mailing lists at vger.kernel.org.  Yeah, sure.

---
~Randy
