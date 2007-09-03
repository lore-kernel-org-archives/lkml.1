Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXICMoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXICMoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXICMny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:43:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52124 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbXICMnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:43:53 -0400
Date: Mon, 3 Sep 2007 14:43:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, Natalie Protasevich <protasnb@gmail.com>,
       David Rees <drees76@gmail.com>, Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
Message-ID: <20070903124355.GV16016@stusta.de>
References: <46D21E8E.4000003@googlemail.com> <20070827005131.b93f5935.akpm@linux-foundation.org> <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com> <1188227585.2435.192.camel@dhcp193.mvista.com> <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com> <1188229197.2435.207.camel@dhcp193.mvista.com> <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com> <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com> <20070829222344.GV26410@stusta.de> <46D6E838.3020502@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46D6E838.3020502@tmr.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 11:54:32AM -0400, Bill Davidsen wrote:
> Adrian Bunk wrote:
>> On Wed, Aug 29, 2007 at 12:42:02AM -0700, Natalie Protasevich wrote:
>>> ...
>>> Then I think bugzilla needs:
>>>      adding more categories such as security,
>> "security" would be a flag like "regression", not a category.
>>> system calls (lots of
>>> implementation suggestions for posix and non-posix ones),
>>> ...
>> Bugzilla is for tracking bugs, not for discussing possible
>> kernel features.
>> Tracking feature or implementation suggestions wouldn't make sense. 
>> Consider e.g. that there are several people on linux-kernel who often 
>> write what they think the kernel should do but who never write a single 
>> line of code themselves. There's no value in tracking such stuff.
> That's an interesting viewpoint, only programmers have useful thoughts... 
> ignoring users, people who have CS degrees but don't code, etc. I would 
> think there's value in any rational suggestions which include technical 
> justification for the suggestion.

I didn't say this - users can always suggest features.

But open source is driven by coders, not by dreamers who want to offload 
the work of implementing their whacky ideas to other people instead of 
getting their ass up and doing it themselves.

So if the user doesn't implement it himself, and no developer is 
interested in doing the work after it got posted to linux-kernel,
an idea is most likely not worth being tracked.

> Bill Davidsen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

