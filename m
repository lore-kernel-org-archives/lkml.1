Return-Path: <linux-kernel-owner+w=401wt.eu-S1762547AbXEZV6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547AbXEZV6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 17:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXEZV6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 17:58:40 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35866
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbXEZV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 17:58:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 23:58:29 +0200
User-Agent: KMail/1.9.6
Cc: Larry Finger <larry.finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705262149.09948.mb@bu3sch.de> <200705262332.50640.uwe.bugla@gmx.de>
In-Reply-To: <200705262332.50640.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262358.30038.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 23:32:50 Uwe Bugla wrote:

> Hint: Although being a "non-hacker" or "non-developer" I do have stepped 
...
> In so far, if you continue to state that debugging is nothing but guessing 
> around wildly you are definitely wrong, showing us all your missing code 
> hacker experience. If you DO continue like this every step will be a torture 
> not only for me but for the reading folks as well.

You REALLY want to tell me, a developer and maintainer of several
big projects, how debugging is done, being a non-developer and non-hacker?
I can't believe what I am reading here.

> The fact that you simply ignored to imply those functions and continue to call 
> other people dumb shows exactly how small and humble you are.

Please quote me where I called someone dumb.
Ah, yes. I am inhuman and whatever. We know that already.

> Apart from that:
> The message that you rooted to my place was no "proof" at all for any kind of 
> disfunctionality or compatibility issue!
> 
> In that message the lack of performance of the "enclosed" or "old" 
> or "complete" b44 module (i. e. PCI-only module) was criticised, NOT the one 
> ripped by you personally into two modules called b44 and ssb.

Ah, no? I think you didn't completely understand the mail.
Steve reported a bug in b44 2.6.22. Please note that 2.6.22 does NOT include
ssb. But I'm sure you'll find a way to make me responsible for
this bug, anyway.
b44 is buggy and this is NOT caused by ssb. Re-read steve's mail.

> In so far I would deeply appreciate you personally to stick to the facts in 
> your personal lack of knowledge about the b44 driver instead of playing bad 
> politics against other people like me and others.

Oh, poor poor guy.
I lack knowledge about b44? Oh, I suppose that was a typo and you
meant yourself.

> Hello my dear Andrew Morton,
> 
> Could you please do me and the rest of the world two favours?
> 
> A. Rip Michael Buesches code out of the mm-tree
> 
> B. Give Michael Buesch a fair chance to revise his disfunctionable code 
> outside the mm-tree and / or the vanilla mainline.

Andrew, I see that you are in a bad situation now.
I respect every decision you make. But please still
consider that b44 works perfectly well for me. I tested it
today on _all_ kernels that did not work for Uwe in this thread.
On my device (BCM4401-B0) it works on all of these kernels.

I'd suggest we leave the code in the -mm tree and wait for
someone else to show up with a bugreport.
It's simply impossible to debug this problem with the help of Uwe.

> C: calling all people simply dumb who do not know about his personal issues at 
> all

Please quote this, Uwe.

> Thank you, Andrew Morton! You are real fine!
> 
> Sincerely
> 
> Uwe
> 
> 

Uwe, I just added you to my killfile.
Don't bother sending mail to me any longer. It will not arrive.
I'm not interested in your stupid "bugreports" anymore, as they are
useless and consist only of personal insults and
personal miscreditations.
Welcome to the killfile of yet another kernel developer.

-- 
Greetings Michael.
