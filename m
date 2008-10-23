Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYJWWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYJWWNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJWWNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:13:16 -0400
Received: from h155.mvista.com ([63.81.120.155]:18684 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbYJWWNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:13:15 -0400
Message-ID: <4900F6F2.6000601@ru.mvista.com>
Date: Fri, 24 Oct 2008 02:13:06 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE updates #4
References: <200810212100.52985.bzolnier@gmail.com> <48FFAFBB.8020709@ru.mvista.com> <49009EDA.2030707@ru.mvista.com> <200810232307.15462.bzolnier@gmail.com>
In-Reply-To: <200810232307.15462.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>> Also I didn't know anything about your patchset and its
>>>> dependency on TX4939, otherwise I'll be pushing things in
>>>>         
>>>   The patchset consists of a large patch moving read_sff_dma_status() to 
>>> its porper place, one small preparatory patch, and 2 followup patches, 
>>> so unfortunately it's dependent on TX4939 in its main patch (worse, the 
>>> relevant part of this driver has changed after your last merged driver 
>>> version)...
>>>       
>>>> different order or even skip this pull request if needed
>>>> (TX493x drivers are new stuff and were still under review,
>>>> such things can be also submitted after the merge window
>>>> closes so they were given the lowest priority).
>>>>         
>>>   Unfortunately, that driver has been submitted first back 9/09, long 
>>> before my patchset was even created, so the dependence was just natural.
>>>       
>>     I could also rip out TX4939 part from the patch and leave Atsushi to deal 
>> with the fallout (though I could give him the ripped out part to simply be 
>> merged to the driver) if you would queue my patchset ahead of the driver. 
>> Though I feel it's too late now for my patchset to get into 2.6.28 the way 
>> things have been happening... :-/
>>     
>
> Ehm, submitting things _before_ the merge window usually help. ;-)
>   

   If I only had time to do that...

> Anyway, no need to get too frustrated over it.  It is normal that
>   

   I got used to my bad luck long ago -- this was only a minor series of 
misfortunes... :-)

MBR, Sergei


