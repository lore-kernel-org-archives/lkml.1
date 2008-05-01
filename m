Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYEAB0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYEAB0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYEAB0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:26:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236AbYEAB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:26:09 -0400
Date: Wed, 30 Apr 2008 18:25:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501005727.GO29330@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804301821380.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
 <20080430154124.7ec08dd4.akpm@linux-foundation.org> <20080501005727.GO29330@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Adrian Bunk wrote:
> 
> One big problem I see is Linus wanting to merge all drivers regardless 
> of the quality.

That's not what I said.

What I said was that I think we get *better* quality by merging early.

In other words, you're turning the whole argument on its head, and 
incorrectly so.

I claim that you are the one that is arguing for *worse* quality, by 
arguing for a process that is KNOWN to tend to generate bad code 
(out-of-tree drivers) as opposed to one that tends to fix things over time 
(and note the "tends" in both cases - there are counter-examples, but 
the trend is so clear that anybody who disputes it would seem to be either 
blind or lying).

So here's my challenge: give me *one* reason to believe that quality 
improves more out-of-tree than it does in-tree, and then you'll have a 
point. But you'd better be able to explain the ton of historical data we 
have that proves otherwise.

Until you do that, your blathering is just that - total blathering. The 
process I advocate is the one that has historical data on its side. Yours 
is just a failed theory.

			Linus
