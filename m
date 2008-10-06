Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYJGHHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYJGHHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 03:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYJGHHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 03:07:00 -0400
Received: from brain.cel.usyd.edu.au ([129.78.24.68]:64739 "EHLO
	brain.cel.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYJGHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 03:06:59 -0400
Message-Id: <5.1.1.5.2.20081007064952.0236cb00@brain.cel.usyd.edu.au>
X-Mailer: QUALCOMM Windows Eudora Version 5.1.1
Date: Tue, 07 Oct 2008 06:55:11 +1000
To: balbir@linux.vnet.ibm.com
From: sena seneviratne <auntvini@cel.usyd.edu.au>
Subject: Fwd: Re: New Metrics to measure Load average
Cc: peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir Singh,

I have done changes to the load average inside current functions.
This means without introducing any new function.

Please go through our previous correspondence in this regard.

Also I had discused this fact with Peter Williams who had introduced some 
new functions in the same area.

Would do you be able to test my code?

Kind regards
Sena Seneviratne
Computer Engineering Lab
School of Electrical and Information Engineering
Sydney University
Australia

Thanks
>Date: Sat, 04 Oct 2008 00:22:58 +1000
>To: balbir@linux.vnet.ibm.com
>From: sena seneviratne <auntvini@cel.usyd.edu.au>
>Subject: Fwd: Re: New Metrics to measure Load average
>Cc: linux-kernel@vger.kernel.org,arjan@infradead.org
>
>Dear Balbir Singh,
>
>This is one of the e-mails probably the last.
>By this time I have finshed 2.4.19 kernel.
>
>Thanks
>Sena Seneviratne
>Computer Engineering Lab
>School of Electrical and Information Engineering
>Sydney University
>Australia
>
>>Date: Tue, 20 Jun 2006 19:43:36 +1000
>>To: balbir@in.ibm.com
>>From: sena seneviratne <auntvini@sedal.usyd.edu.au>
>>Subject: Re: New Metrics to measure Load average
>>
>>Dear Balbir Singh,
>>
>>Thanks for your reply and for your time.
>>
>>Then I will have to transfer from 2.4.18 to 2.6.18
>>
>>Ok Balbir  I will do that.
>>
>>
>>Kind regards
>>Sena Seneviratne
>>Computer Engineering Lab
>>School of Electrical and Information Engineering
>>Sydney University
>>Australia
>>
>>
>>
>>At 02:29 PM 6/20/2006 +0530, you wrote:
>>>sena seneviratne wrote:
>>>>Dear Balbir Singh,
>>>>Thanks for your valuable reply.
>>>>Balbir  It looks like that there is a general project where we all can 
>>>>incorporate our work.
>>>
>>>
>>>Yes it is. It is currently in -mm and we hope that it makes it into
>>>2.6.18. The folder Documentation/accounting contains all the necessary
>>>details for you to build on top of delay stats.
>>>
>>>
>>>>--How do you calculate disk load? Is it the
>>>>---number of uninterruptible tasks in the system?  Yes I started at 
>>>>that point
>>>>
>>>>Few years ago the few additions I have explained, have been implemented 
>>>>in linux 2.4.18 kernel at  the Sydney Uni as part of a large research project.
>>>>Also few years ago I have posted many posts about this topic to this 
>>>>forum.  Few very experience hands  were advising me in coding at that 
>>>>time. To prove this I have all the e-mails with me. Yet then I had not 
>>>>explained to this forum about the research project which involved 
>>>>prediction algorithm as then it had not been published.
>>>>Thereafter few research papers have been published with regard to this. 
>>>>1 in US.
>>>>Currently I am preparing the changes to a more recent linux patch. In 
>>>>fact this is not hard as I have already changed the previous linux 2.4.18.
>>>
>>>Please cc us when you post the patches.
>>>
>>>>Before coming to do research I had worked as a Senior software engineer 
>>>>in few companies and my last was LogicaCMG. Yet as far as the kernel 
>>>>programming is concerned I will ask for your comments and advice.
>>>
>>>Let us know if you need any help for coding on top of taskstats.
>>>
>>>>Thanks
>>>>Sena Seneviratne
>>>>Computer Engineering Lab
>>>>School of Electrical and Information Engineering
>>>>Sydney University
>>>>Australia

