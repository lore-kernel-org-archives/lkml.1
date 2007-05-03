Return-Path: <linux-kernel-owner+w=401wt.eu-S1030657AbXECJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbXECJCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030778AbXECJCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:02:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:36561 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030772AbXECJCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:02:33 -0400
Message-ID: <4639A527.5080909@argo.co.il>
Date: Thu, 03 May 2007 12:02:31 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why ssse3?
References: <46391392.4070706@redhat.com> <200705030046.07152.ak@suse.de> <4639171A.3050004@redhat.com> <200705031052.31611.ak@suse.de>
In-Reply-To: <200705031052.31611.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thursday 03 May 2007 00:56:26 Ulrich Drepper wrote:
>   
>> Andi Kleen wrote:
>>     
>>> Nope. SSE3 != SSSE3. The additional S means Supplemential.
>>>
>>> It's probably because the few changes didn't justify a SSE4
>>>       
>> OK, the problem is that the actual sse3 bit is misnamed.  According to
>> Intel's docs bit 0 of ECX is "sse", the kernel uses "pni".  Too bad.
>>     
>
> PNI (Prescott New Instructions) was the original engineering code name. Unfortunately
> it was added too early before the marketing name was known and then it couldn't be 
> changed anymore.
>   

Perhaps sse3 could be added as an alias to pni.


-- 
error compiling committee.c: too many arguments to function

