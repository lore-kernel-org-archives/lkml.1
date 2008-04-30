Return-Path: <linux-kernel-owner+w=401wt.eu-S1763269AbYD3Owu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269AbYD3Owu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761581AbYD3OwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:52:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761854AbYD3OwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:52:13 -0400
Date: Wed, 30 Apr 2008 07:51:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Newall <davidn@davidnewall.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <48186E57.5070805@davidnewall.com>
Message-ID: <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, David Newall wrote:
> 
> I don't claim BSD to be perfect, but it appears to have a consistently
> good quality.

Lol. You should try VMS. Now *there* was a stable system.

Oh, but it didn't actually make any progress, did it?

The fact is, we're merging a lot. It comes from having a lot of 
development. If you don't want that, then you're a fool - because you 
aren't looking at the long term.

>  Old Linux kernels also have that; new ones not so.

Can you point to any actual stability problem?

The problem under discussion is the fact that some people are unhappy 
because we had some merge trouble. The fact is, the problems got fixed in 
a few days. And yes, we will probably will have to make Ingo follow the 
rules that pretty much everybody else also follows, and no, it's not going 
to solve all problems either - the fundamental issue is that we are just 
too damn good at development.

And that's not a big problem in my view, as long as we are also also able 
to handle the _result_ of that flood of patches. Which, quite frankly, we 
are.

DavidN, you just have an agenda, and you think that mentioning BSD as some 
kind of shining example of goodness is a good way to reach that agenda. It 
isn't. It just shows that you don't understand the issue, and that you 
think that "threatening" developers by saying you'll switch is a great way 
to make PR.

But you know what? I really don't care one _whit_ what you do. You can 
switch to Vista for all I care, and I really don't mind. All I care about 
is doing a good job technically. 

And you just show that you don't have a clue what you are talking about. 
If you want stable kernel, don't follow the current -git tree. Don't mind 
the fact that in two weeks we merge 

	 6672 files changed, 373817 insertions(+), 285901 deletions(-)

and instead look at something like the enterprise kernels or other tree 
that lags the development tree by half a year or more exactly _because_ 
they care about stable, not development.

In short: what do you think the git tree is? Is it something that should 
prioritize good developmnent, or is it something that should worry about 
you making inane arguments? Ask yourself that.

			Linus

