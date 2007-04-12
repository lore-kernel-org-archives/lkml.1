Return-Path: <linux-kernel-owner+w=401wt.eu-S1030827AbXDLWiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827AbXDLWiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030838AbXDLWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:38:52 -0400
Received: from mail.tmr.com ([64.65.253.246]:36632 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030827AbXDLWiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:38:51 -0400
Message-ID: <461EB367.1050405@tmr.com>
Date: Thu, 12 Apr 2007 18:32:07 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Buytaert_Steven@emc.com
CC: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <20070412133158.GB31455@one.firstfloor.org> <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com>
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Buytaert_Steven@emc.com wrote:
>> -----Original Message-----

>> Besides - but I guess you're aware of it - any randomized
>> algorithms tend to drive benchmarkers and performance analysts
>> crazy because their performance cannot be repeated. So it's usually
>> better to avoid them unless there is really no alternative.
> 
> That could already solve your concern from above. Statistically
speaking, it will give them (benchmarkers) the smoothest curve they've
ever seen.
> 
> Please be aware that I'm just exploring options/insight here. It is
not something I intend to push inside the mainline kernel. I just want
to find reasonable and logic criticism as you and some others have
provided already. Thanks for that!

And having gotten same, are you going to code up what appears to be a 
solution, based on this feedback?

I'm curious how well it would run poorly written programs, having 
recently worked with a company which seemed to have a whole part of 
purchasing dedicated to buying same. :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
