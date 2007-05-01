Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXEAOlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXEAOlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXEAOlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:41:18 -0400
Received: from rtr.ca ([64.26.128.89]:2294 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXEAOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:41:14 -0400
Message-ID: <46375188.1040103@rtr.ca>
Date: Tue, 01 May 2007 10:41:12 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: tglx@linutronix.de, Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <463653A3.5040606@rtr.ca>	 <46367D7E.6060502@rtr.ca> <1177976798.12796.286.camel@imap.mvista.com>	 <463683A6.4010505@rtr.ca>	 <1178026458.5791.305.camel@localhost.localdomain>	 <4637419D.8010303@rtr.ca> <463741F1.7050706@rtr.ca>	 <1178027285.5791.307.camel@localhost.localdomain>	 <46374B1D.6050509@rtr.ca> <6bffcb0e0705010726i3408f697qbbeede719445141d@mail.gmail.com>
In-Reply-To: <6bffcb0e0705010726i3408f697qbbeede719445141d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> On 01/05/07, Mark Lord <lkml@rtr.ca> wrote:
>> Thomas Gleixner wrote:
>> > On Tue, 2007-05-01 at 09:34 -0400, Mark Lord wrote:
>> >>> now at 3232363876949 nsecs
>> >> ...
>> >>
>> >> Oh, in case it matters any:
>> >> that /proc/timer_list is from the system with CFS-V7 also patched in.
>> >
>> > It should not. What happens when you disable HPET ?
>>
>> Booting with clocksource=tsc still hangs in what appears
>> to be the exact same place.
>>
>> Screenshots for that are available here:   http://rtr.ca/hrtimers/
> 
> 404 Not Found

Fixed.  Sorry about that!
