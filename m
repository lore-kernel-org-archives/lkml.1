Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYIDJfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYIDJfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYIDJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:35:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35599 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYIDJfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:35:41 -0400
Message-ID: <48BFABE0.6050505@garzik.org>
Date: Thu, 04 Sep 2008 05:35:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ayaz Abdulla <aabdulla@nvidia.com>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       tomasw@gmail.com, yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: [GIT]: Networking
References: <20080903.161341.239039051.davem@davemloft.net> <alpine.LFD.1.10.0809031621160.3515@nehalem.linux-foundation.org> <20080903.162603.27086959.davem@davemloft.net> <200809041025.15277.rjw@sisk.pl>
In-Reply-To: <200809041025.15277.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 4 of September 2008, David Miller wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Wed, 3 Sep 2008 16:24:16 -0700 (PDT)
>>
>>> On Wed, 3 Sep 2008, Linus Torvalds wrote:
>>>> What's so hard to understand about this?
>>> Here's a simple rule of thumb:
>>>  - if it's not on the regression list
>>>  - if it's not a reported security hole
>>>  - if it's not on the reported oopses list
>>> then why are people sending it to me?
>>>
>>> IOW, if it's just another random improvement, and you send it to me 
>>> outside of the merge window, then what is the point of the merge window? 
>> This is exactly what I've been trying to tell the Intel wireless folks
>> but they refuse to listen.
>>
>> I just won't take their stuff until they get their act in gear.
>>
>> No problem.
> 
> BTW, there are two regression fixes for forcedeth:
> 
> http://marc.info/?l=linux-kernel&m=121894389018584&w=4
> http://marc.info/?l=linux-kernel&m=121917167232014&w=4
> 
> that fix the regressions tracked as:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11358
> http://bugzilla.kernel.org/show_bug.cgi?id=11361
> 
> respectively and both are more than 2 weeks old now.
> 
> Is there any chance to push them upstream or is there anything wrong with them?

Your patch is fine.  Since DaveM and I are gone this weekend, feel free 
to add "acked-by: jgarzik@redhat" and forward upstream to Linus and Andrew.

I thought there was some discussion about Yinghai Lu's MAC addr patch, 
though.  I'll look into it Monday, but maybe Ayaz (maintainer @ nv) 
could ack it sooner than that?

	Jeff



