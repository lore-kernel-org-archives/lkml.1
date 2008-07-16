Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYGPC0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYGPC0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 22:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYGPC0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 22:26:45 -0400
Received: from ax54.genwebserver.com ([72.18.156.50]:41247 "EHLO
	ax54.genwebserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYGPC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 22:26:45 -0400
Message-ID: <487D5BD9.3080303@assumpcao.org>
Date: Tue, 15 Jul 2008 23:24:25 -0300
From: Tiago Assumpcao <tiago@assumpcao.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: pageexec@freemail.hu, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org <alpine.LFD.1.10.0807151707450.2867@woody.linux-foundation.org> <487D4301.5080609@assumpcao.org> <alpine.LFD.1.10.0807151749570.2867@woody.linux-foundation.org> <487D4A7B.8090403@assumpcao.org> <alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ax54.genwebserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - assumpcao.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Well, some people keep it secret and track it on vendor-sec or similar, 
> hidden from us.
> 
> But then when they are ready to announce it, they want our help to glorify 
> their corrupt process when they finally deign to let us know. And that 
> really irritates me.
> 

Again, not asking for what you can not provide. You must, however, do 
your part.

> The people who want to track security issues don't run my development 
> kernels. They usually don't even run the _stable_ kernels. They tend to 
> run the kernels from some commercial distribution, and usually one that is 
> more than six months old as far as I - and other kernel developers - are 
> concerned.

Right *there* is where it is born! Right at your development kernels. It 
may or may not survive up to the big market. However, being at the 
source level, it is your duty to a) resolve the source-level issues; b) 
put affordable efforts in order to prevent one known issue to arrive at 
the end point.

> 
> IOW, when we fix security issues, it's simply not even appropriate or 
> relevant to you. More importantly, when we fix them, your vendor probably 
> won't have the fix for at least another week or two in most cases anyway.
> 

There is obviously room for suffering from this delay. It's really 
small, however, if you understand that this is not enough time for 
widely spread exploits to be in the hands of every corner kid. Not.

Thus, consider the following: how many computers are likely to suffer 
from one bug that has been advised (marked as "security related" in your 
bugzilla), and, one week later, fixed? Now, how many computers are 
likely to suffer from one bug that has been advised and fixed 8 weeks 
later? A lot more, I presume.

Ok. Now, imagine this scenario: one bug that has never been identified 
as "security relevant" is assigned and/or fixed by your people. 
Remember, your list is open to public. Do you have a clue of how many 
individuals keep watching every bug/fix, with a "security antenna" 
turned on, expecting for the right bug to show up and... not receive the 
attention it needs so they can do whatever they want, for the amount of 
time they please? Several.

Now, tell me, how many computers are likely to suffer from the last 
scenario; the one that you cultivate?

> So ask yourself - what would happen if I actually made a big deal out of 
> every bug we find that could possibly be a security issue. HONESTLY now!
> 

Just mark it. No big deal.

> 
> I would not actually be helping you. I'd be helping the people you want to 
> protect against!
> 
> 			Linus
> 

Those who can see, and quickly exploit it, do not need your mark. They 
will figure it out right after it was assigned and an exploit will exist 
in the wild not after you fix the bug. So, let's work for the smallest 
pain. Right?

--t
