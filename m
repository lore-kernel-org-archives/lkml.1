Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXJLMqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXJLMqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbXJLMq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:46:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53349 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753430AbXJLMqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:46:25 -0400
Date: Fri, 12 Oct 2007 14:46:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Michael Leun <ml@newton.leun.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: solved: 2.6.23 && fglrx && s2ram
Message-ID: <20071012124654.GG3620@stusta.de>
References: <20071012000722.3cbf17b6@elektra.leun.net> <200710120131.17897.rjw@sisk.pl> <20071012014907.0005aab7@elektra.leun.net> <20071012000634.GC3620@stusta.de> <470F698A.2020200@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <470F698A.2020200@tmr.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 08:33:14AM -0400, Bill Davidsen wrote:
> Adrian Bunk wrote:
>> On Fri, Oct 12, 2007 at 01:49:07AM +0200, Michael Leun wrote:
>>> On Fri, 12 Oct 2007 01:31:17 +0200
>>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>>
>>>> Hi,
>>>>
>>>> On Friday, 12 October 2007 00:07, Michael Leun wrote:
>>>>> Hello,
>>>>>
>>>>> (please, don't blame me for using the binary only driver, I will
>>>>> happily switch to a open source one once it properly runs mplayer,
>>>>> e.g.).
>>>>>
>>>>> Renaming the config options for suspend/sleep broke fglrx power
>>>>> management.
>>>> It looks like your patch is against the fglrx driver, isn't it?
>>> It is - I should have mentioned that, sorry.
>> This makes it 100% off-topic for linux-kernel - please send patches for 
>> illegal modules to the vendors of these modules and not here.
> Which would help the actual users of the module not one whit. Whereas 
> putting the patch here helps the people who need it and allows multiple 
> people to complain to the vendor.
>...

The vendor has his own forums and support channels.
That's what the term "off-topic" describes.

And what's worst is that people on this list might become tainted 
by seeing part of the fglrx source code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

