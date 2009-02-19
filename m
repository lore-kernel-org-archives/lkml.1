Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZBSFVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZBSFVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 00:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZBSFUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 00:20:53 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33589 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZBSFUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 00:20:52 -0500
Message-ID: <499CEC2C.1060406@in.ibm.com>
Date: Thu, 19 Feb 2009 10:50:44 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Mike Frysinger <vapier.adi@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [s390] next Feb 18: defconfig build break
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <20090218224541.fe6e0355.sfr@canb.auug.org.au> <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com> <200902190913.27653.rusty@rustcorp.com.au>
In-Reply-To: <200902190913.27653.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 19 February 2009 03:40:59 Mike Frysinger wrote:
>   
>> On Wed, Feb 18, 2009 at 06:45, Stephen Rothwell wrote:
>>     
>>> That would be a side effect of commit 43a47c6ca0e0b5479ae316e188a28b7e625d41e5 ("misc:strstarts") from the rr tree.  Rusty cc'd.
>>>       
>> breaks all Blackfin ports as well:
>>     
>
> My first reaction was WTF?  My second was, how did our string code become
> such a catastrophe?
>
> Sorry, I had no idea what a mess I was wading into.
>
> Here's the s390 fix:
>   
Thanks Rusty. That fixes the issue.

Regards
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

