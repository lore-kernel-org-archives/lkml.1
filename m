Return-Path: <linux-kernel-owner+w=401wt.eu-S935682AbYCFVf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935682AbYCFVf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760024AbYCFVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:35:18 -0500
Received: from smtpout09-04.prod.mesa1.secureserver.net ([64.202.165.17]:41235
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753785AbYCFVfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:35:17 -0500
Message-ID: <47D0628E.9030205@seclark.us>
Date: Thu, 06 Mar 2008 16:30:54 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: iTCO watchdog timer
References: <47CDAC9D.6020505@seclark.us> <20080304135548.b7b88ee4.akpm@linux-foundation.org> <20080306212820.GA2866@infomag.infomag.iguana.be>
In-Reply-To: <20080306212820.GA2866@infomag.infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> Hi All,
>
> Sorry but it's quite busy at the moment...
>
>   
>>> I have new Intel DG33FB mainboard.
>>>
>>>
>>> Mar  2 20:47:19 joker1 kernel: iTCO_vendor_support: vendor-support=0
>>> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver 
>>> v1.02 (26-Jul-2007)
>>> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Found a ICH9DH TCO device 
>>> (Version=2, TCOBASE=0x0460)
>>> Mar  2 20:47:19 joker1 kernel: iTCO_wdt: initialized. heartbeat=30 sec 
>>> (nowayout=0)
>>> ...
>>> Mar  4 14:22:59 joker1 kernel: iTCO_wdt: Unexpected close, not stopping 
>>> watchdog!
>>>
>>>
>>> I start watchdog.c and then kill it expecting the system to reboot - but 
>>> it doesn't.
>>>
>>> Isn't this how it is supposed to work?
>>>       
>
> This is indeed how it should work. It's indeed strange that the system doesn't
> reboot. If I find some time I will give you some test code to run.
>
> Greetings,
> Wim.
>
>
>   
That would be much appreciated. One of the reasons I bought this mother 
board was the WDT.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



