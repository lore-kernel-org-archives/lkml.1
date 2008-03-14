Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYCNQy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYCNQy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYCNQyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:54:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52991 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYCNQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:54:48 -0400
Message-ID: <47DAAC9E.1060001@oracle.com>
Date: Fri, 14 Mar 2008 09:49:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] Add macros similar to min/max/min_t/max_t.
References: <1205471926.19712.12.camel@brick>	 <20080314093451.cd3e644c.randy.dunlap@oracle.com> <1205513171.27712.1.camel@brick>
In-Reply-To: <1205513171.27712.1.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Fri, 2008-03-14 at 09:34 -0700, Randy Dunlap wrote:
>> On Thu, 13 Mar 2008 22:18:45 -0700 Harvey Harrison wrote:
> 
>> Where is some blurb/comment about what "clamp" means/does?
>> min/max are well understood, but clamp?  Is that a shop tool?
>> I think I have a few out in my garage.
>>
>> So can we have some blurb here to explain clamp(), clamp_t(),
>> and clamp_val()?
>>
>> (kernel-doc preferred, but not required) e.g:
> 
>> /**
>>  * clamp - returns a value that is restricted between min & max inclusive
>>  * @val: current value
>>  * @min: minimum value of the clamping region
>>  * @max: maximum value of the clamping region
>>  */
>>
>> and explain the differences in clamp/clamp_t/clamp_val...
>>
>>
> 
> Sure, I'll do that..does kernel-doc actually work for macros?

Yes, it does.

-- 
~Randy
