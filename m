Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbYLWLrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbYLWLrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 06:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYLWLrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 06:47:04 -0500
Received: from h155.mvista.com ([63.81.120.155]:15508 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750914AbYLWLrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 06:47:01 -0500
Message-ID: <4950CFAD.7020403@ru.mvista.com>
Date: Tue, 23 Dec 2008 14:46:53 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: gregkh@suse.de
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       khilman@deeprootsystems.com,
       davinci-linux-open-source@linux.davincidsp.com, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] musb: fix DaVinci build again
References: <200812072341.50012.sshtylyov@ru.mvista.com> <494A7729.6090102@ru.mvista.com> <494A7809.1040504@ru.mvista.com> <494E2450.9080601@ru.mvista.com>
In-Reply-To: <494E2450.9080601@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sergei Shtylyov wrote:
> Hello, I wrote:
>
>>>> The last Kevin Hilman's patch seems to have been broken on its way 
>>>> to Greg's
>>>> tree and also probably clashed with yet another patch. Fix DaVinci 
>>>> build again.
>>>> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>>>> ---
>>>> Felipe, I have to ask you again to be more careful with patches...
>>
>>>    11 days have passed since this has benn sent out and I'm still 
>>> not seeing this 2.6.28 *hot* fix in the MUSB git tree. Greg, could 
>>> you queue this urgently, bypassing the MUSB tree?
>>
>>   I'll be happy if it gets combined with the following patch in your 
>> tree:
>>
>> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/usb-musb-build-fixes-for-davinci.patch 
>>
>>
>> fallout of which I'm fixing. Though it would've been better yet if 
>> you just dropped that totally broken patch. I could've send a 
>> replacment then...
>
>   The patch I liked to above fixes nothing and only adds more 
> breakage. Compare it with the original Kevin's patch:
>
> http://marc.info/?l=linux-usb&m=122608723815504

   I'm seeing Felipe returning to the list but still ignoring this 
thread so far.
   For how much longer we'll have to wait for this issue to be resolved? 
2.6.28 is 2 days away (at most).
   Greg, what's the problem with dropping obviously broken patch?

WBR, Sergei


