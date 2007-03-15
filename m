Return-Path: <linux-kernel-owner+w=401wt.eu-S1422977AbXCOWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422977AbXCOWhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422981AbXCOWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:37:47 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:34726 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422977AbXCOWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:37:45 -0400
Message-ID: <45F9CAB0.2000305@in.ibm.com>
Date: Fri, 16 Mar 2007 04:07:36 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rdunlap@xenotime.net, jlan@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: taskstats accounting info
References: <Pine.LNX.4.58.0703140503250.28169@shark.he.net> <45F7E818.7010608@in.ibm.com> <20070315110655.5a815f2e.akpm@linux-foundation.org>
In-Reply-To: <20070315110655.5a815f2e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Wed, 14 Mar 2007 17:48:32 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
>> Randy.Dunlap wrote:
>>> Hi,
>>>
>>> Documentation/accounting/delay-accounting.txt says that the
>>> getdelays program has a "-c cmd" argument, but that option
>>> does not seem to exist in Documentation/account/getdelays.c.
>>>
>>> Do you have an updated version of getdelays.c?
>>> If not, please correct that documentation.
>>>
>> Yes, I did, but then I changed my laptop. I should have it archived
>> at some place, I'll dig it out or correct the documentation.
>>
>>> Is getdelays.c the best available example of a program
>>> using the taskstats netlink interface?
>>>
>> It's the most portable example, since it does not depend on libnl.
> 
> err, what is libnl?

libnl is a library abstraction for netlink (libnetlink).

> 
> If there exists some real userspace infrastructure which utilises
> taskstats, can we please get a referece to it into the kernel
> Documentation?  Perhaps in the TASKSTATS Kconfig entry, thanks.
> 

That sounds like a good idea. I'll check for details and get back.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
