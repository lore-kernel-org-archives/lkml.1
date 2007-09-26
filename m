Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbXIZPPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbXIZPPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbXIZPO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:14:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39735 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXIZPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:14:55 -0400
Message-ID: <46FA7760.2000804@us.ibm.com>
Date: Wed, 26 Sep 2007 08:14:40 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       ananth@in.ibm.com
Subject: Re: [RFC Patch] Trace - Samples
References: <1190752548.30301.8.camel@lc4eb748232119.ibm.com> <20070925141619.22db8bce.randy.dunlap@oracle.com> <20070925232735.GA22967@Krystal> <46F99A2F.7000607@oracle.com>
In-Reply-To: <46F99A2F.7000607@oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Mathieu Desnoyers wrote:
>> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>> On Tue, 25 Sep 2007 13:35:47 -0700 David J. Wilder wrote:
>>>
>>>> This patch Moves the trace example into the new samples/ infrastructure
>>>>
>>>> Requires: [patch 3/5] Add samples subdir  
>>>> (http://lkml.org/lkml/2007/9/25/157)
>>>> and create samples/Makefile or apply: [patch 4/5] Linux Kernel 
>>>> Markers - Samples (http://lkml.org/lkml/2007/9/25/166)
>>>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
>>> Looks good.  Thanks.
>>>
>>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Andrew, Mathieu is making changes to patch 3/5 referenced above.
>>> When that is done, do you need a resend of all of these samples/
>>> patches or do you have them straight?
>>>
>>> Basically we have:
>>> a.  add samples/ infrastructure  (new coming from Mathieu)
>>> b.  add markers to samples/  (Mathieu)
>> Mine is correct as is. (with the new samples infrastructure)
>>
> 
> Right, your 2 can be the base (basis) for samples/, then the other
> follow-ups can be applied.
> 
>>
>>> c.  add trace/ to samples/  (this patch from David)

I need to re-test the trace-sample patch against Mathieu's new 
infrastructure patch.  I also need to re-post the trace patch with the 
sample removed.  I will re-post both later today.

>>> d.  add kprobes/ to samples  (move some from Documentation)
> 
> 

