Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXLJLkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXLJLkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXLJLkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:40:33 -0500
Received: from www.digitalsignage.messagenetsystems.com ([24.123.23.170]:33034
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755846AbXLJLka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:40:30 -0500
Message-ID: <475D259D.3080909@pagestation.com>
Date: Mon, 10 Dec 2007 06:40:13 -0500
From: Jerry Geis <geisj@pagestation.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG in 2.6.23.9
References: <475C46BC.5020101@pagestation.com> <20071209134418.14c9f09d@laptopd505.fenrus.org> <475D0387.1070609@netone.net.tr>
In-Reply-To: <475D0387.1070609@netone.net.tr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> Arjan van de Ven wrote:
>> On Sun, 09 Dec 2007 14:49:16 -0500
>> Jerry Geis <geisj@pagestation.com> wrote:
>>
>>  
>>> I am using centos 5.1, 2.6.23.9 kernel. Machine works great all day.
>>> Then sometime through the night the kernel dies, the trace is below.
>>>     
>>
>> is this when a 3D screensaver is active?
>> Probably worth running without the proprietary nvidia driver.... it
>> also tends to get more people to pay attention :)
>>
>>
>> In addition to this suspicion; you're the first one to report this oops
>> since at least a year as shown in
>> http://www.kerneloops.org/guilty.php?guilty=journal_dirty_data&version=2.6.23-release&start=1540096&end=1572863 
>>
>>
>> so it might well be something weird on your side (like the binary
>> driver or some heat problem created by having a 3D screensaver)
>>
>>   
> Hi,
>
> For a while, I have the same behavior. I tested under 2.6.23.9, 
> 2.6.24-rc3 and rc4. So all of these kernels have the same issue. Also, 
> I don't use any proprietary driver. My video card is Intel-945 and I 
> use the "intel" driver. I use 3D screensavers as well. These kernels 
> die after some long idles like 1 or 2 days after. My distribution is 
> Kubuntu 7.10 and with Kubuntu kernel this behavior did not happened. 
> So, how to track this interesting problem ? Any ideas welcomed :-)
>
> Cheers,
>
> Tarkan Erimer
>
>
>
>
>
I am not running a 3D screen saver. I was just using blank screen.
However, I did turn off the screen saver and last night my machine did 
not crash.

I am still using the NVIDIA driver.
All I changed was the screen saver.

Any ideas on that?

Jerry

