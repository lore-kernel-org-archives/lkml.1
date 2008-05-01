Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbYEAPaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbYEAPaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbYEAPaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:30:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35975 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbYEAPaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:30:07 -0400
Subject: Re: Slow DOWN, please!!!
From: Kasper Sandberg <lkml@metanurb.dk>
To: David Newall <davidn@davidnewall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <481947AF.4090101@davidnewall.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	 <4817EF91.4080800@davidnewall.com>
	 <20080429.211835.130816277.davem@davemloft.net>
	 <48186E57.5070805@davidnewall.com>
	 <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
	 <4818B8A7.4000902@davidnewall.com>
	 <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
	 <4818C0BF.5020002@davidnewall.com>
	 <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org>
	 <4818C571.8040609@davidnewall.com>
	 <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
	 <481947AF.4090101@davidnewall.com>
Content-Type: text/plain
Date: Thu, 01 May 2008 17:28:20 +0200
Message-Id: <1209655700.27499.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 14:01 +0930, David Newall wrote:
<snip>
> 
> Linus Torvalds also wrote:
> > You complain how I don't release kernels that 
> > are stable, but without any suggestions on what the issue might be
> 
> You do release kernels that are unstable, and you call them "stable",
> but I'm sure I said that inadequate review and testing are causes, which
> I think counts as a suggestion on what the issue might be. It's been a
> repeating theme in this thread, and I'm talking about what everybody
> else is saying, not what I'm saying, so again, you know that I'm not
> making this up.

this is kindof bullshit, You can never be sure that something works
perfectly for everyone, if there were to be so excessive testing that
you would be willing to make such a bold claim, any "stable" kernel
would be years in testing.. Linux stability also seems to be okay, and
people who wants to lower risk of problems can simply choose to use
slightly older versions.

What i find more of a problem is long term effects and problems of
changes.

For instance, Linux has slowly and steadily been getting alot more
sensitive to IO, and ALOT more memory hungry..

I Recently found a system with a 2.6.4 kernel, and when i upgraded to
2.6.23, i saw memory usage increase from ~250mb to around 500. I
upgraded to .25 to see if it was some weird bug, but it is the same.

Unfortunately i cannot investigate more, as i only had the box for a
very short time, but this is alot more concerning to me.

Unfortunately i dont think i can easily reproduce this as i am unsure
how to actually get to test 2.6.0 through .24 easily..

> 
> Stop telling the world that 2.6.25 is ready for them when you know it's
> not. It's now ready for beta testing, and no more. Is 2.6.24 ready for
> the world yet? There are still problems being reported with it.
> 
> 

Well.. its doing a quite nice job on my new workstation :)

<snip>

