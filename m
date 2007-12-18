Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXLRVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXLRVkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXLRVkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:40:07 -0500
Received: from smtpout05-04.prod.mesa1.secureserver.net ([64.202.165.221]:57807
	"HELO smtpout05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753010AbXLRVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:40:05 -0500
Message-ID: <47683E1E.4010001@seclark.us>
Date: Tue, 18 Dec 2007 16:39:42 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: cpuinfo_cur_freq always max
References: <4766B724.7090106@seclark.us> <x7k5ndj9ki.fsf@saeurebad.de>	<4766ECDB.1040203@seclark.us> <x7fxy1j7ms.fsf@saeurebad.de>	<4767E500.9090802@seclark.us> <x71w9k6lbf.fsf@saeurebad.de>
In-Reply-To: <x71w9k6lbf.fsf@saeurebad.de>
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
>>userspace
>>    
>>
>
>Please supply the full dmesg output on the non-working kernel the
>corresponding .config (or /proc/config.gz).
>
>Added Dave to CC.
>
>	Hannes
>
>  
>
Duh - I rebooted into the new kernel and no longer see the behavior I 
described above. Maybe I had something going in
the background i didn't realize. Thing was I even started a bash empty 
while loop to see if /proc/cpuinfo speed would go
up and it did.

I have an applet that displays on my kde kicker panel that every 2 
seconds reads /sys/.../cpuinfo_cur_freq and it was
sitting on the max speed all the time. Hmmm.

Well Thanks for the response and sorry for the false alarm.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



