Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0CHEdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 23:33:35 -0500
Received: from fox.spectranet.com ([203.122.59.43]:48807 "EHLO
	fox.spectranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab0CHEd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 23:33:28 -0500
Message-ID: <4B947AD6.30105@asladvancedsys.in>
Date: Mon, 08 Mar 2010 10:04:34 +0545
From: Ravi Kumar Kulkarni <ravikulkarni@asladvancedsys.in>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux@bohmer.net
CC: linux-kernel@vger.kernel.org, linux@maxim.org.za
Subject: Re: Info on AT91 patches against mainline kernel
References: <4B868701.3010904@asladvancedsys.in>	 <3efb10971003050229na0fd4fbl128a890b0cf245c0@mail.gmail.com>	 <4B90E415.5090106@asladvancedsys.in> <3efb10971003050634o37807a22tccd5c9416f3eb7a@mail.gmail.com>
In-Reply-To: <3efb10971003050634o37807a22tccd5c9416f3eb7a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - fox.spectranet.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asladvancedsys.in
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>    
>>      
>>> You do not necessarily need the at91-patchset from Andrew.
>>> 2.6.33 works fine on at91sam9261 without it...
>>>
>>> Remy
>>>
>>>        
>> Thanks for the info. I will try to compile 2.6.33  now. But i got a mail
>> from andrew  that he updated at91 patchset to 2.6.32 . for clarification jus
>> verifying tat u mean  from 2.6.33 onwards  u  don't need at91 patches and
>> can directly compile without waiting Andrew's patchset . If tats case then
>> Andrew can update that in linux4samdotorg website so that it will be helpful
>>      
> You only need the changes from Andrew in case there is something in
> there that you require, you should look at the changelog to be sure.
> But, the at91sam9261 is already for several years in mainline and it
> works fine (even much older kernels than 2.6.33 will work without it,
> for example we used 2.6.24, 2.6.26, 2.6.31 without it), Andrews
> patchset is just a set of additional changes that will likely be
> pushed to mainline at some time.
>
> Remy
>
>    
got it. thanks a lot for your clarification and info.
warm regards,
Ravi Kulkarni.
