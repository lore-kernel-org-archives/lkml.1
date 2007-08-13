Return-Path: <linux-kernel-owner+w=401wt.eu-S941349AbXHMUqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941349AbXHMUqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940411AbXHMUp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:45:27 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:48052 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546AbXHMUpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:45:25 -0400
Message-ID: <46C0C282.800@student.ltu.se>
Date: Mon, 13 Aug 2007 22:43:46 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost> <46C07C16.6060406@intel.com> <46C0B3BF.20500@student.ltu.se> <46C0BEE9.1010207@intel.com>
In-Reply-To: <46C0BEE9.1010207@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Richard Knutsson wrote:
>> Kok, Auke wrote:
>>> Joe Perches wrote:
>>>> I grew weary of looking up the appropriate
>>>> maintainer email address(es) to CC: for a patch.
>>>>
>>>> I added flags to the MAINTAINERS file
>>>>
>>>> F:    file pattern
>>>>
>>>> for each maintained block and a script to parse
>>>> the modified blocks for maintainer and list
>>>> email addresses.
>>>>
>>>> perl scripts/get_maintainer.pl <patch>
>>>>
>>>> gives the appropriate maintainer(s).
>>>>
>>>> Modifications since last post:
>>>>
>>>> Added options to control email address style and multiple address 
>>>> separator
>>>>
>>>> Please apply.
>>> Well, I came up with this implementation, so I definately support it 
>>> and the way Joe implemented it:
>>>
>> Really? Please check out this thread with at least two ideas of 
>> possible implementations, with Stefan Richter as the spokesman of the 
>> current implementation: 
>> http://marc.info/?l=linux-kernel&m=116870578531280&w=3
>> ...and I am not saying there hasn't been someone suggesting it even 
>> earlier.
>>
>> The expression; nothing is new under the sun comes to mind ;)
>>
>> Anyway, glad to see someone actually implementing it. Thanks!
>
> bad wording my side, I never implemented anything, but I did post the 
> "F:" flag idea specific to allocating files to developers on lkml: 
> http://lkml.org/lkml/2007/6/29/300
>
...and so did Stefan: 
http://marc.info/?l=linux-kernel&m=116871954100026&w=3 :)

cu
Richard Knutsson

