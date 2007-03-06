Return-Path: <linux-kernel-owner+w=401wt.eu-S965415AbXCFR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbXCFR5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXCFR5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:57:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50262 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965405AbXCFR5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:57:40 -0500
Date: Tue, 6 Mar 2007 09:57:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Uwe Bugla <uwe.bugla@gmx.de>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel
 2.6.20
In-Reply-To: <20070306173259.276350@gmx.net>
Message-ID: <Pine.LNX.4.64.0703060942060.5963@woody.linux-foundation.org>
References: <20070303155536.65380@gmx.net> <Pine.LNX.4.64.0703041325540.3953@woody.linux-foundation.org>
 <20070306173259.276350@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



[ Whitespace in your email fixed so that it's easier to read again ;^]

On Tue, 6 Mar 2007, Uwe Bugla wrote:
>
> But please do not compare me with maintainers, especially never in this 
> life with the suboptimal one from linuxtv.org being in question.
>
>  a. I ain't no maintainer

Sure. The problem is that it's actually really really hard (read: almost 
totally impossible) to find a person that everybody will agree is a good 
maintainer. It's just a really hard job, and we all screw up.

Not just from a technical angle too - quite often, the biggest problem for 
a maintainer is just the people skills. There's a fair number of people 
that are good at technology but have no people skills what-so-ever, and 
those are usually *worse* maintainers than people who may not be 100% up 
on all the technical issues, but have no problem working with people who 
do.

Finding somebody who is both technically top-notch *and* can work with 
people is so rare as to be something you shouldn't even look for. That's 
especially true since quite often, maintainership doesn't even come with a 
lot of glory - just a lot of work, and the expectation that you always be 
there. 

So when you call maintainers suboptimal, please realize that:

 - We're *all* suboptimal.

   I personally, of course, am totally perfect, and never ever make any 
   mistakes (did I already mention that I'm also good-looking?) but even 
   despite my obviously superior features, some people have the temerity 
   to point out that they think I make mistakes and argue way too much.

   So imagine that if people can find fault in the absolute perfection 
   that is Linus "almost Godlike" Torvalds, what about some poor sap who 
   maintains a piece of hardware with crappy documentation and a difficult 
   user base? And he doesn't even get the recognition that I do, so he's 
   just left with tons of abuse and may not be paid to do what he wants to 
   do, so he has to do other work *too*.

 - if you want to change something, it's fine to not be entirely polite 
   all the time: Al Viro and Christoph "is my hair blue this week?" 
   Hellwig are *famous* for being blunt bastards that are negative as hell 
   (and hey, so am I), but they are also well-known for getting things 
   done and mostly being right.

   And building that up takes time.

>  b. As far as my virtues are concerned in comparison to his the 
>     comparison is completely displaced.

Well, not entirely. The thing is, we all have "mental filters". Like it or 
not, people get associated with what they do, and even if they then do 
something totally different in another setting, the association remains. 
I'm just saying..

		Linus
