Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYEAEcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYEAEcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYEAEbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:31:49 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:34940 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752772AbYEAEbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:31:48 -0400
Message-ID: <481947AF.4090101@davidnewall.com>
Date: Thu, 01 May 2008 14:01:43 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com> <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org> <4818B8A7.4000902@davidnewall.com> <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org> <4818C0BF.5020002@davidnewall.com> <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org> <4818C571.8040609@davidnewall.com> <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I object to your _idiotic_ claim that there are "systemic problems", where 
> your "solution" to them is apparently to stop making releases and stop 
> making forward progress.
>   

I did not say to stop making releases or forward progress. You
completely made that up! I said there are systemic problems, namely
inadequate testing and review. Slow down; don't snatch up crap changes.
Only accept them when they are properly tested and properly reviewed.


> That's why I said you told us was nothing like that. What you told us were 
> your personal problems, no "systemic" issues.

You asked me to give a specific problem, so I did, but I also said that
the particulars of those problems weren't the point. You have ignored or
twisted everything I said. Did you ask me for a specific problem purely
to attack me with it? Perhaps you did.



Linus Torvalds also wrote:
> You complain how I don't release kernels that 
> are stable, but without any suggestions on what the issue might be

You do release kernels that are unstable, and you call them "stable",
but I'm sure I said that inadequate review and testing are causes, which
I think counts as a suggestion on what the issue might be. It's been a
repeating theme in this thread, and I'm talking about what everybody
else is saying, not what I'm saying, so again, you know that I'm not
making this up.

Stop telling the world that 2.6.25 is ready for them when you know it's
not. It's now ready for beta testing, and no more. Is 2.6.24 ready for
the world yet? There are still problems being reported with it.


> And yes, there is a solution: don't develop so much. Don't allow thousands 
> of developers to be involved. Do a small core group, and make development 
> so hard or inconvenient that you only have a few tens of people who write 
> code, and vet them and force them to jump through hoops when adding new 
> features (or fixing old ones, for that matter).
>   

You're being absurd, even hysterical. How about you require test plans
and test results? Is it possible to require serious, independent code
review?

And let me talk about code review. When one puts one's name to a
reviewed-by tag one takes joint responsibility for the result. There
needs to be some sort of balanced accounting. Presently it's all glory,
where the records show who has contributed code that made it to
mainline, but nobody counts who broke the system. There's no motive to
do a good job, in fact the opposite is true. The more crap you can sneak
in, the more glory you get.

Don't you go and twist this into some sort of, "David want's to point
fingers at people who regularly introduce bugs, which we don't want to
do" and ignore the problem. There is a problem; this entire thread is
testimony to that. You, Linus, are ultimately responsible for what goes
in so you have to acknowledge that there is a problem, you have to stop
shooting the messenger, and you have to shepherd a solution.
