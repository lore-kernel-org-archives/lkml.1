Return-Path: <linux-kernel-owner+w=401wt.eu-S1763593AbXHMQGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763593AbXHMQGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946897AbXHMOhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:37:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:41488 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S946994AbXHMOhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:37:13 -0400
Message-ID: <46C06CA2.8010303@qumranet.com>
Date: Mon, 13 Aug 2007 17:37:22 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       cotte@de.ibm.com
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <200708131615.42643.borntraeger@de.ibm.com> <46C06885.3020908@qumranet.com> <200708131626.36275.borntraeger@de.ibm.com>
In-Reply-To: <200708131626.36275.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Montag, 13. August 2007 schrieb Avi Kivity:
>   
>> Christian Borntraeger wrote:
>>     
>>> Am Montag, 13. August 2007 schrieb Laurent Vivier:
>>>   
>>>       
>>>>> [copying Ingo and Rusty]
>>>>>       
>>>>>           
>>> @Avi, seems that sourceforge is mangling the cc list?
>>>
>>>   
>>>       
>> It's not configured to do so.  Can you be more specific?
>>     
>
> I added Carsten and he was removed from the CC list in my copy I got from SF.
> And you cced Ingo and Rusty but I dont have them on cc, either.
>
>   

The only thing remotely relevant in the list config is that 'Filter out 
duplicate messages to list members (if possible)' is set as a default 
for new members.  Maybe this means that if a cc is also part of the 
list, that cc is stripped (which seems a wierd implementation; I'd have 
expected that cc be kept and just one copy sent out).

Anybody have a clue?


-- 
error compiling committee.c: too many arguments to function

