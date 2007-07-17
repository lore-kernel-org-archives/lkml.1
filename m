Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbXGQOHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbXGQOHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXGQOHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2760 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbXGQOHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:30 -0400
Date: Tue, 17 Jul 2007 16:06:45 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070717080230.GC13539@elte.hu>
Message-ID: <Pine.LNX.4.64.0707171324110.1817@scrub.home>
References: <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home>
 <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home>
 <20070716203117.GC11166@waste.org> <20070716211851.GB18661@elte.hu>
 <Pine.LNX.4.64.0707162351030.1817@scrub.home> <20070716222909.GA30906@elte.hu>
 <Pine.LNX.4.64.0707170047230.1817@scrub.home> <Pine.LNX.4.64.0707170437110.1818@scrub.home>
 <20070717080230.GC13539@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 17 Jul 2007, Ingo Molnar wrote:

> Roman, please do me a favor, and ask me the following question:
> 
>  " Ingo, you've been maintaining the scheduler for years. In fact you 
>    wrote the old nice code we are talking about here. You changed it a
>    number of times since then. So you really know what's going on here. 
>    Why does the old nice code behave like that for nice +19 levels? "
> 
> I've been waiting for that obvious question, and i _might_ be able to 
> answer it, but somehow it never occured to you ;-) Thanks,

Do you have any idea how insulting and arrogant this is?
Let me translate for you, how this arrived:

"O Ingo, who art our god of the scheduler. You have blessed the paths I 
walked in. You kept me from sinning numerous times. Your wisdom is 
infinite. Guide me on the journey that layeth ahead of me into this world 
knowledge of Your truth."

(I apologize already in advance, if I should have hurt anyones religious 
feelings.)

It's obvious that you have more experience with the scheduler code, but 
does that make you unfailable? Does that give you the right to act like a 
jerk?
I do make mistakes, I try to learn from them and life goes on, I have no 
problem with that, but what I have a problem with is if someone is abusing 
this to his own advantage. I have to be extremely carful what I say to 
you, because you jump on the first small mistake and I have to bear your 
insults like "there's nothing i can do about your denial of facts - that 
is your own private problem." I have no problems with facts, I'm only 
trying very hard to ignore your arrogant behaviour...
If you have something to contribute to this discussion which might clear 
things up, then just say it, but I'm not going to beg for it.

bye, Roman
