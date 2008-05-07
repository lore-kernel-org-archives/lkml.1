Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYEGU64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYEGU64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYEGU6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:58:36 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:45800 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762294AbYEGU6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:58:31 -0400
Message-ID: <482217F3.2040900@numericable.fr>
Date: Wed, 07 May 2008 22:58:27 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh a écrit :
>  
>
>   
>> -----Original Message-----
>> From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
>> Sent: Tuesday, May 06, 2008 2:57 PM
>> To: Pallipadi, Venkatesh
>> Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
>> Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>> xf86MapVidMem error
>>
>> Pallipadi, Venkatesh a écrit :
>>     
>>>  
>>>
>>>   
>>>       
>>>> -----Original Message-----
>>>> From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
>>>> Sent: Tuesday, May 06, 2008 10:32 AM
>>>> To: Ingo Molnar
>>>> Cc: Pallipadi, Venkatesh; Siddha, Suresh B; Linux-kernel 
>>>>         
>> Mailing List
>>     
>>>> Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>>>> xf86MapVidMem error
>>>>
>>>> Ingo Molnar a écrit :
>>>>     
>>>>         
>>>>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>>>> Below is the patch to enable debug messages by a boot option 
>>>>>> "debugpat".
>>>>>>     
>>>>>>         
>>>>>>             
>>>> Hi all,
>>>>
>>>> I have applied the patch from Ingo and I put my
>>>> dmesg/syslog/messages/Xorg.log files in attached to help you 
>>>> to identify
>>>> the problem (two mails).
>>>>
>>>> Hope it can help you.
>>>>
>>>>     
>>>>         
>>> Did you use "debugpat" kernel boot option after applying 
>>>       
>> Ingo's patch?
>>     
>>> With Ingo's patch, that option is needed to print more info 
>>>       
>> (Not needed with one line change I sent you yday).
>>     
>>> Also, 'dmesg -s 256000' will not truncate the msg at 32K and 
>>>       
>> will give bigger dmesg output.
>>     
>>> Thanks,
>>> Venki
>>>
>>>   
>>>       
>> Hi,
>>
>> Here is my dmesg.log file with CONFIG_X86_PAT=y and debugpat 
>> kernel boot 
>> option.
>>
>> Is it helpfull ? :-).
>>
>>     
>
> Yes. This has some debug information in there. Did you see xf86MapVidMem error (I mean did you try to start X) before you captured this dmesg?
>
> Thanks,
> Venki
>
>   
Hi all,

Yes, the error's message is in my Xorg.log file :-)

Regards.


