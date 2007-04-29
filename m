Return-Path: <linux-kernel-owner+w=401wt.eu-S1031341AbXD2Wb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031341AbXD2Wb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031289AbXD2WbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:31:25 -0400
Received: from www.osadl.org ([213.239.205.134]:50796 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031341AbXD2WbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:31:24 -0400
Subject: Re: Linux 2.6.21
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070429221958.GX3468@stusta.de>
References: <20070429173500.GA30248@one.firstfloor.org>
	 <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
	 <20070429180909.GA30604@one.firstfloor.org>
	 <20070429214007.9ea12e96.diegocg@gmail.com>
	 <20070429201729.GQ3468@stusta.de>
	 <20070429225657.a501ab5a.diegocg@gmail.com>
	 <20070429211028.GT3468@stusta.de>
	 <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com>
	 <20070429212128.GU3468@stusta.de>
	 <1177883521.5791.156.camel@localhost.localdomain>
	 <20070429221958.GX3468@stusta.de>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 00:33:30 +0200
Message-Id: <1177886010.5791.166.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 00:19 +0200, Adrian Bunk wrote:
> > Don't be silly, did any of the developers say, that he has spare time to
> > read your regression lists ?
> 
> It worked because several people (including Linus) emphasized that 
> fixing regressions from this list was important.

Right. Simply because these lists are assembled by someone

- who knows how to pick that reports from the mailinglists
- who knows how to sort them in a useful way
- who knows how to add the relevant folks on CC
- ....

Can you see the pattern ?

> And it failed because many regressions still stayed unfixed and some 
> even undebugged.

No it failed not. It is not perfect. Way more bugs, which have been
fixed or are in the debugging process, would have been unnoticed and
ignored otherwise.

> > So what are you complaining about ? Folks stepped up and built a
> > regression list and posted it to LKML. What's wrong with that ?
> 
> If it works it's perfectly fine.

It will work not much different from your lists. It'll be not perfect
either.

	tglx


