Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXIZX5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXIZX5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXIZX5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:57:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41166 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbXIZX5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:57:12 -0400
Message-ID: <46FAF1D5.6020502@us.ibm.com>
Date: Wed, 26 Sep 2007 16:57:09 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com, hch@infradead.org
Subject: Re: [PATCH 0/3] A kernel tracing interface - (updated)
References: <1190830949.1232.11.camel@lc4eb748232119.ibm.com> <20070926191721.GA6399@Krystal>
In-Reply-To: <20070926191721.GA6399@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * David J. Wilder (dwilder@us.ibm.com) wrote:
>> These patches provide a kernel tracing interface called "trace".
>>
>> (update) Moved the sample code to the new samples\ subdir
>>
>> The motivation for "trace" is to:
>> - Provide a simple set of tracing primitives that will utilize the high-
>>   performance and low-overhead of relayfs for passing traces data from
>>   kernel to user space.
>> - Provide a common user interface for managing kernel traces.
>> - Allow for binary as well as ascii trace data.
>> - Incorporate features from the systemtap runtime that are
>>   useful to others.
>>
>> Patches are against 2.6.23-rc6-mm1
>>
>> Summary of patches:
>> [patch 1/3]  Trace code and documentation
>> [patch 2/3]  Relay Reset Consumed
>> [patch 3/3]  Trace sample
>>
>> Note: Patches 1/3 and 2/3 must be applied together.
>>
>> Note: The following patches must be applied with 3/3.
>> [patch 3/5] Add samples subdir
>> 	http://lkml.org/lkml/2007/9/25/157
> 
> I guess you mean:
> [patch 3/5] Add samples subdir (updated)
> http://lkml.org/lkml/2007/9/25/366
> 
> (please try it with this new version, it should work as is..)

yes it works fine with the new version of your patch,  I will update my 
note for the next round of submissions.
> 
> Mathieu
> 
>> [patch 4/5] Linux Kernel Markers - Samples
>> 	http://lkml.org/lkml/2007/9/25/166
>>
>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
>>
>>
> 

