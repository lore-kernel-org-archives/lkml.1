Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbXIYXb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbXIYXb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXIYXbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:31:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:29262 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXIYXbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:31:49 -0400
Message-ID: <46F99A2F.7000607@oracle.com>
Date: Tue, 25 Sep 2007 16:30:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "David J. Wilder" <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, ananth@in.ibm.com
Subject: Re: [RFC Patch] Trace - Samples
References: <1190752548.30301.8.camel@lc4eb748232119.ibm.com> <20070925141619.22db8bce.randy.dunlap@oracle.com> <20070925232735.GA22967@Krystal>
In-Reply-To: <20070925232735.GA22967@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> On Tue, 25 Sep 2007 13:35:47 -0700 David J. Wilder wrote:
>>
>>> This patch Moves the trace example into the new samples/ infrastructure
>>>
>>> Requires: [patch 3/5] Add samples subdir  (http://lkml.org/lkml/2007/9/25/157)
>>> and create samples/Makefile or apply: 
>>> [patch 4/5] Linux Kernel Markers - Samples (http://lkml.org/lkml/2007/9/25/166) 
>>>
>>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
>> Looks good.  Thanks.
>>
>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Andrew, Mathieu is making changes to patch 3/5 referenced above.
>> When that is done, do you need a resend of all of these samples/
>> patches or do you have them straight?
>>
>> Basically we have:
>> a.  add samples/ infrastructure  (new coming from Mathieu)
>> b.  add markers to samples/  (Mathieu)
> Mine is correct as is. (with the new samples infrastructure)
> 

Right, your 2 can be the base (basis) for samples/, then the other
follow-ups can be applied.

> 
>> c.  add trace/ to samples/  (this patch from David)
>> d.  add kprobes/ to samples  (move some from Documentation)


-- 
~Randy
Phaedrus says that Quality is about caring.
