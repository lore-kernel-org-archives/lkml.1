Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbXHTLyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbXHTLyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 07:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbXHTLyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 07:54:16 -0400
Received: from baros.cubic.ch ([213.239.213.98]:45109 "EHLO baros.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXHTLyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 07:54:15 -0400
Message-ID: <46C980E5.2050805@cubic.ch>
Date: Mon, 20 Aug 2007 13:54:13 +0200
From: Tim Tassonis <timtas@cubic.ch>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Thinking outside the box on file systems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc

> What's the point? People are openly hostile to new
> ideas here. I started out nice and laid out my ideas
> and you have a bunch of morons who attack anything
> new.

If you think using subjects like "Thinking out of the box" (implicitely 
calling everybody else narrow-minded) and "vi causes brain damage" is 
starting out nice, you also got a serious communication problem.

> Look at the reality of the situation. Linux is free
> and yey it can't compete with operating systems that
> are paid for. Maybe the reason is that when someone
> point out the something is broken all yopu get is
> justification and excuses and insults.

Funny, even Microsoft acknoledges that Linux can very well compete, as 
does your beloved Novell that just recently bought Suse. Maybe you 
haven't noticed yet that you're the only one left that thinks Linux 
can't compete.

> Think about it. Why did it take 20 years for Linux to
> fix the RM problem? If you type RM * you expect the
> files to be gone, not some stupid error that I'm
> trying to delete too many files.

Well, it's not a stupid error, this is called a limit. Other people have 
already explained to you how the UNIX shell works, so I'm not going to 
repeat it again.

That said, I even would admit that I have been bitten by this limit 
before (deleting a few thousand bounced mail in a spool directory),

> 
> So who's fault is that? I say it's a problem with
> Linux culture. If something is broken you have to
> justify it instead of fixing it.

I use Linux since the mid 90's and remember thousands and thousands of 
bugs fixed and limits removed. But you must be here longer and have the 
better view of how "the Linux culture" really works.

> You guys are trying to may the RM problem MY FAULT
> because I didn't say it nicely. We'll it doesn't have
> to be said nicely. If something is broken then it
> needs fixed regardless of who and how it is pointed
> out.

Nobody denied the limit, you were just pointed out that you don't have a 
fucking clue what the behavior actually means and where the limit lies.
And calling other people brain-damaged at the same time...

  > So wat does it tell you when something like this is
> left broken for so long? What it tells me is that the
> development process is broken.

Well, it tells _me_:
- It is a limit and not a bug
- The limit is not severe, not many people constantly have to delete 
millions of files in the directory without deleting the directory itself
- the limit can be worked around by "find . |xargs \rm"

But, as you proved again and again, you're the expert.

> My rant on VI is to make a point. That point being
> that when you use an editor that totally sucks then
> it's going to cause you to write code that sucks. It
> going to lower your standards. It's going to create a
> culture where poorly done work is considered
> acceptable. When you use an editor as poor as vi then
> the idea that rm * doesn't work becomes acceptable and
> justifiable, as demonstrated here by people who
> ACTUALLY DEFENDED IT.

You might have wanted to make this point. But all you really showed is 
that you're an arrogant, ignorant loudmouth, takling about things you 
have no clue about. I bet you haven't written a single line of decent 
code in your life.

Kind regards
Tim

