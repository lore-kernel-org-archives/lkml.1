Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbYDVVrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbYDVVrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbYDVVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:47:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558AbYDVVrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:47:35 -0400
Date: Tue, 22 Apr 2008 14:47:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
In-Reply-To: <20080422213621.GC21435@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0804221443140.2779@woody.linux-foundation.org>
References: <1208895950.24124.9.camel@brick> <20080422203334.GA9809@flint.arm.linux.org.uk> <alpine.LFD.1.10.0804221359360.2779@woody.linux-foundation.org> <20080422213621.GC21435@flint.arm.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Russell King wrote:
> 
> To be really frank, I'm beginning to wonder whether using git is such
> a good idea - at least if I was sending you a stream of patches then
> all I'd needed to have done was forward you the relevant patches as
> fixes to the previous set - and I wouldn't care whether you'd applied
> the previous set at that point.
> 
> But with git, it has to be known what you're doing at your end before
> I can make a decision about how to fix issues at my end.

I really don't see what you are talking about, and nobody else has that 
problem.

With patches, once you send them, they are sent, and you can't fix it.

With git, once you send my the "please pull", it's sent, and you can't fix 
it.

And with either, you can update the queue later. I don't understand AT ALL 
why you think they are different.

In fact, if anything, git trees are a lot more flexible. With git, what 
you can do is fix up the tree at any time, and send me an email saying 
"ok, if you already pulled it's too late, but if you didn't, the tree is 
now fixed". That you can't do with patches, because once you've sent them 
out they are out of your control.

But with both git and patches you can *always* just append on top of the 
previous set. Just send me a new set of patches (with git, that obviously 
means just sending me a new pull-request with updated information).

This is what everybody else does, it's not even unusual.

		Linus
