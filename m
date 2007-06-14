Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXFNRhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXFNRhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXFNRhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:37:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbXFNRhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:37:02 -0400
Date: Thu, 14 Jun 2007 10:36:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sean <seanlkml@sympatico.ca>
cc: Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070614131409.9a5800dc.seanlkml@sympatico.ca>
Message-ID: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net>
 <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
 <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <20070614131409.9a5800dc.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Sean wrote:
> 
> If you really believe that then why didn't you choose a BSD license
> for Linux? 

Because I think the GPLv2 is a great license.

And I don't like the FSF's radical world-view, but I am able to separate 
the license (the GPLv2) from the author and source of the license (rms and 
the FSF).

Why do people always confuse the two? The GPLv2 stands on its own. The 
fact that I disagree with the FSF on how to act has _zero_ relevance for 
my choice of license. 

The BSD license, as far as I'm concerned, is _horrible_ for any project I 
would use. I have actually released code under it, but never a "project". 
I've given some code of mine that I don't care about that much to the BSD 
projects, just because I didn't think that code really mattered, and I 
thought it would be stupid and small-minded not to let the BSD's use it.

But for a project I actually care about, I would never choose the BSD 
license. The license doesn't encode my fundamental beliefs of "fairness". 
I think the BSD license encourages a "everybody for himself" mentality, 
and doesn't encourage people to work together, and to merge.

Let me put this in source management terms, since I've also been working 
on a source control management project for the last few years: the BSD 
license encourages "branching", but the fact is, branching is not really 
all that interesting. What's interesting is "merging": the branching is 
just a largely irrelevant prerequisite to be able to merge.

The GPLv2 encourages *merging*. Again, the right to "branch" needs to be 
there in order for merges to be possible, but the right to branch is 
actually much less important than the right to "merge".

See? 

So I'm a *big* believer in the GPLv2. I think the GPLv2 is an almost 
perfect license. That doesn't mean that I have to agree with the FSF on 
everything else.

> Instead you chose a license which enforced the so called tit-for-tat
> policy you think is fair.  But people who prefer the BSD license may
> think you're a moron for forcing your political agenda (ie. tit-for-tat)
> on users of your code.

Oh, and some people did and do.

And you know what? That's PERFECTLY OK!

I think that the BSD license is wrong for me. Does that mean that people 
who choose the BSD license are wrong to do so? No. For *them* the choices 
that the BSD license makes may be the right ones!

> The point of all that being, you _do_ believe in enforcing restrictions 
> or you wouldn't like the GPL v2.

..  but I think that the software license I choose should be about the 
software, and about giving back in kind.

And the GPLv2 is _perfect_ for that.

And the GPLv3 is horrible.

And you know what? YOU can choose the GPLv3 for your projects. I'm not 
saying anything else. I'm saying that no, I was _not_ confused when I 
chose the GPLv2. I thought it was a good license 15 years ago. I thought 
it was a good license 10 years ago. I thought it was a good license five 
years ago. And I think it's a good license today.

Because it fundamnetally does what I think is fair. 

In a way that the GPLv3 DOES NOT.

		Linus
