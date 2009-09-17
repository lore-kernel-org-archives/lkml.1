Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZIQLXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZIQLXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZIQLXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:23:44 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41159 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZIQLXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:23:43 -0400
Message-ID: <4AB21C3D.2080202@in.ibm.com>
Date: Thu, 17 Sep 2009 16:53:41 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, npiggin@suse.de
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie>
In-Reply-To: <20090917105707.GA7205@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> I have access to a ppc machine but not necessarily one with a memoryless nodes
> that can reproduce this problem.
>
> Assuming Sachin is the reporter and we are in the same company, maybe I
> have access to the machine. Sachin, can you mail me privately what this
> machine is called and lets see can I get some time on that machine? By
> any chance, was this bisected or did it just show up when SLQB became
> the default?
>   
Mel,

Have sent you the access details for the machine. This bug showed
up when SLQB was enabled as default in linux-next

Thanks
-Sachin

> Total aside, does anybody know handily if fake NUMA support allows the
> creation of memoryless nodes help reproducing problems like this? If I can't
> get a real machine, that'll be the approach I'll be trying.
>
>   
>> Btw, the code is in slqb/core branch of slab.git in case someone wants
>> to take a stab at fixing the bug.
>>
>>     
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

