Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbYEASbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbYEASbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbYEASb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:31:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761550AbYEASb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:31:28 -0400
Date: Thu, 1 May 2008 11:30:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805011124020.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
 <20080501181157.GB5882@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Linus Torvalds wrote:
> 
> In other words: do people have realistic ideas for how to make others 
> spend _more_ time looking at patches? And not just _wishing_ people did 
> that?

Just to throw out an example:

 - make a "Random pending patch of the day" google gadget.

I know that's abit out there, and I'm not sure the google gadget thing is 
realistic, but I bet I'm not the only one who ends up using the google 
homepage all the time. A button that says "this patch looks ok", "this 
patch looks crap", or "I dunno, give me another one to look at" might be a 
fun game that would encourage people to look at a couple of patches a day.

You get five thousand people doing that occasionally (not every day, but 
maybe when they are bored and look for something more rewarding than 
trying to find bad music videos on youtube), and maybe you'd actually get 
feedback on patches.

Make it pick a random commit that is in linux-next but hasn't been merged 
into main -git yet.

Crazy? Probably. But at least it fits my notion of "let's not just wish 
people did more patch commentary" thing.

IOW, if people are really serious about coming up with ways to improve 
code quality, I really think it needs to be about _practical_ things that 
can fit in our flow or can be extensions to it, not just wishing for 
better quality.

"If wishes were horses, beggars would ride"

			Linus
