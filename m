Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYHYUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYHYUTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYHYUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:19:28 -0400
Received: from mx10.lb01.inode.at ([62.99.145.10]:14210 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924AbYHYUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:19:27 -0400
Message-ID: <48B313C3.30704@sbg.ac.at>
Date: Mon, 25 Aug 2008 22:19:15 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (X11/20080729)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Helge Hafting <helge.hafting@aitel.hist.no>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
References: <4899AF8E.20105@sbg.ac.at> <489B85A3.7030500@sbg.ac.at>	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>	 <48A43CB5.8010709@sbg.ac.at>	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>	 <48AD8125.7050104@sbg.ac.at>	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>	 <48AE90BB.5090800@aitel.hist.no>	 <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>	 <48B29320.5070903@aitel.hist.no> <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
In-Reply-To: <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Aug 25, 2008 at 4:10 AM, Helge Hafting
> <helge.hafting@aitel.hist.no> wrote:
>   
>> Yinghai Lu wrote:
>>     
>>> On Fri, Aug 22, 2008 at 3:11 AM, Helge Hafting
>>>
>>>       
>> [old bug report removed]
>>     
>>> please boot with "mtrr_spare_reg_nr=3 debug"
>>>
>>>       
>> I did that, and got:
>> dmesg:
>> Command line: root=/dev/sda2 ro mtrr_spare_reg=3 debug
>>     
>
> please use "mtrr_spare_reg_nr=3 debug"
>
> you missed _nr.
>
> YH
>   
yinghai,

should i try that boot option too?
can i try anything else?
i hope you remember my emails.

-- 
kind regards
alex
