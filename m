Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbYFQVwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbYFQVwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYFQVvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:51:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34603
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753391AbYFQVvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:51:52 -0400
Date: Tue, 17 Jun 2008 14:51:53 -0700 (PDT)
Message-Id: <20080617.145153.229833994.davem@davemloft.net>
To: mingo@elte.hu
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com,
       gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080617153356.GA3510@elte.hu>
References: <20080617092023.GA20621@elte.hu>
	<20080617.022652.76635616.davem@davemloft.net>
	<20080617153356.GA3510@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Jun 2008 17:33:56 +0200

> v2.6.24 was no doubt a huge step in the right direction but it came too 
> late and we are still suffering from the fallout today as we have not 
> reached test cycle equilibrium yet: by the time mainline gets the 
> patches a new large batch comes up, invalidating much of mainline's role 
> and forcing distros to gamble with (much untested and thus detached from 
> reality) experimental branches.
> 
> That's my main point: when we mess up and dont merge OSS driver code 
> that was out there in time - and we messed up big time with wireless - 
> we should admit the screwup and swallow the bitter pill.

Your point seems to be that, even though we've acknowledged and
entirely corrected the problem now, you still will whack us over the
head and complain because it took in your opinion too long to get to
that point.

How nice.  That makes the wireless folks feel great I imagine.

You also have no idea what infrastructure or other invasive wireless
subsystem changes might have been necessary to merge in some of those
drivers.  Of course, that doesn't suit your goal of making the
wireless folks look like a bunch of incompetant twits, so it doesn't
surprise me that you haven't investigated any such facts.

It is impossible, therefore, to please you since we cannot change the
past.  So all we can do at this point is continue doing the right
thing and completely ignore your pointless whines.

In this context your complaints are beyond unfair and beyond
pointless, therefore you're finally in my kill file now, have a nice
day Ingo.
