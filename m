Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbXLRPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbXLRPTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXLRPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:19:32 -0500
Received: from smtpout05-04.prod.mesa1.secureserver.net ([64.202.165.221]:50092
	"HELO smtpout05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756516AbXLRPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:19:30 -0500
Message-ID: <4767E500.9090802@seclark.us>
Date: Tue, 18 Dec 2007 10:19:28 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cpuinfo_cur_freq always max
References: <4766B724.7090106@seclark.us> <x7k5ndj9ki.fsf@saeurebad.de>	<4766ECDB.1040203@seclark.us> <x7fxy1j7ms.fsf@saeurebad.de>
In-Reply-To: <x7fxy1j7ms.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:

>Hi,
>
>Stephen Clark <Stephen.Clark@seclark.us> writes:
>
>  
>
>>>Which governor are you using?  ondemand?
>>>      
>>>
>>Not sure - but the only thing that is changed is the kernel - if I go
>>back to 2.6.23.1 it works correctly.
>>    
>>
>
>Have a look at /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
>
>	Hannes
>
>PS: Steve, please keep the list in CC.
>
>  
>
userspace



-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



