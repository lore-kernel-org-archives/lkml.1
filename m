Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbXJLM0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbXJLM0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbXJLMZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:25:59 -0400
Received: from mail.tmr.com ([64.65.253.246]:45543 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbXJLMZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:25:59 -0400
Message-ID: <470F698A.2020200@tmr.com>
Date: Fri, 12 Oct 2007 08:33:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Michael Leun <ml@newton.leun.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: solved: 2.6.23 && fglrx && s2ram
References: <20071012000722.3cbf17b6@elektra.leun.net> <200710120131.17897.rjw@sisk.pl> <20071012014907.0005aab7@elektra.leun.net> <20071012000634.GC3620@stusta.de>
In-Reply-To: <20071012000634.GC3620@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Oct 12, 2007 at 01:49:07AM +0200, Michael Leun wrote:
>> On Fri, 12 Oct 2007 01:31:17 +0200
>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>
>>> Hi,
>>>
>>> On Friday, 12 October 2007 00:07, Michael Leun wrote:
>>>> Hello,
>>>>
>>>> (please, don't blame me for using the binary only driver, I will
>>>> happily switch to a open source one once it properly runs mplayer,
>>>> e.g.).
>>>>
>>>> Renaming the config options for suspend/sleep broke fglrx power
>>>> management.
>>> It looks like your patch is against the fglrx driver, isn't it?
>> It is - I should have mentioned that, sorry.
> 
> This makes it 100% off-topic for linux-kernel - please send patches for 
> illegal modules to the vendors of these modules and not here.
> 
Which would help the actual users of the module not one whit. Whereas 
putting the patch here helps the people who need it and allows multiple 
people to complain to the vendor.

If this module violates some law you should report it to the appropriate 
authorities rather than posting it here, otherwise you should probably 
should not use the term illegal casually.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
