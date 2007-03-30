Return-Path: <linux-kernel-owner+w=401wt.eu-S934376AbXC3AZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbXC3AZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 20:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934377AbXC3AZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 20:25:27 -0400
Received: from smtpout.mac.com ([17.250.248.171]:58129 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934376AbXC3AZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 20:25:27 -0400
In-Reply-To: <Pine.LNX.4.61.0703300206480.31834@yvahk01.tjqt.qr>
References: <bc8960410703290304t7ff61205u7110ac33c671fb4d@mail.gmail.com> <2375c9f90703290332w3f232b1cjf044f554fba04879@mail.gmail.com> <20070329205935.GB13541@Ahmed> <64884922-4254-4827-9A9F-09053043B8E6@mac.com> <Pine.LNX.4.61.0703300206480.31834@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EE2D5D85-8F52-46B2-83A3-918ED961FDB1@mac.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Cong WANG <xiyou.wangcong@gmail.com>,
       Russ Meyerriecks <datachomper@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Student Project Ideas
Date: Thu, 29 Mar 2007 20:25:12 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 29, 2007, at 20:09:11, Jan Engelhardt wrote:
> On Mar 29 2007 18:54, Kyle Moffett wrote:
>>
>> One thing that I think is fairly non-obvious to newcomers is that  
>> Linux kernel development is not done at all the way they teach you  
>> in your Large Scale Software Engineering classes.  Many of those  
>> classes talk much about careful design (whether top-down, bottom- 
>> up, outside-in, waterfall, spiral, $BUZZWORD_OF_THE_DAY) and  
>> detailed unit-testing, whereas Linux kernel development isn't  
>> really "designed" at all.
>
> Well, linux kernel is "extreme programming" - hack away until it  
> works, care about a design shape and stable API later.

I somewhat disagree.  Look at the amount of _design_ which is going  
into the linux-virtualization stuff, the replacement SLAB subsystems  
(SLOB/SLUB), or the current queued-spinlock thread.  Admittedly with  
Linux 90% of the design process is rewriting the code a thousand  
times based on comments before it goes into mainline, but that's  
design nonetheless.  It's just evolved-design-by-committee, a very  
knowledgeable committee made of the people who are interested in and  
understand what's going on well enough to give useful input and with  
enough sense of technical value to veto anything with significant  
architectural problems.

Cheers,
Kyle Moffett

